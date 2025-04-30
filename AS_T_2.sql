-- CREATING DATABASE FOR EMPLOYEES
CREATE DATABASE EMPLOYEES_DB;
USE EMPLOYEE_DB;

-- DEPARTMENTS: Stores department-level data for grouping employees 
CREATE TABLE departments_table(
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE
);

-- EMPLOYEES: Stores employee personal and job-related INFO
CREATE TABLE employees_table(
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email_id VARCHAR(100) UNIQUE NOT NULL,
    phone_no VARCHAR(15),
    hire_date DATE NOT NULL,
    job_title VARCHAR(100),
    dept_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    -- Relates each employee to a department
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE SET NULL
);

-- SALARY_RECORDS: Stores monthly salary details of employees
CREATE TABLE salary_records_table (
    salary_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    salary_month DATE NOT NULL, -- usually first day of the month
    basic_salary DECIMAL(10, 2) NOT NULL CHECK (basic_salary >= 0),
    bonus DECIMAL(10, 2) DEFAULT 0,
    deductions DECIMAL(10, 2) DEFAULT 0,
    net_salary DECIMAL(10, 2) GENERATED ALWAYS AS (
        basic_salary + bonus - deductions
    ) STORED,
    generated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Foreign key to ensure valid employee
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);

-- INDEXES for fast queries on common filters
CREATE INDEX idx_emp_email_id ON employees_table(email);
CREATE INDEX idx_salary_month ON salary_records_table(salary_month);
CREATE INDEX idx_emp_month ON salary_records_table(emp_id, salary_month);


-- Insert departments values 
INSERT INTO departments_table(dept_name)
VALUES 
('Human Resources'),
('Finance'),
('Engineering');

-- Insert employees values
INSERT INTO employees_table(full_name, email_id, phone_no, hire_date, job_title, dept_id)
VALUES
('Rahul Mehra', 'rahul.mehra@example.com', '9998812345', '2023-06-01', 'Software Engineer', 3),
('Sneha Iyer', 'sneha.iyer@example.com', '9998876543', '2022-11-15', 'HR Manager', 1);

-- Insert salary records values
INSERT INTO salary_records_table(emp_id, salary_month, basic_salary, bonus, deductions)
VALUES
(1, '2025-04-01', 60000, 5000, 2000),
(2, '2025-04-01', 50000, 3000, 1000);

-- used to drop database if needed
DROP DATABASE EMPLOYEE_DB;


