
--Unit economics before and after launch

WITH users_cte AS (
SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY user_crm_id ORDER BY latest_login_date DESC) AS row_num -- removing duplicates
    FROM
      warehouse.users),
     
-- Cleaned users data above
all_opt_in_users AS (
  SELECT 
    t.user_crm_id,
    plus_tier, 
    COUNT(DISTINCT t.transaction_id) AS transaction_count, 
    SUM(t.transaction_revenue) AS transaction_revenue
  FROM (
    SELECT DISTINCT * FROM `warehouse.transactions`
    WHERE date < "2022-01-01"
  ) AS t
  LEFT JOIN users_cte AS u
  USING(user_crm_id)
  WHERE opt_in_status = TRUE AND row_num = 1
  GROUP BY user_crm_id, plus_tier
),
     
-- Finding potential plus users above (loyalty program member -- test group)
     
pseudo_status_calc AS (
  SELECT 
    CASE 
      WHEN transaction_count = 1 THEN "pseudo_bronze"
      WHEN transaction_count = 2 THEN "pseudo_silver"
      WHEN transaction_count = 3 THEN "pseudo_gold"
      WHEN transaction_count >= 4 THEN "pseudo_platinum"
    END AS plus_or_pseudo_status,
    user_crm_id,
    plus_tier
  FROM all_opt_in_users 
  WHERE plus_tier IS NULL
  UNION ALL
  SELECT 
    CASE 
      WHEN plus_tier = 'Bronze' THEN 'Actual Bronze'
      WHEN plus_tier = 'Silver' THEN 'Actual Silver'
      WHEN plus_tier = 'Gold' THEN 'Actual Gold'
      WHEN plus_tier = 'Platinum' THEN 'Actual Platinum'
    END AS plus_or_pseudo_status,
    user_crm_id,
    plus_tier
  FROM all_opt_in_users 
  WHERE prism_plus_tier IS NOT NULL
),
-- DIVIDING prism_plus Users above
-- Transaction Data
  -- transaction count
  -- transaction revenue
  -- ADDING - Gross Profit
  -- ADDING - Return Rate
  -- ADDING - AVERAGE revenue per user
transaction_data AS (
  SELECT 
    user_crm_id,
    COUNT(DISTINCT transaction_id) AS transaction_count,
    SUM(transaction_revenue) AS total_revenue,
   -- SUM(transaction_revenue - ((cost_of_item + 5.24) *item_quantity))
  FROM `warehouse.transactions`
  WHERE date < "2022-01-01"
  GROUP BY user_crm_id
)
SELECT 
  COUNT(psc.user_crm_id) AS user_count,
  AVG(td.transaction_count) AS AOF,
  AVG(td.total_revenue / td.transaction_count) AS ABV,
  SUM(td.total_revenue) AS total_revenue, -- AVERAGE REVENUE PER USER
  psc.plus_or_pseudo_status
FROM pseudo_status_calc AS psc
LEFT JOIN transaction_data AS td
  USING(user_crm_id)
GROUP BY psc.plus_or_pseudo_status
ORDER BY psc.plus_or_pseudo_status;
