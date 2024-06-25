# Effectiveness-of-E-commerce-Tiered-Loyalty-Program-through-A-B-Testing

# Overview
In this project, I analyzed a large e-commerce dataset to uncover valuable insights into the effectiveness of a tiered loyalty program, focusing on the impact of coupons and discounts on customer retention, revenue, and profitability. Utilizing SQL, Google Sheets, and Power BI, I processed and visualized over 2 billion rows of data stored in Google BigQuery.

A/B test analysis was conducted to evaluate the impact of the loyalty program on customer retention and company profitability.

Through data analysis, two potential solutions were proposed to optimize the loyalty program to ensure customer engagement while maximizing revenue and minimizing costs.


# Data Description
Dataset Size: Over 2 billion rows of data pipelines

Source: Google BigQuery

Key Attributes: customer id, transaction id, Purchase date, transaction revenue, customer demographics, item quantity, item price, cost of goods sold (COGS). 

# Tech Used

•	BigQuery (database)

•	SQL

•	Power BI

•	Google Sheets

•	Python




# Process and Methodology
## Data Cleaning
•	Utilized SQL to remove duplicates 
•	Handled null values.
•	Ensured data consistency and accuracy.
•	Removed irrelevant data from the analysis. 


## Data Analysis and Visualization
•	Exported cleaned  and aggregated data to Google Sheets for initial analysis.

•	Created interactive dashboards in Power BI to visualize key metrics and trends.

![Week 10 Presentation_Kazeem Odunlami_page-0003](https://github.com/ayomide2021/Effectiveness-of-E-commerce-Tiered-Loyalty-Program-through-A-B-Testing/assets/83126882/497d3651-b1d4-4b71-ac2c-8afdfaaf4478)

![Week 10 Presentation_Kazeem Odunlami_page-0004](https://github.com/ayomide2021/Effectiveness-of-E-commerce-Tiered-Loyalty-Program-through-A-B-Testing/assets/83126882/c591dbd3-9b65-4639-a444-9c23ae10789e)

![Presentation1_page-0001](https://github.com/ayomide2021/Effectiveness-of-E-commerce-Tiered-Loyalty-Program-through-A-B-Testing/assets/83126882/f3068d26-b092-435f-a1a5-f8938c8f9b27)


![Week 10 Presentation_Kazeem Odunlami_page-0005](https://github.com/ayomide2021/Effectiveness-of-E-commerce-Tiered-Loyalty-Program-through-A-B-Testing/assets/83126882/128acde4-c6ac-4b92-bf7b-ba7609daac32)

![Week 10 Presentation_Kazeem Odunlami_page-0006](https://github.com/ayomide2021/Effectiveness-of-E-commerce-Tiered-Loyalty-Program-through-A-B-Testing/assets/83126882/a4fef9a9-cc10-40f0-ae49-8c3a90ba0d05)


# Results and Insights
## Key Findings and Insights
•	The use of coupons by company tier plus customers skyrocketed after the launch of the Loyalty program. 

•	The loyalty program performs better in some metrics but worse off in others. For instance, while the revenue and average order frequency are increasing, the average basket value and profit margin are decreasing. 

•	The loyalty program improved retention through repeat purchases by tier plus customers. 

# Recommendations and Impacts
•	Option1: Discontinue the loyalty program. Over £22K can be from saved excessive discounts to tier  plus  customers.

•	Option 2: Adjust the discount rate for each  tier group + Gradual Phase-Out of High Discount Coupon (40%OFF 50%OFF). Offer tier plus members early access to product launches and sales. Through this adjustment, the company can potentially save over £12k while maintaining customer loyalty.

# Conclusion

This project demonstrated the significant impact of data-driven decisions on business performance. By leveraging advanced data analytics techniques, I provided actionable insights from A/B testing that led to improved customer retention and increased revenue while maintaining customer satisfaction and loyalty.

# Technical Details 
## Sample SQL query for analysis
--- users_count for each group

-- Change date for post launched count

#### --CTE to divide group into Test and control group

WITH new_data AS 

(SELECT  *,-- user_crm_id, prism_plus_tier, prism_group, 

CASE WHEN prism_group  = 'Test'  AND prism_plus_tier = 'Bronze' THEN 'Actual Bronze'

WHEN prism_group  = 'Test'  AND prism_plus_tier = 'Silver' THEN 'Actual Silver'

WHEN prism_group  = 'Test'  AND prism_plus_tier = 'Gold' THEN 'Actual Gold'

WHEN prism_group  = 'Test'  AND prism_plus_tier = 'Platinum' THEN 'Actual Platinum'

WHEN prism_group  = 'Control'  AND prism_plus_tier = 'Bronze' THEN 'Psuedo Bronze'

WHEN prism_group  = 'Control'  AND prism_plus_tier = 'Silver' THEN 'Pseudo Bronze'

WHEN prism_group  = 'Control'  AND prism_plus_tier = 'Gold' THEN 'Pseudo Gold'

WHEN prism_group  = 'Control'  AND prism_plus_tier = 'Platinum' THEN 'Pseudo Platinum'

END AS AB_tier

FROM `p-insights.ASW_AB_info` ),


 new_count AS (SELECT *

 FROM new_data
 
 LEFT JOIN `warehouse.transactions`

 USING (user_crm_id)
 
WHERE (user_crm_id IN (SELECT user_crm_id FROM `warehouse.transactions`) AND date <='2022-01-01'))

SELECT user_crm_id, AB_tier, COUNT (DISTINCT user_crm_id)

FROM new_count

GROUP BY user_crm_id, AB_tier

## Sample Power BI Dax
Date =

ADDCOLUMNS (
CALENDAR (DATE (2020, 1, 1), DATE (2022, 12, 31)),

"Year", YEAR([Date]),

"Month", FORMAT([Date], "mmmm"),

"Quarter", QUARTER([Date])
)
