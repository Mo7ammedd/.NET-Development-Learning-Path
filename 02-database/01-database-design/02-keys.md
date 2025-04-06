# Database Keys
![Database keys](/media/keys.png)
## Table of Contents
1. [Introduction to Keys](#introduction)
2. [Types of Keys](#types-of-keys)
3. [Key Properties](#key-properties)
4. [Implementation](#implementation)
5. [Best Practices](#best-practices)
6. [Examples](#examples)

## Introduction to Keys
Database keys are attributes or combinations of attributes that uniquely identify records in a table. They are essential for:
- Uniquely identifying records
- Establishing relationships between tables
- Maintaining data integrity
- Optimizing database performance

## Types of Keys

### 1. Primary Key
- Uniquely identifies each record in a table
- Cannot contain NULL values
- Must be unique
- Can be single or composite
- Often auto-incremented

Example:
```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY,  -- Single column primary key
    username VARCHAR(50)
);

CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    quantity INT,
    PRIMARY KEY (order_id, item_id)  -- Composite primary key
);
```

### 2. Foreign Key
- References primary key in another table
- Can contain NULL values
- Can be single or composite
- Maintains referential integrity

Example:
```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

### 3. Unique Key
- Ensures uniqueness of values
- Can contain NULL values
- Can have multiple unique keys
- Not necessarily a primary key

Example:
```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE,
    username VARCHAR(50) UNIQUE
);
```

### 4. Composite Key
- Combination of multiple columns
- Can be primary or unique
- All columns together must be unique

Example:
```sql
CREATE TABLE student_courses (
    student_id INT,
    course_id INT,
    semester VARCHAR(20),
    PRIMARY KEY (student_id, course_id, semester)
);
```

### 5. Surrogate Key
- Artificially created key
- Often auto-incremented
- Has no business meaning
- Used when natural key is not suitable

Example:
```sql
CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,  -- Surrogate key
    employee_number VARCHAR(20) UNIQUE,     -- Natural key
    name VARCHAR(100)
);
```

## Key Properties

### 1. Uniqueness
- Primary Key: Must be unique
- Foreign Key: Can be duplicate
- Unique Key: Must be unique
- Composite Key: Combination must be unique

### 2. NULL Values
- Primary Key: Cannot be NULL
- Foreign Key: Can be NULL
- Unique Key: Can be NULL (usually once)
- Composite Key: Individual columns can be NULL if not primary

### 3. Indexing
- Primary Key: Automatically indexed
- Foreign Key: Should be indexed
- Unique Key: Automatically indexed
- Composite Key: Indexed as a whole

## Implementation

### 1. Creating Keys
```sql
-- Primary Key
CREATE TABLE table_name (
    id INT PRIMARY KEY
);

-- Foreign Key
CREATE TABLE table_name (
    id INT PRIMARY KEY,
    ref_id INT,
    FOREIGN KEY (ref_id) REFERENCES other_table(id)
);

-- Unique Key
CREATE TABLE table_name (
    id INT PRIMARY KEY,
    unique_column VARCHAR(50) UNIQUE
);

-- Composite Key
CREATE TABLE table_name (
    col1 INT,
    col2 INT,
    PRIMARY KEY (col1, col2)
);
```

### 2. Modifying Keys
```sql
-- Add Primary Key
ALTER TABLE table_name
ADD PRIMARY KEY (column_name);

-- Add Foreign Key
ALTER TABLE table_name
ADD FOREIGN KEY (column_name) REFERENCES other_table(id);

-- Add Unique Key
ALTER TABLE table_name
ADD UNIQUE (column_name);
```

## Best Practices

1. **Naming Conventions**
   - Use consistent naming patterns
   - Prefix foreign keys with table name
   - Use meaningful names
   - Document key relationships

2. **Key Selection**
   - Choose appropriate key type
   - Consider performance implications
   - Plan for scalability
   - Document key decisions

3. **Implementation**
   - Create indexes for foreign keys
   - Use appropriate data types
   - Consider key length
   - Plan for key maintenance

4. **Performance**
   - Index foreign keys
   - Use appropriate data types
   - Consider composite key order
   - Monitor key performance

## Examples

### 1. E-Commerce System
```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
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
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_number VARCHAR(20) UNIQUE,
    name VARCHAR(100)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_code VARCHAR(20) UNIQUE,
    title VARCHAR(100)
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
```

### 3. Hospital System
```sql
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    medical_record_number VARCHAR(20) UNIQUE,
    name VARCHAR(100)
);

CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    license_number VARCHAR(20) UNIQUE,
    name VARCHAR(100)
);

CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);
``` 