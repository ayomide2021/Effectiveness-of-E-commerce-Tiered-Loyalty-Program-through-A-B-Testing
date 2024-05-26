WITH filtered_transactions AS (
   
   -- Use now
    SELECT date, user_crm_id, transaction_id, transaction_total, transaction_revenue
    FROM (SELECT DISTINCT * FROM warehouse.transactions WHERE date >= '2022-01-01')
    WHERE user_crm_id IN (
        SELECT user_crm_id 
        FROM `prism-insights.red_team_mc1.ASW_AB_info`
        GROUP BY user_crm_id
    )
),
item_costs AS (
    SELECT i.date, i.transaction_id, SUM((pc.cost_of_item + 5.24) * i.item_quantity) AS item_cost
    FROM (SELECT DISTINCT * FROM warehouse.transactionsanditems WHERE date >= '2022-01-01') AS i
    LEFT JOIN `warehouse.product_costs` AS pc USING(item_id)
    WHERE i.transaction_id IN (SELECT transaction_id FROM filtered_transactions)
    GROUP BY i.date, i.transaction_id
),
transaction_profits AS (
    SELECT t.date, t.user_crm_id, c.item_cost, t.transaction_id, t.transaction_total - c.item_cost AS transaction_profit, transaction_revenue
    FROM filtered_transactions AS t
    JOIN item_costs AS c USING(date, transaction_id)
),
transactions_final AS (
    SELECT 
        p.date, 
        u.prism_group, 
        u.prism_plus_tier, 
        p.item_cost, 
        COUNT(p.transaction_id) AS num_transactions, 
        COALESCE(ROUND(SUM(p.transaction_profit), 2), 0) AS transaction_profit,transaction_revenue,
        u.AB_tier
    FROM transaction_profits AS p
    LEFT JOIN (
        SELECT user_crm_id, prism_plus_tier, prism_group, 
            CASE 
                WHEN prism_group = 'Test' AND prism_plus_tier = 'Bronze' THEN 'Actual Bronze'
                WHEN prism_group = 'Test' AND prism_plus_tier = 'Silver' THEN 'Actual Silver'
                WHEN prism_group = 'Test' AND prism_plus_tier = 'Gold' THEN 'Actual Gold'
                WHEN prism_group = 'Test' AND prism_plus_tier = 'Platinum' THEN 'Actual Platinum'
                WHEN prism_group = 'Control' AND prism_plus_tier = 'Bronze' THEN 'Pseudo Bronze'
                WHEN prism_group = 'Control' AND prism_plus_tier = 'Silver' THEN 'Pseudo Silver'
                WHEN prism_group = 'Control' AND prism_plus_tier = 'Gold' THEN 'Pseudo Gold'
                WHEN prism_group = 'Control' AND prism_plus_tier = 'Platinum' THEN 'Pseudo Platinum'
            END AS AB_tier
        FROM `prism-insights.red_team_mc1.ASW_AB_info`
        GROUP BY user_crm_id, prism_plus_tier, prism_group
    ) AS u USING(user_crm_id)
    GROUP BY p.date, u.prism_group, u.prism_plus_tier, p.item_cost, u.AB_tier, transaction_revenue
    ORDER BY p.date, u.prism_group
)
SELECT 
    date,
    prism_group,
    prism_plus_tier,
    AB_tier,
    item_cost,
    num_transactions,
    transaction_profit,
    transaction_revenue,
    SUM(num_transactions) OVER (PARTITION BY AB_tier ORDER BY date) AS cumulative_transactions,
    ROUND(SUM(transaction_profit) OVER (PARTITION BY AB_tier ORDER BY date), 2) AS cumulative_profit,
     ROUND(SUM(transaction_revenue) OVER (PARTITION BY AB_tier ORDER BY date), 2) AS cumulative_revenue
FROM transactions_final
ORDER BY date, prism_group;
