# SQL Basics and Database Creation

## Table of Contents
1. [Introduction to SQL](#introduction)
2. [Database Creation](#database-creation)
3. [Table Operations](#table-operations)
4. [Data Manipulation](#data-manipulation)
5. [Data Querying](#data-querying)
6. [Advanced SQL Concepts](#advanced-sql-concepts)
7. [SQL Functions](#sql-functions)
8. [Transaction Management](#transaction-management)

## Introduction to SQL
SQL (Structured Query Language) is the standard language for managing and manipulating relational databases. It's used for:
- Creating and modifying database structures
- Inserting, updating, and deleting data
- Querying and retrieving data
- Managing database security

### SQL Standards
- SQL-86: First SQL standard
- SQL-92: Major revision
- SQL:1999: Added advanced features
- SQL:2003: XML support
- SQL:2008: Advanced features
- SQL:2011: Temporal data support

### SQL Dialects
- MySQL/MariaDB
- PostgreSQL
- Oracle
- SQL Server
- SQLite

## Database Creation

### Creating a Database
```sql
-- Basic syntax
CREATE DATABASE database_name;

-- With character set and collation
CREATE DATABASE database_name
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- With additional options
CREATE DATABASE database_name
WITH 
    OWNER = username
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE = template0;
```

### Using a Database
```sql
-- Switch to a database
USE database_name;

-- Show current database
SELECT DATABASE();

-- List all databases
SHOW DATABASES;
```

## Table Operations

### Creating Tables
```sql
-- Basic table creation
CREATE TABLE table_name (
    column1 datatype constraints,
    column2 datatype constraints,
    ...
);

-- Table with multiple constraints
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE DEFAULT CURRENT_DATE,
    salary DECIMAL(10,2) CHECK (salary > 0),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Table with indexes
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(200),
    category VARCHAR(50),
    price DECIMAL(10,2),
    INDEX idx_category (category),
    INDEX idx_price (price)
);
```

### Common Constraints
- `PRIMARY KEY`: Unique identifier
  ```sql
  column_name INT PRIMARY KEY
  ```
- `FOREIGN KEY`: References another table
  ```sql
  FOREIGN KEY (column_name) REFERENCES other_table(column_name)
  ```
- `NOT NULL`: Column cannot be empty
  ```sql
  column_name VARCHAR(50) NOT NULL
  ```
- `UNIQUE`: No duplicate values
  ```sql
  column_name VARCHAR(100) UNIQUE
  ```
- `DEFAULT`: Default value
  ```sql
  column_name VARCHAR(50) DEFAULT 'Unknown'
  ```
- `CHECK`: Validates data
  ```sql
  column_name INT CHECK (column_name > 0)
  ```
- `AUTO_INCREMENT`: Auto-incrementing value
  ```sql
  id INT AUTO_INCREMENT PRIMARY KEY
  ```

### Modifying Tables
```sql
-- Add a column
ALTER TABLE table_name
ADD column_name datatype;

-- Modify a column
ALTER TABLE table_name
MODIFY column_name new_datatype;

-- Drop a column
ALTER TABLE table_name
DROP COLUMN column_name;

-- Add a constraint
ALTER TABLE table_name
ADD CONSTRAINT constraint_name UNIQUE (column_name);

-- Drop a constraint
ALTER TABLE table_name
DROP CONSTRAINT constraint_name;
```

## Data Manipulation

### Inserting Data
```sql
-- Single row
INSERT INTO table_name (column1, column2) 
VALUES (value1, value2);

-- Multiple rows
INSERT INTO table_name (column1, column2) 
VALUES 
    (value1, value2),
    (value3, value4);

-- Insert with SELECT
INSERT INTO table1 (column1, column2)
SELECT column1, column2
FROM table2
WHERE condition;

-- Insert with default values
INSERT INTO table_name DEFAULT VALUES;
```

### Updating Data
```sql
-- Basic update
UPDATE table_name
SET column1 = value1, column2 = value2
WHERE condition;

-- Update with subquery
UPDATE employees
SET salary = salary * 1.1
WHERE department_id IN (
    SELECT department_id 
    FROM departments 
    WHERE location = 'New York'
);

-- Update multiple tables
UPDATE table1, table2
SET table1.column1 = value1,
    table2.column2 = value2
WHERE table1.id = table2.id;
```

### Deleting Data
```sql
-- Delete specific rows
DELETE FROM table_name
WHERE condition;

-- Delete with limit
DELETE FROM table_name
WHERE condition
LIMIT 10;

-- Delete all rows
TRUNCATE TABLE table_name;

-- Delete with join
DELETE t1 FROM table1 t1
INNER JOIN table2 t2
ON t1.id = t2.id
WHERE t2.status = 'inactive';
```

## Data Querying

### Basic SELECT
```sql
-- Select all columns
SELECT * FROM table_name;

-- Select specific columns
SELECT column1, column2 FROM table_name;

-- Select with conditions
SELECT * FROM table_name
WHERE condition;

-- Select with aliases
SELECT 
    column1 AS alias1,
    column2 AS alias2
FROM table_name;
```

### Filtering and Sorting
```sql
-- WHERE clause with multiple conditions
SELECT * FROM table_name
WHERE column1 > 100
AND column2 = 'value'
OR column3 IS NULL;

-- ORDER BY with multiple columns
SELECT * FROM table_name
ORDER BY column1 ASC, column2 DESC;

-- LIMIT with offset
SELECT * FROM table_name
LIMIT 10 OFFSET 20;

-- DISTINCT
SELECT DISTINCT column1, column2
FROM table_name;
```

### Aggregation Functions
```sql
-- Basic aggregation
SELECT 
    COUNT(*) as total_rows,
    SUM(column1) as sum_value,
    AVG(column1) as avg_value,
    MAX(column1) as max_value,
    MIN(column1) as min_value
FROM table_name;

-- Aggregation with GROUP BY
SELECT 
    department_id,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary
FROM employees
GROUP BY department_id;

-- HAVING clause
SELECT 
    department_id,
    COUNT(*) as employee_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 5;
```

## Advanced SQL Concepts

### Subqueries
```sql
-- Single-row subquery
SELECT * FROM employees
WHERE salary > (
    SELECT AVG(salary) FROM employees
);

-- Multi-row subquery
SELECT * FROM employees
WHERE department_id IN (
    SELECT department_id 
    FROM departments 
    WHERE location = 'New York'
);

-- Correlated subquery
SELECT * FROM employees e1
WHERE salary > (
    SELECT AVG(salary) 
    FROM employees e2 
    WHERE e2.department_id = e1.department_id
);
```

### Common Table Expressions (CTE)
```sql
WITH department_stats AS (
    SELECT 
        department_id,
        COUNT(*) as emp_count,
        AVG(salary) as avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT * FROM department_stats
WHERE emp_count > 5;
```

### Window Functions
```sql
-- Row number
SELECT 
    employee_id,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) as salary_rank
FROM employees;

-- Partition by
SELECT 
    employee_id,
    department_id,
    salary,
    AVG(salary) OVER (PARTITION BY department_id) as dept_avg_salary
FROM employees;
```

## SQL Functions

### String Functions
```sql
-- Concatenation
SELECT CONCAT(first_name, ' ', last_name) as full_name
FROM employees;

-- Substring
SELECT SUBSTRING(column_name, 1, 3)
FROM table_name;

-- Case conversion
SELECT 
    UPPER(column_name) as upper_case,
    LOWER(column_name) as lower_case
FROM table_name;
```

### Date Functions
```sql
-- Current date/time
SELECT 
    CURRENT_DATE,
    CURRENT_TIMESTAMP,
    NOW();

-- Date arithmetic
SELECT 
    DATE_ADD(date_column, INTERVAL 1 DAY),
    DATE_SUB(date_column, INTERVAL 1 MONTH)
FROM table_name;

-- Date formatting
SELECT 
    DATE_FORMAT(date_column, '%Y-%m-%d') as formatted_date
FROM table_name;
```

### Numeric Functions
```sql
-- Rounding
SELECT 
    ROUND(column_name, 2),
    FLOOR(column_name),
    CEILING(column_name)
FROM table_name;

-- Mathematical functions
SELECT 
    ABS(column_name),
    POWER(column_name, 2),
    SQRT(column_name)
FROM table_name;
```

## Transaction Management

### Basic Transactions
```sql
-- Start transaction
START TRANSACTION;

-- Perform operations
INSERT INTO table1 VALUES (1, 'value1');
UPDATE table2 SET column1 = 'value2';

-- Commit or rollback
COMMIT;
-- or
ROLLBACK;
```

### Savepoints
```sql
START TRANSACTION;

INSERT INTO table1 VALUES (1, 'value1');
SAVEPOINT sp1;

INSERT INTO table2 VALUES (2, 'value2');
SAVEPOINT sp2;

-- Rollback to savepoint
ROLLBACK TO sp1;
```

## Practice Exercises
1. Create a database for a bookstore
2. Create tables for books, authors, and customers
3. Insert sample data
4. Write queries to:
   - Find all books by a specific author
   - Calculate total sales by category
   - List customers who purchased more than 5 books
5. Create a database for a school management system
6. Implement a library management system
7. Design and implement an e-commerce database 