CREATE SCHEMA `hr`;
create schema `sales`;
create schema `marketing`;


USE hr;
CREATE DATABASE employee1;
CREATE DATABASE employee2;
CREATE DATABASE employee3;
CREATE DATABASE employee4;

USE employee1;
SHOW DATABASES;
SELECT DATABASE();

CREATE TABLE employees (
    emp_id INT,
    first_name CHAR(40),
    last_name CHAR(100),
    department CHAR(100),
    salary MEDIUMINT
);
-- characteristics of the tables :
DESCRIBE employees;

-- inserting into table:
INSERT INTO  employees
VALUES
(1,'suresh','kumar', 'HR', 45000),
(2,'rakesh','kumar', 'sales', 50000),
(3,'pranav','krishna', 'IT',60000),
(4,'ramesh','kumar', 'Marketing', 80000);
SELECT * FROM employees;

TRUNCATE TABLE employees;
DROP Table employees;
DROP DATABASE employees1;

SELECT first_name,department
FROM employees;

-- updating the table:
UPDATE employees
SET department = 'Q&A'
WHERE emp_id = 2;

UPDATE employees
SET first_name = 'saran' ,department = 'production'
WHERE emp_id=2;

-- creating column bonous and add 5000 for the ppl who has salary above 50K:
ALTER  TABLE employees
ADD COLUMN bonous DECIMAL(10,2);

UPDATE employees
SET bonous = salary + 5000
WHERE salary >= 50000;

ALTER TABLE employees
DROP COLUMN bonous;

DELETE 
FROM employees
WHERE salary < 50000;