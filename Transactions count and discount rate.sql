-- This query selects users (based on historical data, prior to 2022-01-01) to identify test and Contro groups
-- In the first step step, all opt-in users are selected, irespective of their status (test or control group)
WITH all_opt_in_users AS (
  SELECT
    DISTINCT t.user_crm_id,
    u.plus_tier
  FROM (SELECT DISTINCT * FROM `warehouse.transactions` WHERE date < '2022-01-01') AS t
  LEFT JOIN `warehouse.users` AS u
  USING(user_crm_id)
  WHERE opt_in_status = TRUE
),

-- The Test group filters out users from previous CTE when their PrismPlus status is true
TestGroup As(
SELECT *
FROM all_opt_in_users
WHERE plus_tier IS NOT NULL
),

-- Transactional data for the Test group
TestTransactions AS(
SELECT
  t.user_crm_id,
  u.plus_tier,
  u.city AS user_city,
  t.transaction_id,
  t.date AS transaction_date,
  -- total items in a transaction
  SUM(ti.item_quantity) AS items_count,
  -- Cost of the items in a transaction using quantity and price
  ROUND(SUM(ti.item_quantity * (pc.cost_of_item + 5.24)),2) AS cost,
  -- Undiscounted revenue from the items in a transaction using quantity and price
  ROUND(SUM(ti.item_quantity * ti.item_price),2) AS undiscounted_revenue,
  -- Transaction revenue for a given transaction id, inclusive of discounts (tier benefits + coupons)
  ROUND(AVG(t.transaction_revenue),2) AS transaction_revenue,
  -- Creates category of discount coupons based on the last 2 letters, 50% off for PRSMFRND coupons
  MAX(CASE
    WHEN t.transaction_coupon IS NULL THEN '00% OFF'
    WHEN t.transaction_coupon LIKE '%10' THEN '10% OFF'
    WHEN t.transaction_coupon LIKE '%15' THEN '15% OFF'
    WHEN t.transaction_coupon LIKE '%20' THEN '20% OFF'
    WHEN t.transaction_coupon LIKE '%25' THEN '25% OFF'
    WHEN t.transaction_coupon LIKE '%30' THEN '30% OFF'
    WHEN t.transaction_coupon LIKE '%35' THEN '35% OFF'
    WHEN t.transaction_coupon LIKE '%40' THEN '40% OFF'
    WHEN t.transaction_coupon LIKE '%45' THEN '45% OFF'
    WHEN t.transaction_coupon LIKE 'PRSMFRND%' OR t.transaction_coupon LIKE '%50'THEN '50% OFF'
    ELSE 'Other'
  END) AS discount_coupon,
  --Revenue for a transactions due to shipping
  ROUND(AVG(t.transaction_shipping),2) AS shipping_revenue,
FROM (SELECT DISTINCT * FROM warehouse.transactions) AS t
LEFT JOIN warehouse.users AS u
ON t.user_crm_id = u.user_crm_id
LEFT JOIN (SELECT DISTINCT * FROM warehouse.transactionsanditems) AS ti
ON t.transaction_id = ti.transaction_id
LEFT JOIN (SELECT DISTINCT * FROM warehouse.product_costs) AS pc
ON ti.item_id = pc.item_id
WHERE t.user_crm_id IN (SELECT DISTINCT user_crm_id FROM TestGroup)
GROUP BY 1,2,3,4,5
)

--To calculate discount offered to tiered users, we select transactions from 2022-01-01 onwards
--2022-01-01 was when the PrismPlus program was implemented
--To account for the discounts offered to tiered users, we select transactions where NO discount coupons are involved.
SELECT
  plus_tier,
  COUNT(transaction_id) AS transaction_count,
  ROUND(SUM(undiscounted_revenue),2) AS total_undiscounted_revenue,
  ROUND(SUM(transaction_revenue),2) AS total_transaction_revenue,
  ROUND(SUM(undiscounted_revenue)-SUM(transaction_revenue),2) AS total_discounts,
  ROUND((SUM(undiscounted_revenue)-SUM(transaction_revenue))/SUM(undiscounted_revenue)*100, 1) AS discount_rate
FROM TestTransactions
--The last filter is used to make sure that the discount is in place (for a cleaner data)
--Some transactions indicate that no discount was offered to tiered users
WHERE transaction_date >= '2022-01-01' AND discount_coupon = '00% OFF' AND undiscounted_revenue <> transaction_revenue
GROUP BY 1
ORDER BY 1
