# Overview
This project aims to provide and statisticize the Website Performance in a period

# Situation
The manager wants to statisticize the results of the Website Performance, to answer a few questions about total visits, revenue, and the average money that customers spend, ...etc...

# The requests about the Website Performance:
* Request 01: How many total visits, pageview, and transactions for Jan, Feb, and March 2017 are there?
* Request 02: What is the bounce rate per traffic source in July 2017?
* Request 03: How much revenue by traffic source by week, by month in June 2017 is there?
* Request 04: How many the average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, and July 2017 are there?
* Request 05: How many the average number of transactions per user that made purchases in July 2017 are there?
* Request 06: How much the average amount of money spent per session is there? (Only include purchaser data in July 2017)
* Request 07: Which other products were purchased by customers who purchased the product "YouTube Men's Vintage Henley" in July 2017. The output should show the product name and the quantity ordered.
* Request 08: Provide cohort map from product view to add to cart to purchase in Jan, Feb, and March 2017. For example, 100% product view then 40% add_to_cart, and 10% purchase.

# Dataset
* The dataset is built by Array Data Structure
* The dataset includes these columns:
<img width="1235" alt="1" src="https://github.com/user-attachments/assets/ddcd67af-ea2e-47c9-8702-22b352824bc6">

# Solution
To solve this case, I will use SQL (Bigquery) to extract and wrangle data following every request

The dataset is built by Array, so I will use UNNEST in every query

These are the functions used:

* Aggregate function: SUM, MIN, MAX
* Date function: format_date
* Numerical function: ROUND
* UNION ALL 
* LEFT JOIN, FULL JOIN
* Common table expression (CTE)

## Request 01: How many total visits, pageview, and transactions for Jan, Feb, and March 2017 are there? 

To calculate the total visits, pageviews, and transactions for January, February, and March of 2017, I first format the date to show only the year and month. Then, I filter for dates between January 1st and March 31st by specifying _table_suffix values. Next, I sum the totals for visits, pageviews, and transactions, grouping the results by month. Finally, I order the output by month to display the data sequentially from January to March.

![image](https://github.com/user-attachments/assets/49ba0cbe-54c6-4b24-8e3f-f2a76c08abe5)

The result:
![image](https://github.com/user-attachments/assets/a51914d9-5466-4ee9-a5ef-e7e8d89f790b)



## Request 02: What is the bounce rate per traffic source in July 2017? 

To determine the bounce rate by traffic source for July 2017, I start by summing the total visits and bounces per traffic source. Then, I calculate the bounce rate as the ratio of total bounces to total visits, expressed as a percentage. The results are grouped by traffic source and ordered by total visits in descending order to prioritize traffic sources with the highest visitor counts.

![image](https://github.com/user-attachments/assets/c7269a77-ac4c-4b48-be09-b9e66ab47ef3)

The result:
![image](https://github.com/user-attachments/assets/e2ad2cbf-9d15-4101-a3cb-ef37f2a47a06)











