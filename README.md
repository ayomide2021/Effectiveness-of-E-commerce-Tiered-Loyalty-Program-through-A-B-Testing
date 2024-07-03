# Analysis of Effectiveness of E-commerce Tiered-Loyalty Program through A/B Testing

# Executive Summary

The analysis of the impact of discounts on customer behavior reveals that while these incentives drive revenue through repeat purchases, they also significantly affect profitability. Based on the findings, I recommend two potential solutions for moving forward:

1.	Solution 1: Discontinue the Loyalty Program
   
o	Impact: By discontinuing the loyalty program, the company can save over £22K in costs associated with excessive discounts given to the loyalty program members.

o	Rationale: This solution eliminates the direct financial impact of the discounts, thus improving overall profitability. However, it risks losing the repeat purchases driven by the loyalty program.

2	Solution 2: Adjust and Continue the Loyalty Program

o	Adjust Discount Rates: Modify the discount rates for each loyalty tier group to optimize profitability while maintaining customer engagement.

o	Gradual Phase-Out of High-Discount Coupons: Gradually phase out high-discount coupons (40% OFF and 50% OFF) to reduce the financial impact.

o	Offer Non-Discount Benefits: Introduce non-discount benefits for loyalty members to retain customer loyalty without heavily relying on financial discounts.

o	Impact: This adjustment could potentially save over £12K while preserving customer loyalty and maintaining a balanced approach to incentives.

By implementing either of these solutions, the company can better manage the trade-off between driving revenue through repeat purchases and maintaining profitability. The recommended adjustments aim to find a middle ground that sustains customer engagement without compromising the company's financial health.


# Business Problem:

Customer retention has been an issue for a fictional e-commerce company for the past two years. Stakeholders and management have observed that most customers purchase once and do not return. Given that retaining existing customers is more cost-effective than acquiring new ones, the company has decided to implement a pilot project offering benefits in the form of discounts to certain customers. The aim is to analyze customer behaviors through A/B testing to determine the effectiveness of these discounts on customer retention.


Using A/B testing, the company aims to answer the following questions:

•	What characterizes the behavior of customers in the test group compared to the control group?

•	What factors trigger purchases among these customers?

•	How profitable are the customers in the test group compared to the control group?

•	Do the discounts lead to increased overall spending or just reduced margins?

•	How engaged are the customers in the test group compared to the control group?

•	Are there significant differences in engagement metrics (e.g., repeat purchases, time spent on the website, interaction with marketing campaigns)?


Objective:

The primary objective is to understand and improve customer retention by identifying the impact of discounts on customer behavior.
By the end of this project, the company expects to have a clear understanding of:

•	The effectiveness of discounts in improving customer retention.

•	Key behavioral triggers and characteristics of retained customers.

•	The overall profitability of the discount strategy.

•	Enhanced customer engagement resulting from the discounts. 


# Data Description
Dataset Size: Over 2 billion rows of data pipelines

Source: Google BigQuery

Key Attributes: customer id, transaction id, Purchase date, transaction revenue, customer demographics, item quantity, item price, cost of goods sold (COGS). 

# Tech Used

•	BigQuery (database)

•	SQL: CTEs, joins, aggregate functions, window functions, case

•	Power BI: Dax, Calculated columns, data visualization, data modeling

•	Google Sheets: Formulas, pivot tables, version history, sharing and permissions

•	Python: Pandas, Matplotlib, Numpy




# Process and Methodology
## Data Cleaning
•	Utilized SQL to remove duplicates 
•	Handled null values.
•	Ensured data consistency and accuracy.
•	Removed irrelevant data from the analysis. 

## methodology

The pilot project involves dividing customers into two groups:

•	Test Group: Customers who receive discounts.

•	Control Group: Customers who do not receive discounts.



## Data Analysis and Visualization
•	Exported cleaned  and aggregated data to Google Sheets for initial analysis.

•	Created interactive dashboards in Power BI to visualize key metrics and trends.


# Results and Insights
## Key Findings and Insights
•	The use of coupons by company loyalty program customers skyrocketed after the launch of the Loyalty program. 

•	The loyalty program performs better in some metrics but worse off in others. For instance, while the revenue and average order frequency are increasing, the average basket value and profit margin are decreasing. 

•	The loyalty program improved retention through repeat purchases by the loyalty program customers. 


![Kazeem Odunlami_project-1](https://github.com/ayomide2021/Effectiveness-of-E-commerce-Tiered-Loyalty-Program-through-A-B-Testing/assets/83126882/31851c3a-ee92-4643-b0f6-4e6e53445271)

![Kazeem Odunlami_project-2](https://github.com/ayomide2021/Effectiveness-of-E-commerce-Tiered-Loyalty-Program-through-A-B-Testing/assets/83126882/4d699f5b-4eec-4bcc-9158-5f471948b3af)

![Kazeem Odunlami_project-3](https://github.com/ayomide2021/Effectiveness-of-E-commerce-Tiered-Loyalty-Program-through-A-B-Testing/assets/83126882/2904bace-26e6-4a1b-a7ed-944adb82e917)

![Kazeem Odunlami_project-4](https://github.com/ayomide2021/Effectiveness-of-E-commerce-Tiered-Loyalty-Program-through-A-B-Testing/assets/83126882/156d8ace-5634-4aa7-a98d-29860b06d752)



# Recommendations and Impacts
Solution 1: Discontinue the Loyalty Program

o	Impact: By discontinuing the loyalty program, the company can save over £22K in costs associated with excessive discounts given to the loyalty program members.

o	Rationale: This solution eliminates the direct financial impact of the discounts, thus improving overall profitability. However, it risks losing the repeat purchases driven by the loyalty program.

Solution 2: Adjust and Continue the Loyalty Program

o	Adjust Discount Rates: Modify the discount rates for each loyalty tier group to optimize profitability while maintaining customer engagement.

o	Gradual Phase-Out of High-Discount Coupons: Gradually phase out high-discount coupons (40% OFF and 50% OFF) to reduce the financial impact.

o	Offer Non-Discount Benefits: Introduce non-discount benefits for loyalty members to retain customer loyalty without heavily relying on financial discounts.

o	Impact: This adjustment could potentially save over £12K while preserving customer loyalty and maintaining a balanced approach to incentives.


# Conclusion

This project demonstrated the significant impact of data-driven decisions on business performance. By leveraging advanced data analytics techniques, I provided actionable insights from A/B testing that led to improved customer retention and increased revenue while maintaining customer satisfaction and loyalty.

# Next Steps:

Based on the findings, the company will make informed decisions about:

•	Scaling the discount strategy to a larger customer base.

•	Implementing additional retention strategies.

•	Optimizing marketing efforts to target high-value customers effectively.


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
