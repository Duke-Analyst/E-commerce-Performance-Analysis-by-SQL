--Project 1- eCommerce

/*Query 01: calculate total visit, pageview, transaction 
for Jan, Feb and March 2017 (order by month)*/

select 
       format_date('%Y%m',parse_date('%Y%m%d', date)) month
      ,sum(totals.visits) visits
      ,sum(totals.pageviews) pageviews
      ,sum(totals.transactions) transactions
from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
where _table_suffix between '0101' and '0331'
group by 1
order by 1;


/* Query 02: Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit) (order by total_visit DESC)
Hint: Bounce session is the session that user does not raise any click after landing on the website */

select trafficSource.source
      ,sum(totals.visits)  total_visits
      ,sum(totals.bounces) total_bounces
      ,round(sum(totals.bounces)*100.00/sum(totals.visits),3) bounce_rate
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
group by 1
order by 2 desc;


/*Query 3: Revenue by traffic source by week, by month in June 2017 */

with revenue_month as (
      select 
            'Month' as time_type
            ,format_date('%Y%m',parse_date('%Y%m%d', date))
            ,trafficSource.source
            ,sum(product.productRevenue)/1000000 revenue
            
      from `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
      unnest (hits) hits,
      unnest (hits.product) product
      where product.productRevenue is not null
      group by 1,2,3
),

revenue_week as (
      select 
            'Week' as time_type
            ,format_date('%Y%W',parse_date('%Y%m%d', date))
            --,format_date('%Y%U',parse_date('%Y%m%d', date))
            --chỉnh lại format element, %U nó mang ý nghĩa khác
            ,trafficSource.source
            ,sum(product.productRevenue)/1000000 revenue
            
      from `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
      unnest (hits) hits,
      unnest (hits.product) product
      where product.productRevenue is not null
      group by 1,2,3
)

select * from revenue_month
union all
select * from revenue_week
order by revenue desc;

/*Query 04: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.*/

with purchaser as (
    select 
         format_date('%Y%m',parse_date('%Y%m%d', date)) month
        ,count(distinct(fullVisitorId)) count_purchaser
        ,sum(totals.pageviews) as purchaser_pageviews
    from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    unnest(hits) hits,
    unnest(hits.product) product 
    where totals.transactions >= 1 
        and productRevenue is not null
        and _table_suffix between '0601' and '0731'
    group by 1
    order by 1
),

non_purchaser as (
    select 
         format_date('%Y%m',parse_date('%Y%m%d', date)) month
        ,count(distinct(fullVisitorId)) as count_non_purchaser
        ,sum(totals.pageviews) as non_perchaser_pageviews
    from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    unnest(hits) hits,
    unnest(hits.product) product 
    where totals.transactions is null
        and productRevenue is null
        and _table_suffix between '0601' and '0731'
    group by 1
    order by 1
)

select 
     month
    ,purchaser_pageviews/count_purchaser as avg_pageviews_purchase
    ,non_perchaser_pageviews/count_non_purchaser as avg_pageviews_non_purchase
from non_purchaser
full join purchaser
using (month);


/*Query 05: Average number of transactions per user that made a purchase in July 2017*/

select 
     format_date('%Y%m',parse_date('%Y%m%d', date)) month
    ,sum(totals.transactions)/count(distinct(fullVisitorId)) avg_total_transactions_per_user
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
unnest(hits) hits,
unnest(hits.product) product 
where totals.transactions >= 1 
and product.productRevenue is not null
group by month; 

/*Query 06: Average amount of money spent per session. Only include purchaser data in July 2017*/

select 
     format_date('%Y%m',parse_date('%Y%m%d', date)) month
    ,round((sum(productRevenue)/count(totals.visits))/1000000,2) as avg_revenue_by_user_per_visit
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
unnest(hits) hits,
unnest(hits.product) product 
where totals.transactions is not null and product.productRevenue is not null
group by month; 


/*Query 07: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.*/

with buyer_list as (
    select
        distinct fullvisitorid
    from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
    unnest(hits) as hits,
    unnest(hits.product) as product
    where product.v2productname = "YouTube Men's Vintage Henley"
    and totals.transactions >= 1
    and product.productrevenue is not null
)

select
    product.v2productname as other_purchased_products,
    sum(product.productquantity) as quantity
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
    unnest(hits) as hits,
    unnest(hits.product) as product
join buyer_list using(fullvisitorid)
where product.v2productname != "YouTube Men's Vintage Henley"
    and product.productrevenue is not null
group by other_purchased_products
order by quantity desc;




/*"Query 08: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase.
Add_to_cart_rate = number product  add to cart/number product view. Purchase_rate = number product purchase/number product view. The output should be calculated in product level."*/


with product_data as (
    select
        format_date('%Y%m', parse_date('%Y%m%d', date)) as month,
        count(case when ecommerceaction.action_type = '2' then product.v2productname end) as num_product_view,
        count(case when ecommerceaction.action_type = '3' then product.v2productname end) as num_add_to_cart,
        count(case when ecommerceaction.action_type = '6' and product.productrevenue is not null then product.v2productname end) as num_purchase
    from `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
    unnest(hits) as hits,
    unnest(hits.product) as product
    where _table_suffix between '20170101' and '20170331'
    and ecommerceaction.action_type in ('2','3','6')
    group by month
    order by month
)

select
    *,
    round(num_add_to_cart / num_product_view * 100, 2) as add_to_cart_rate,
    round(num_purchase / num_product_view * 100, 2) as purchase_rate
from product_data;

