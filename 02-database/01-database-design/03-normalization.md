# Database Normalization

## Table of Contents
1. [Introduction to Normalization](#introduction)
2. [Normal Forms](#normal-forms)
3. [First Normal Form (1NF)](#1nf)
4. [Second Normal Form (2NF)](#2nf)
5. [Third Normal Form (3NF)](#3nf)
6. [Higher Normal Forms](#higher-forms)
7. [Denormalization](#denormalization)
8. [Examples](#examples)

## Introduction to Normalization
Database normalization is the process of organizing data to:
- Reduce redundancy
- Improve data integrity
- Minimize data anomalies
- Optimize database structure

### Benefits of Normalization
- Eliminates data redundancy
- Prevents data anomalies
- Improves data integrity
- Makes maintenance easier
- Optimizes storage space

## Normal Forms

### Overview of Normal Forms
1. First Normal Form (1NF)
2. Second Normal Form (2NF)
3. Third Normal Form (3NF)
4. Boyce-Codd Normal Form (BCNF)
5. Fourth Normal Form (4NF)
6. Fifth Normal Form (5NF)

## First Normal Form (1NF)

### Rules
- Eliminate repeating groups
- Ensure atomic values
- Create separate tables for related data
- Identify primary key

### Example
```sql
-- Before 1NF (denormalized)
CREATE TABLE orders (
    order_id INT,
    customer_name VARCHAR(100),
    items VARCHAR(500)  -- Contains multiple items as string
);

-- After 1NF
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE
);

CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
```

### Common Violations
- Repeating groups in columns
- Multiple values in a single column
- Nested tables
- Arrays in columns

## Second Normal Form (2NF)

### Rules
- Meet 1NF requirements
- Remove partial dependencies
- All non-key attributes must depend on the entire primary key

### Example
```sql
-- Before 2NF
CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    item_name VARCHAR(100),  -- Depends only on item_id
    quantity INT,
    price DECIMAL(10,2),
    PRIMARY KEY (order_id, item_id)
);

-- After 2NF
CREATE TABLE items (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    quantity INT,
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);
```

### Common Violations
- Attributes depending on part of composite key
- Redundant data across rows
- Partial dependencies

## Third Normal Form (3NF)

### Rules
- Meet 2NF requirements
- Remove transitive dependencies
- No non-key attribute should depend on another non-key attribute

### Example
```sql
-- Before 3NF
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    customer_city VARCHAR(100),  -- Depends on customer_id, not order_id
    order_date DATE
);

-- After 3NF
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    city VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

### Common Violations
- Transitive dependencies
- Derived attributes
- Redundant data

## Higher Normal Forms

### Boyce-Codd Normal Form (BCNF)
- Stricter version of 3NF
- Every determinant must be a candidate key
- Handles special cases of 3NF

### Fourth Normal Form (4NF)
- Meet BCNF requirements
- No multi-valued dependencies
- Decompose tables with multi-valued dependencies

### Fifth Normal Form (5NF)
- Meet 4NF requirements
- No join dependencies
- Decompose tables with join dependencies

## Denormalization

### When to Denormalize
- Performance requirements
- Reporting needs
- Data warehouse design
- Read-heavy applications

### Common Denormalization Techniques
1. **Redundant Columns**
   ```sql
   -- Normalized
   CREATE TABLE orders (
       order_id INT PRIMARY KEY,
       customer_id INT
   );

   -- Denormalized
   CREATE TABLE orders (
       order_id INT PRIMARY KEY,
       customer_id INT,
       customer_name VARCHAR(100)  -- Redundant
   );
   ```

2. **Summary Tables**
   ```sql
   CREATE TABLE order_summary (
       customer_id INT PRIMARY KEY,
       total_orders INT,
       total_amount DECIMAL(10,2)
   );
   ```

3. **Pre-joined Tables**
   ```sql
   CREATE TABLE order_details (
       order_id INT PRIMARY KEY,
       customer_name VARCHAR(100),
       product_name VARCHAR(100),
       quantity INT
   );
   ```

## Examples

### 1. E-Commerce System
```sql
-- Normalized Structure
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### 2. University System
```sql
-- Normalized Structure
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    title VARCHAR(100),
    credits INT
);

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    semester VARCHAR(20),
    grade CHAR(1),
    PRIMARY KEY (student_id, course_id, semester),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE course_departments (
    course_id INT,
    dept_id INT,
    PRIMARY KEY (course_id, dept_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
```

### 3. Hospital System
```sql
-- Normalized Structure
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100),
    birth_date DATE
);

CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100),
    specialty VARCHAR(100)
);

CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE medical_records (
    record_id INT PRIMARY KEY,
    patient_id INT,
    diagnosis VARCHAR(200),
    treatment VARCHAR(200),
    record_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);
``` 