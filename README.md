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

* To calculate the total visits, pageviews, and transactions for January, February, and March of 2017, I first format the date to show only the year and month. Then, I filter for dates between January 1st and March 31st by specifying _table_suffix values. Next, I sum the totals for visits, pageviews, and transactions, grouping the results by month. Finally, I order the output by month to display the data sequentially from January to March.

![image](https://github.com/user-attachments/assets/49ba0cbe-54c6-4b24-8e3f-f2a76c08abe5)

**The result:**
![image](https://github.com/user-attachments/assets/a51914d9-5466-4ee9-a5ef-e7e8d89f790b) \\



## Request 02: What is the bounce rate per traffic source in July 2017? 

* To determine the bounce rate by traffic source for July 2017, I start by summing the total visits and bounces per traffic source. Then, I calculate the bounce rate as the ratio of total bounces to total visits, expressed as a percentage. The results are grouped by traffic source and ordered by total visits in descending order to prioritize traffic sources with the highest visitor counts.

![image](https://github.com/user-attachments/assets/c7269a77-ac4c-4b48-be09-b9e66ab47ef3)

**The result:**
![image](https://github.com/user-attachments/assets/e2ad2cbf-9d15-4101-a3cb-ef37f2a47a06)

## Request 03: How much revenue by traffic source by week, by month in June 2017 is there?
To find revenue by traffic source in June 2017, I calculate revenue by both week and month. 
* For monthly revenue, I aggregate product revenue by traffic source and format the date by month. 
![image](https://github.com/user-attachments/assets/7e8de154-8522-4070-b04e-957ab044b062)

* For weekly revenue, I similarly aggregate product revenue by traffic source and format the date by week. 
![image](https://github.com/user-attachments/assets/db3e1513-7384-437c-a07b-bfd56445c118)

* After defining these two datasets, I combine them using UNION ALL and order the output by revenue in descending order to show the top-earning sources.

![image](https://github.com/user-attachments/assets/a63ae9fe-9a07-45ab-85a8-cc38cf526e81)


**The result:**
![image](https://github.com/user-attachments/assets/84b01893-fa15-42ed-9aa5-4158da6c4529)

## Request 04: How many the average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, and July 2017 are there?
To calculate the average pageviews for purchasers versus non-purchasers in June and July 2017, I define two separate datasets. 
* The first calculates the total pageviews and unique purchaser count for users with transactions
![image](https://github.com/user-attachments/assets/2365a281-1948-483d-96c6-7c231216a512)

* The second calculates total pageviews and unique non-purchaser count for users without transactions. 
![image](https://github.com/user-attachments/assets/157d686b-8984-4f72-8a7a-e38eb6b4fd91)

* Finally, I calculate the average pageviews by dividing the pageviews by the count for each group and join the two datasets by month to compare both groups side-by-side.
![image](https://github.com/user-attachments/assets/45ae1435-b5fd-4669-af24-c86d8b9954a8)



**The result:**
![image](https://github.com/user-attachments/assets/ba58e1fb-6181-4712-85aa-019b156594ca)


## Request 05: How many the average number of transactions per user that made purchases in July 2017 are there?
* To find the average number of transactions per purchasing user in July 2017, I calculate the total transactions and the distinct count of users with at least one transaction. Dividing the total transactions by the number of unique purchasing users gives the average transactions per purchaser. The result is grouped by month to ensure data accuracy for July.
  
![image](https://github.com/user-attachments/assets/25838d09-cd0b-47a6-9854-e5b43368014f)


**The result:**

![image](https://github.com/user-attachments/assets/20309499-22f6-430e-9770-e3b22707a8d4)



## Request 06: How much the average amount of money spent per session is there? (Only include purchaser data in July 2017)
* To determine the average amount spent per session in July 2017 for purchasers, I calculate the total revenue from purchases and divide it by the total number of visits in which transactions occurred.

* After calculating the average revenue per visit, I round the result to two decimal places and group by month, providing an overview of average spending per session for July.
  
![image](https://github.com/user-attachments/assets/5957d1e8-9156-4774-b03a-8f39461df268)


**The result:**

![image](https://github.com/user-attachments/assets/65012f7a-3467-4e94-9568-4d7c9dd4b4e4)


**Request 07: Which other products were purchased by customers who purchased the product "YouTube Men's Vintage Henley" in July 2017?**
* To find other products purchased by customers who bought the "YouTube Men's Vintage Henley" in July 2017, I start by creating a list of unique user IDs (fullVisitorId) for those who purchased this specific item.
  
![image](https://github.com/user-attachments/assets/39ae2fd1-d770-47ad-a4f2-c5f531aa45dc)

* Next, I join this list with session data for July 2017 to identify additional products purchased by these same users, excluding the "YouTube Men's Vintage Henley" itself. 
* Finally, I calculate the total quantity of each additional product purchased, group the results by product name, and order by quantity in descending order to show the most frequently purchased complementary items.
  
![image](https://github.com/user-attachments/assets/27866057-95c7-4756-85d1-16abca7099a8)


**The result:**

![image](https://github.com/user-attachments/assets/eacd63a7-dabf-4af1-baec-349ceb031ca9)


## Request 08: Provide cohort map from product view to add to cart to purchase in Jan, Feb, and March 2017. For example, 100% product view then 40% add_to_cart, and 10% purchase.
* To build a cohort map tracking user actions from product view to add-to-cart to purchase from January to March 2017, I calculate the counts of product views, add-to-cart actions, and purchases by month. 
![image](https://github.com/user-attachments/assets/5ebc1d00-5722-479b-945f-20b71e92932c)


Using this data, I calculate the add-to-cart rate as the ratio of add-to-cart actions to views, and the purchase rate as the ratio of purchases to views. Grouping by month allows for a clear monthly cohort comparison, helping to understand conversion rates at each stage in the user journey.
![image](https://github.com/user-attachments/assets/c971b9b6-5207-4c67-9c32-a286081e5642)


**The result:**
![image](https://github.com/user-attachments/assets/9259cca6-ab32-4015-9405-579347f50421)

