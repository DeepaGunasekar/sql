create database jons_h;
use jons_h;
CREATE TABLE stores (
store_id INT PRIMARY KEY,
store_location VARCHAR(100)
);

CREATE TABLE products (
store_id INT,
FOREIGN KEY(store_id) REFERENCES stores(store_id), 
product_id INT PRIMARY KEY,
product_category VARCHAR(50),
product_type VARCHAR(50)
);

CREATE TABLE sales ( 
transaction_id INT PRIMARY KEY, 
transaction_date DATE, 
transaction_time TIME,
transaction_qty INT, 
store_id INT,
FOREIGN KEY(store_id) REFERENCES stores(store_id),
product_id INT, 
FOREIGN KEY(product_id) REFERENCES products (product_id),
unit_price DECIMAL(10, 2)
);

CREATE TABLE employees (
employee_id INT PRIMARY KEY,
employee_name VARCHAR(100),
store_id INT
FOREIGN KEY(store_id) REFERENCES stores(store_id)
);

CREATE TABLE customers (
store_id INT,
FOREIGN KEY(store_id) REFERENCES stores(store_id), 
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100)
);

-- INSERTING INTO THE TABLES:
INSERT INTO sales (transaction_id, transaction_date, transaction_time, transaction_qty, store_id,
product_id, unit_price)
VALUES
(1, '2024-07-01', '09:00:00', 2, 1, 101, 5.99),
(2, '2024-07-01', '10:30:00', 1, 2, 102, 3.49),
(3, '2024-07-01', '11:00:00', 3, 1, 103, 4.99);

INSERT INTO stores (store_id, store_location)
VALUES
(1, 'Downtown'),
(2, 'Uptown');

INSERT INTO products (product_id, product_category, product_type)
VALUES
(101, 'Beverage', 'Coffee'),
(102, 'Beverage', 'Tea'),
(103, 'Food', 'Sandwich');

INSERT INTO employees (employee_id, employee_name, store_id)
VALUES
(1, 'Alice', 1),
(2, 'Bob', 2);

INSERT INTO customers (customer_id, customer_name)
VALUES
(1, 'John Doe'),
(2, 'Jane Smith');

select * from sales;

UPDATE products
SET store_id = 1
WHERE product_id = 101;

UPDATE products
SET store_id = 2
WHERE product_id = 102;

UPDATE products
SET store_id = 1
WHERE product_id = 103;

UPDATE customers
SET store_id = 1
WHERE customer_id = 101;

UPDATE customers
SET store_id = 2
WHERE customer_id = 102;

-- 1. List all sales transactions along with the store location where the transaction occurred 

select s.transaction_id,
       s.transaction_date,
       s.transaction_time,
       st.store_location
from sales s
join stores st
on s.store_id=st.store_id;
----------------------------------------------------------------------------------------------------------

-- 2. Find all employees working in stores where coffee is sold  

select e.employee_id,
       e.employee_name,
       s.store_id
from employees e
join sales s
on e.store_id=s.store_id
join products p
on s.product_id=p.product_id
where p.product_type='coffee';

----------------------------------------------------------------------------------------------------------

-- 3. List the total sales quantity for each store location 

select st.store_location,
sum(s.transaction_qty) as total_sales
from sales s
join stores st
on s.store_id=st.store_id
group by st.store_location;

-----------------------------------------------------------------------------------------------------------------------------

-- 4. Find the average unit price of products sold in each store  

select st.store_location,ceiling(avg(s.unit_price))  as 'average price'
from stores st
inner join sales s
on  st.store_id= s.store_id
group by st.store_location;

--------------------------------------------------------------------------------------------------------------------------------
-- 5. List all sales transactions along with product details  

select s.transaction_id,s.transaction_date,
s.transaction_time ,p.product_category,
p.product_type,s.unit_price
from sales s
join  products as p
on s.product_id=p.product_id;

-------------------------------------------------------------------------------------------------------------------------------


-- 6. Find the total sales amount for each product type  

select p.product_type,p.product_id,sum(s.unit_price*transaction_qty) as total_sales
from sales s
join products as p
on s.product_id=p.product_id
group by p.product_type,p.product_id
order by total_sales desc;
---------------------------------------------------------------------------------------------------------------------------------

-- 7. List the names of employees and the total sales they handled in their respective stores  

select e.employee_name,s.store_id,s.store_location,
sum(p.unit_price*p.transaction_qty)  as total_sales
from stores s
inner join employees e
on s.store_id=e.store_id
inner join sales p
on p.store_id=s.store_id
group by e.employee_name,s.store_id,s.store_location;

----------------------------------------------------------------------------------------------------------------------------

-- 8. Find all stores that do not have any sales transactions  

SELECT st.store_location, s.transaction_id
FROM stores st
JOIN sales s
ON s.store_id = st.store_id
WHERE s.transaction_id IS NULL;

---------------------------------------------------------------------------------------------------------------------------

-- 9. List all customers who made a purchase along with the transaction details  

select c.customer_name,
s.transaction_id,
s.transaction_date,
s.transaction_time
from customers c
join sales s
on s.customer_id=c.customer_id;



alter table sales add customer_id int;

update sales
set customer_id = 1 where transaction_id=1;
update sales
set customer_id = 2 where transaction_id=2;
update sales
set customer_id = 3 where transaction_id=3;


-- alternative method for multiple update method

update sales
set customer_id= CASE transcation_id
                 when 1 then 1
                 when 2 then 2
                 when 3 then 3

    end
where transaction_id in(1,2,3);


-- alternative method

with update sales
set as (transaction_id, customer_id)
as values (1,1),(2,2),(3,3)
)
update s
set s.customer_id=u.customer_id
from sales s
join updates u
on s.transcation_id=u.transcation_id;
--------------------------------------------------------------------------------------------------------------------------------------


-- 10. Find the total number of transactions for each product category

select p.product_category,
count(s.transaction_id) as 'transaction count'
from sales s
join products p
on s.product_id=p.product_id
group by p.product_category;

--------------------------------------------------------------------------------------------------------

-- 11. List all products that have not been sold  

select p.product_category,p.product_type
from products p
left join sales  s
on s.product_id=p.product_id
where s.transaction_id is null;

---------------------------------------------------------------------------------------------------------------------------

-- 12. Find the most popular product type based on sales quantity  

select top 1 p.product_type, SUM(s.transaction_qty)  as 'total quantity'
from products p
join sales s
on p.product_id=s.product_id
group by p.product_type
order by sum(s.transaction_qty) desc;

-----------------------------------------------------------------------------------------------------------------------

-- 13. List the top 3 stores with the highest sales amount  

select top 3  p.product_id,p.store_id,product_type,
sum(s.unit_price*transaction_qty) as 'sales'
from products p
join sales s
on p.store_id=s.store_id
group by p.product_id,p.store_id,product_type
order by sum(s.unit_price*transaction_qty) desc;

-------------------------------------------------------------------------------------------------------------------------------

-- 14. Find the store locations where no employees are assigned  

select p.store_location,s.employee_id,s.employee_name
from stores p
join employees s
on p.store_id=s.store_id
where s.employee_name is null;

------------------------------------------------------------------------------------------------------------------------------

-- 15. List all transactions along with the names of the employees who handled them  

select s.transaction_id,s.transaction_time,s.transaction_date,e.employee_name
from employees e
join stores  p
on p.store_id=e.store_id
join sales s
on s.store_id=p.store_id;

--------------------------------------------------------------------------------------------------------------------------------

-- 16. Find the total sales amount for each store location during the month of July 2024  

select p.store_location,sum(s.unit_price*s.transaction_qty) total_amount
from sales s
join stores p
on p.store_id=s.store_id
where month(s.transaction_date)=7 AND YEAR(s.transaction_date) = 2024
group by p.store_location

--------------------------------------------------------------------------------------------------------------------------------


-- 17. List all transactions along with product and store details  

select s.transaction_id,s.transaction_date,s.transaction_time,
p.product_id,
p.product_type,e.store_id
from sales s
join products p
on p.store_id=s.store_id
join stores e
on e.store_id=p.store_id

---------------------------------------------------------------------------------------------------------------------------------

-- 18. Find the total sales quantity for each employee 

select e.employee_id,e.employee_name,sum(s.unit_price*s.transaction_qty) total_sales
from employees e
join products p
on p.store_id=e.store_id
join sales s
on s.store_id=p.store_id
group by e.employee_id,e.employee_name;

---------------------------------------------------------------------------------------------------------------------------------

-- 19. List all product categories that have been sold in the Downtown store  

SELECT s.store_id,s.store_location,p.product_category
FROM products p
JOIN stores s
ON s.store_id = p.store_id
WHERE s.store_location = 'Downtown';

------------------------------------------------------------------------------------------------------------------------------------
-- 20. Find the total number of transactions and total sales amount for each customer 



SELECT 
    c.customer_id,
    c.customer_name,
    COUNT( s.transaction_id) AS total_transactions,
    SUM(s.unit_price * s.transaction_qty) AS total_sales
FROM sales s
join stores p
on s.store_id=p.store_id
JOIN customers c 
ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name;

----------------------------------------------------------------------------------------------------------------------------------