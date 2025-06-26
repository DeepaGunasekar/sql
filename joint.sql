CREATE SCHEMA `joins`;
USE joins;

-- create department table first 
 CREATE TABLE departments (   
          department_id INT PRIMARY KEY,
          department_name VARCHAR(100)
);


-- create the employee table with foreign key to department
CREATE TABLE employees (
      emp_id INT PRIMARY KEY,
      emp_name VARCHAR(100) NOT NULL,
      hire_date DATE,
      department_id INT,
      FOREIGN KEY (department_id) REFERENCES departments(department_id)
);


-- create salaries table with foreign key to empolyees

CREATE TABLE salaries(
         salary_id INT primary KEY,
         emp_id  INT,
         amount DECIMAL(10,2),
         effective_date DATE,
         FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);
truncate table employees;
truncate table departments;
-- insert sample data into departments

INSERT INTO departments(department_id,department_name)  VALUES
 (1,'human resources'),
 (2,'engineering'),
 (3,'finance'),
 (4,'marketing');
 
