CREATE SCHEMA IF NOT EXISTS `ecommerce`;
CREATE DATABASE cte;
use cte;



desc sales;
SELECT * FROM sales;
drop table  sales;



-- Basic Level : 
 
-- 1. List all Unique Product Categories  

SELECT DISTINCT  category 
FROM sales;

WITH distinct_func AS(
          SELECT DISTINCT category
FROM  sales
)
SELECT * FROM  distinct_func;  
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- 2.Find the Number of Unique Customers 

WITH COUNT_CUSTOMER AS (
	 SELECT DISTINCT customer_id
     FROM sales
)
SELECT COUNT(*) AS "TOTAL COUNT"
FROM count_customer;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- 3.Get Total Sales (before discount) per product  

WITH sales_cte AS (
          SELECT product_id,
          ROUND(SUM(price_per_unit * quantity),2) AS 'TOTAL SALES'
          FROM sales
          GROUP BY product_id
          order by SUM(price_per_unit * quantity) DESC 
)
SELECT * FROM sales_cte;
          
 -- ---------------------------------------------------------------------------------------------------------------------------------------------       
-- 4. Find all Orders made in January  
UPDATE sales
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y');

ALTER TABLE sales MODIFY order_date DATE;

WITH jan_order AS (
     SELECT * FROM sales
     WHERE month (order_date) = 1
     AND YEAR(order_date) IN (2025)
)
SELECT * from jan_order;


-- --------------------------------------------------------------------------------------------------        
-- 5. Get the first 5 Orders by Order date  
WITH ordered_cte AS(
SELECT * from sales
ORDER BY ORDER_date ASC
LIMIT 5
)
select * from ordered_cte;


-- -----------------------------------------------------------------------------------

-- 6. Calculate total discount value per order  

WITH tot_disc AS (
select order_id,
ROUND(SUM(quantity * price_per_unit * discount /100),2) as 'total discount'
from sales
group by order_id
order by ROUND(SUM(quantity * price_per_unit * discount /100),2) DESC
)
select * from tot_disc;
-- -------------------------------------------------------------------------------------------------
-- 4Find the number of Orders per region  
WITH region_cte AS(
SELECT region,
count(order_id) as'total order'
from sales
group by region
order by count(order_id) DESC
)
select * from region_cte;
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------- 

-- 5. List all orders with more than 5 items  

WITH order_ct AS (
       SELECT * FROM sales
	   WHERE quantity > 5)
SELECT * from order_ct;
-- -------------------------------------------------------------------------------------------------------

-- 6. Get total revenue after discount 

WITH revenue_cte AS(
               SELECT round(sum(quantity * price_per_unit *(1-discount/100)),2) AS 'net price'
from sales)
select * from revenue_cte;

-- ----------------------------------------------------------------------------------------------

-- 7. Count number of Orders by each payment method  

WITH payment_cte AS(
      SELECT payment_method,
      count(*) AS 'PAYMENT METHOD'
      from sales
      GROUP BY payment_method
      order by payment_method)
      
SELECT * FROM payment_cte;

-- ---------------------------------------------------------------------------------------------
      
-- 8. Show orders where delivery took more than 7 days  
 
WITH delivery_cte AS(
           SELECT order_id,product_name,product_id
           from sales
           WHERE (delivery_days > 7)
)           

SELECT * FROM delivery_cte;

-- -----------------------------------------------------------------------------------------


-- 9. Find the average delivery time per region  
WITH avg_cte AS(
        SELECT region,
        round(AVG(delivery_days),2) AS 'AVG DELIVERY TIME'
        from sales
        group by region
        order by avg(delivery_days) desc)
        
select * from avg_cte;
-- ------------------------------------------------------------------------------------------
-- 10. List all products Ordered more than 100 times in total  

WITH prd_cte as(
     SELECT product_name,sum(quantity) as 'total quantity'
     from sales
     group by product_name
     HAVING  SUM(quantity) >100
     order by sum(quantity) DESC
     )
SELECT * from prd_cte;
-- -------------------------------------------------------------------------------------------

-- 11. List the Top 3 most expensive products (per unit) 

with exp_cte as(
     SELECT DISTINCT product_name, price_per_unit 
     from sales
     order by PRICE_PER_UNIT DESC
     LIMIT 3
     )
SELECT * from exp_cte;
-- -----------------------------------------------------------------------------------------------

-- 12. Calculate total sales for each category 
WITH category_cte as(
 select category,
 concat('$  ',FORMAT(sum(quantity* price_per_unit),2)) as 'total price'
 from sales
 group by category
 order by  concat('$  ',FORMAT(sum(quantity* price_per_unit),2))
 )
 select * from category_cte;
 
 
 
 
-- Intermediate Level : 
-- Most Asked in :  

--  Find Total Revenue per month  

WITH total_revenue_cte AS (
     
     SELECT MONTHNAME(order_date) AS 'Month' ,
     CONCAT(' $' , FORMAT (SUM( quantity * price_per_unit * (1-discount / 100)),2)) as 'total revenue'
     FROM sales
     GROUP BY MONTHNAME(order_date)
)
SELECT * from total_revenue_cte;

SELECT * FROM sales;
-- -------------------------------------------------------------------------------------------------------------------     

--  Compare Sales of each region in last 3 months  

WITH recent_order_cte  AS(
         SELECT * FROM sales
         WHERE order_date  >= CURDATE() - INTERVAL 3 MONTH
         # WHERE order_date  >= current_date -interval '3 months - 'microsoft server studio'
		 # WHERE order_date  >= DATEADD(MONTH,-3 ,CAST(GETDATE() AS DATE)) - 'microsoft server studio'
),
region_sales AS(
         SELECT region, SUM(quantity * price_per_unit) AS 'Total sales'
         FROM sales
         GROUP BY region 
         ORDER BY SUM(quantity * price_per_unit) DESC
         
)
select * FROM recent_order_cte,region_sales;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

--  List Top 5 Customers by total spending (Asked in Google) 
WITH top_consumer AS(
       SELECT customer_id,
       ROUND(sum(quantity* price_per_unit* (1- discount /100)),2) as 'total spending'
       from sales
       group by customer_id
       order by ROUND(sum(quantity* price_per_unit* (1- discount /100)),2) DESC
       limit 5
       )
select * from top_consumer;
-- --------------------------------------------------------------------------------------------------------------------------------------------

--  Average discount by category  
with dis_category as(
        SELECT category,
        ROUND(AVG(discount),2) AS 'AVERAGE DISCOUNT'
        from sales
        GROUP BY category
        order by ROUND(AVG ( discount),2) DESC
        )
SELECT * FROM dis_category;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------

--  Customer with more than 5 orders  

WITH customer_order AS(
      SELECT customer_id ,count(*) order_count
      from sales
      group by customer_id
      HAVING COUNT(*) > 5
)
SELECT * FROM customer_order;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------

--  Calculate profit (sales – Discount) per products  
WITH cost_cte as(
       SELECT product_id,
	   sum(quantity* price_per_unit *(1- discount /100) ) revenue ,
	   sum(quantity* price_per_unit * discount /100) 	 total_discount
       from sales
       group by product_id
)
select product_id,
       ROUND((revenue - total_discount),2) AS profit
FROM cost_cte;
-- -------------------------------------------------------------------------------------------------------------------------------------------------

--  Find Duplicate Orders (Same customer, Product & Date) – (Asked in Flipkart) 
WITH dup_order as(
      select  customer_id 
      product_name,
      order_date, count(*)  AS 'total count'
      from sales
      group by customer_id,  product_id, order_date
      having count(*) >1
      )
select * from dup_order;

-- ------------------------------------------------------------------------------------------------------------------------------------------------

--  Monthly revenue trend for Top – Selling Product – (Asked in Flipkart) 

with top_product as(
SELECT  product_id,product_name
from sales
group by product_id,product_name
order by sum(quantity) DESC
LIMIT 1
),
revenue_month as(
select date_format(order_date , '%Y-%m-01') AS Dates,
ROUND(sum(quantity* price_per_unit),2) total_revenue
from sales
WHERE product_id=(select product_id from top_product)
group by date_format(order_date , '%Y-%m-01')
)
select * from revenue_month,top_product;

WITH revenue_month as(
     SELECT product_id,product_name,monthname(order_date),
     round(sum(quantity * price_per_unit * (1- discount/100)),2)total_revenue
     from sales
     group by product_id,product_name,monthname(order_date) 
     order by total_revenue DESC
     limit 5
     )
     select * from revenue_month;
-- ------------------------------------------------------------------------------------------------------

--  Find most common delivery duration – (Asked in Swiggy) 
 with delivery_duration as(
        select delivery_days ,count(*) as duration
        from sales
        group by delivery_days
        order by duration desc
        limit 1
)
select * from delivery_duration;
-- ---------------------------------------------------------------------------------------

--  Average Order value per customer 
 with avg_order_value as (
       select customer_id,
       sum(quantity* price_per_unit * (1-discount /100)) total_revenue,
       count(distinct order_id) total_count
       from sales
       group by customer_id
)
select customer_id,
round((total_revenue /  total_count),2) AS 'average value'
from avg_order_value
order by round((total_revenue /  total_count),2) DESC;
 
-- ------------------------------------------------------------------------------------------

--  Orders with Max Discount (Strictly with CTE) – (Asked in Zepto) 

WITH max_cte as(
     
     SELECT max(discount) as maximum_discount
     from sales
     )
select * from sales
WHERE discount= (SELECT maximum_discount from max_cte);
-- ---------------------------------------------------------------------------------------------------	   

--  Products brought by  more than 50 unique customers  
WITH product_cte as(
    SELECT product_name,
    product_id,
    count(distinct customer_id) as unique_customer
    from sales
    group by product_id,product_name
    having count(distinct customer_id) > 50
    )
select * from product_cte;
-- ---------------------------------------------------------------------------------------------------------
--  Daily Order count Trend 

with daily_order as(
        select order_date, count(*) AS 'total order'
        from sales
        group by order_date
        order by order_date
)
select * from daily_order;
-- ---------------------------------------------------------------------------------------------------
        
--  Calculate cumulative monthly revenue – (Asked in DBS, TCS, Capegemini, Cognitivie.io) 
 with month_cte as(
           select product_name,monthname(order_date) month_date, 
           round(sum(quantity*price_per_unit*(1-discount/100)),2)  total_revenue
           from sales
           group by  product_name,month_date
           order by month_date  DESC
           )
select * from month_cte;

--  Find top 3 categories contributing to revenue 
with category_cte as(
        SELECT category,
        format(sum(quantity*price_per_unit*(1-discount /100)),2) total_revenue
        from sales
        group by category
        order by total_revenue DESC
        limit 3
)
select * from category_cte;
-- -----------------------------------------------------------------------------------------------------------------------------
--  Identify Churned Customer, last order > 6 months ago – (Asked in Birlasoft, Freshworks, Larsen & Tubro Infotech, redington, UST Global) 

WITH last_order_cte AS 
(
    SELECT
        customer_id,max(ORDER_DATE)  last_order 
        FROM sales
        GROUP BY customer_id
        HAVING last_order < curdate() - INTERVAL 6 MONTH
)
select * FROM  last_order_cte;


-- -------------------------------------------------------------------------------------------------------------------------------------------------
--  Average discount trend over time (monthly) 
WITH monthly_discount AS (
    SELECT
        MONTHNAME(order_date) AS order_month,
        ROUND(AVG(discount),2) AS avg_monthly_discount
    FROM SALES
    GROUP BY MONTHNAME( order_date)
    ORDER BY order_month
)

SELECT * FROM monthly_discount;
-- -------------------------------------------------------------------------------------------------------------------------------------

--  Detect customers who Ordered same product multiple times (Asked in Zoho corp, Hexaware, Amazon, Flipkart) 

WITH customer_product_orders AS (
    SELECT
        customer_id,
        product_id,
        COUNT(*) AS multiple_count
    FROM SALES
    GROUP BY customer_id, product_id
    HAVING multiple_count > 1
)
SELECT * FROM customer_product_orders;


-- ------------------------------------------------------------------------------------------------------------------------------------------
--  Longest Delivery time per region 
                                      


with max_delivery_per_region AS (
    SELECT region,
        MAX(delivery_days) AS max_delivery_days
    FROM sales
    group by region
)

SELECT * from max_delivery_per_region;	
   
-- ------------------------------------------------------------------------------------------------------------------------------------------