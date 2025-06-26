CREATE SCHEMA `PIZZA`;
CREATE DATABASE pizza_sale;
use pizza_sale;
CREATE TABLE pizza_sales ( sale_id INT AUTO_INCREMENT PRIMARY KEY,
sale_date DATE NOT NULL,                                                  
pizza_type VARCHAR(50),                                                  
size VARCHAR(20),                                                  
quantity INT,                                                 
price  DECIMAL(10, 2),                                               
location  VARCHAR(50) );   

DESC pizza_sales;
DROP TABLE pizza_sales;

INSERT INTO pizza_sales (sale_date, pizza_type, size, quantity, price, location)  
VALUES   
('2024-01-01', 'Pepperoni', 'Small', 5, 8.99, 'New York'),   
('2024-01-01', 'Pepperoni', 'Medium', 3, 12.99, 'New York'),   
('2024-01-02', 'Margherita', 'Large', 2, 15.99, 'New York'),   
('2024-01-02', 'BBQ Chicken', 'Small', 4, 9.99, 'Chicago'),   
('2024-01-03', 'Vegetarian', 'Large', 6, 14.99, 'Los Angeles'),   
('2024-01-04', 'Pepperoni', 'Small', 7, 8.99, 'Chicago'),  
('2024-01-05', 'BBQ Chicken', 'Medium', 2, 13.99, 'Los Angeles'),   
('2024-01-06', 'Margherita', 'Small', 8, 7.99, 'New York'),   
('2024-01-07', 'Vegetarian', 'Medium', 3, 12.99, 'Chicago'),   
('2024-01-08', 'Pepperoni', 'Large', 1, 15.99, 'Los Angeles'),   
('2024-01-09', 'BBQ Chicken', 'Large', 2, 17.99, 'New York'),   
('2024-01-10', 'Vegetarian', 'Small', 5, 9.99, 'Chicago');  

select * from pizza_sales;
RENAME TABLE pizza_sales TO pizza_sale;
select * from pizza_sale;


-- 1. Total sales amount by pizza type  
select pizza_type, 
       sum(price) as 'total sales'
       from pizza_sale
       group by pizza_type;
-- -------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. Average price of each pizza type  
SELECT pizza_type,
	   round(avg(price),2) as 'average sales'
       from pizza_sale
       group by pizza_type;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- 3. Total quantity sold by location  
SELECT location,
       sum(quantity) as 'total quantity'
       from pizza_sale
       group by location;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------

-- 4. Total sales amount by size  

SELECT size,
       sum(price) as 'total sales by size'
       from pizza_sale
       group by size;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- 5. Total sales amount by pizza type and size 

SELECT pizza_type,size,
       sum(price) as 'total price'
       from pizza_sale
       group by pizza_type,size;

 -- -----------------------------------------------------------------------------------------------------------------------------------------------
 
-- 6. Total sales amount by month  

SELECT monthname(sale_date),
       sum(price) as 'total sales'
       from pizza_sale
       group by  monthname(sale_date);

-- ---------------------------------------------------------------------------------------------------------------------------------------------------


-- 7. Total sales amount by location and pizza type  

SELECT pizza_type,location,
       sum(price) as 'total price'
       from pizza_sale
       group by pizza_type,location;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
       
       
-- 8. Count of sales by pizza type  
SELECT pizza_type,
       count(quantity) as 'count of sales'
       from pizza_sale
       group by pizza_type;
       
 -- --------------------------------------------------------------------------------------------------------------------------------------------------
 
-- 9. Total sales amount categorized by price range  
SELECT pizza_type,quantity,
       sum(price) AS 'total price' 
       from pizza_sale
       GROUP BY pizza_type,quantity
       ORDER BY COUNT(*);

-- ------------------------------------------------------------------------------------------------------------------------------------------------
        
-- 10. Total sales amount by pizza type with a minimum of 5 pizzas sold  


-- ------------------------------------------------------------------------------------------------------------------------------------------------


-- 11. Total sales amount by size and location  


SELECT location,size,
       sum(price) as 'total price'
       from pizza_sale
       group by location,size;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------

-- 12. Average quantity sold by pizza type  
SELECT DISTINCT pizza_type,
       ROUND(AVG(quantity),2) as 'average quantity'
       from pizza_sale
       group by pizza_type;
       
-- --------------------------------------------------------------------------------------------------------------------------------------------------

-- 13. Total sales amount by location with average price above 10  
SELECT 
    location,
    round(SUM(price * quantity),2) AS total_sales,
    round(AVG(price),2) AS average_price
FROM pizza_sale
GROUP BY location
HAVING AVG(price) > 10;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- 14. Total sales amount by day of the week  
SELECT dayofweek(sale_date) as 'day of week',
       sum(price) as 'total price'
       from pizza_sale
       group by dayofweek(sale_date);

-- --------------------------------------------------------------------------------------------------------------------------------------------------

-- 15. Total sales amount by month and location
SELECT monthname(sale_date) as 'month',location,
       sum(price) as 'total price'
       from pizza_sale
       group by  monthname(sale_date) ,location; 
       
 -- --------------------------------------------------------------------------------------------------------------------------------------------------
 
-- 16. Total sales amount by pizza type with price range categorization ( Price < 10, “Low”, Between 10 and 15, “Medium”, Else “High”)  

SELECT price,
       sum(price) as 'total price'
       from pizza_sale
       group by  price;

-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 17. Total sales amount by location with a minimum total sales of 100  


-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- 18. Average sales amount per order by pizza type
SELECT pizza_type,round(AVG(price),2) AS"average sales per order"
FROM pizza_sale
GROUP BY pizza_type
order by round(AVG(price),2);

  -- ------------------------------------------------------------------------------------------------------------------------------------------------
  
-- 19. Total sales amount by location and day of the week 

select DAYOFWEEK(sale_date) AS 'DAY OF WEEK',location,
       sum(price) as 'total sales'
       from pizza_sale
       group by DAYOFWEEK(sale_date),location;

--  ---------------------------------------------------------------------------------------------------------------------------------------------
