create schema `retails`;
create database `sale`;

CREATE TABLE SalesData (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_date DATE NOT NULL,
    sale_time TIME NOT NULL,
    customer_id INT NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    age INT NOT NULL,
    category VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10,2) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    total_sales DECIMAL(10,2) NOT NULL
);

INSERT INTO SalesData (sale_date, sale_time, customer_id, gender, age, category, quantity, price_per_unit, cogs, total_sales) VALUES
('2024-03-10', '14:30:00', 101, 'Male', 30, 'Electronics', 2, 500.00, 800.00, 1000.00),
('2024-03-11', '16:45:00', 102, 'Female', 27, 'Clothing', 1, 200.00, 150.00, 200.00),
('2024-03-12', '12:15:00', 103, 'Other', 35, 'Groceries', 5, 50.00, 200.00, 250.00),
('2024-03-13', '10:00:00', 104, 'Male', 40, 'Furniture', 1, 1500.00, 1200.00, 1500.00),
('2024-03-14', '18:30:00', 105, 'Female', 22, 'Cosmetics', 3, 75.00, 150.00, 225.00),
('2024-03-15', '09:45:00', 106, 'Male', 50, 'Sports', 2, 300.00, 400.00, 600.00),
('2024-03-16', '11:20:00', 107, 'Female', 33, 'Home Appliances', 1, 700.00, 550.00, 700.00),
('2024-03-17', '20:00:00', 108, 'Other', 29, 'Toys', 4, 40.00, 100.00, 160.00),
('2024-03-18', '13:55:00', 109, 'Male', 45, 'Books', 6, 20.00, 90.00, 120.00),
('2024-03-19', '15:10:00', 110, 'Female', 28, 'Jewelry', 1, 1200.00, 900.00, 1200.00),
('2024-03-20', '17:25:00', 111, 'Male', 38, 'Automobile', 1, 2500.00, 2000.00, 2500.00),
('2024-03-21', '08:05:00', 112, 'Female', 31, 'Groceries', 10, 20.00, 150.00, 200.00),
('2024-03-22', '19:40:00', 113, 'Male', 36, 'Gaming', 1, 600.00, 450.00, 600.00),
('2024-03-23', '14:10:00', 114, 'Female', 25, 'Shoes', 2, 250.00, 350.00, 500.00),
('2024-03-24', '12:00:00', 115, 'Other', 42, 'Furniture', 1, 1800.00, 1400.00, 1800.00),
('2024-03-25', '21:30:00', 116, 'Male', 29, 'Cosmetics', 5, 50.00, 180.00, 250.00),
('2024-03-26', '16:50:00', 117, 'Female', 34, 'Clothing', 3, 150.00, 350.00, 450.00),
('2024-03-27', '10:30:00', 118, 'Male', 27, 'Electronics', 1, 1200.00, 950.00, 1200.00),
('2024-03-28', '18:15:00', 119, 'Female', 40, 'Books', 8, 25.00, 140.00, 200.00),
('2024-03-29', '20:45:00', 120, 'Other', 30, 'Groceries', 7, 30.00, 180.00, 210.00);


-- feature engineering:
alter table salesdata
add column profit decimal(10,2),
add column sales_shift varchar(40),
add column month_name varchar(40),
add column day_name varchar(40),
add column is_weekend tinyint(1),
add column age_group varchar(40),
add column high_sale_value tinyint(1);


update salesdata 
set 
  profit=total_sales - cogs ,
  sales_shift = case
     when hour(sale_time) <12  then 'morning'
     when hour(sale_time)  between 12 and 17 then 'afternoon'
     else 'evening'
end ,
month_name = MONTHNAME(sale_date),
day_name= dayname(sale_date),
is_weekend= case 
            when dayofweek(sale_date) in(1,7) then 1 else 0 
end;

ALTER TABLE salesData
DROP COLUMN age_group;

SELECT * FROM salesdata;

ALTER TABLE salesdata
ADD COLUMN age_group VARCHAR(40);

update salesdata
set age_group = CASE
      when age < 20  then 'TEEN'
      when age between 21 and 35 then 'ADULT'
      else 'SENIOR_CITIZEN'
end,

high_sale_value = case
       when total_sales >1000 then 1
       else 0
end;
       

desc salesdata;

select * from salesdata;

-- 1. Record Count

delimiter //
create  procedure get_all_by_records(
          in transcation_id_  INT  
)
begin 
      select count(*) as total_records
      from salesdata
      where transcation_id=transcation_id_;
end //
delimiter ;
call get_all_by_records();


-- 2. Customer Count
-- 3. Category Count
-- 4. Null Values Check