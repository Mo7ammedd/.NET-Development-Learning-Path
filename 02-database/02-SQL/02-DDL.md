# Data Definition Language (DDL)

DDL (Data Definition Language) is a subset of SQL that is used for defining, modifying, and deleting database objects such as tables, indexes, views, schemas, and more.

## Core DDL Commands

### CREATE

The CREATE command is used to create new database objects.

#### CREATE DATABASE

```sql
CREATE DATABASE school;

-- With specific character set and collation
CREATE DATABASE school
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

#### CREATE TABLE

```sql
-- Basic table creation
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    grade_level INT CHECK (grade_level BETWEEN 1 AND 12),
    email VARCHAR(100) UNIQUE
);

-- Table with foreign key
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    instructor_id INT,
    credits INT DEFAULT 3,
    FOREIGN KEY (instructor_id) REFERENCES teachers(teacher_id)
);
```

#### CREATE INDEX

```sql
-- Simple index
CREATE INDEX idx_last_name ON students(last_name);

-- Composite index
CREATE INDEX idx_name ON students(last_name, first_name);

-- Unique index
CREATE UNIQUE INDEX idx_email ON students(email);
```

#### CREATE VIEW

```sql
-- Simple view
CREATE VIEW student_info AS
SELECT student_id, first_name, last_name, grade_level
FROM students;

-- View with join
CREATE VIEW course_enrollment AS
SELECT s.student_id, s.first_name, s.last_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;
```

### ALTER

The ALTER command is used to modify existing database objects.

```sql
-- Add a column
ALTER TABLE students ADD phone VARCHAR(15);

-- Modify a column
ALTER TABLE students MODIFY first_name VARCHAR(75);

-- Add constraint
ALTER TABLE students ADD CONSTRAINT chk_email 
CHECK (email LIKE '%@%.%');

-- Add foreign key
ALTER TABLE assignments
ADD CONSTRAINT fk_course
FOREIGN KEY (course_id) REFERENCES courses(course_id);

-- Drop column
ALTER TABLE students DROP COLUMN phone;
```

### DROP

The DROP command is used to delete existing database objects.

```sql
-- Drop table
DROP TABLE IF EXISTS temp_students;

-- Drop database
DROP DATABASE old_school;

-- Drop index
DROP INDEX idx_name ON students;

-- Drop view
DROP VIEW IF EXISTS student_info;
```

### TRUNCATE

The TRUNCATE command quickly removes all records from a table.

```sql
-- Remove all data from table
TRUNCATE TABLE temp_logs;
```

## Schema Design Best Practices

1. **Normalization**: Structure tables to minimize redundancy and dependency
   - First Normal Form (1NF): Eliminate repeating groups
   - Second Normal Form (2NF): Remove partial dependencies
   - Third Normal Form (3NF): Remove transitive dependencies

2. **Data Types**: Choose appropriate data types for columns
   - Use INT for numeric identifiers
   - Use VARCHAR for variable-length text
   - Use DATETIME/TIMESTAMP for date and time values

3. **Naming Conventions**:
   - Use singular nouns for table names (student, not students)
   - Use lowercase with underscores (first_name, not FirstName)
   - Prefix primary keys with table name (student_id in student table)

4. **Constraints**:
   - Always define PRIMARY KEY constraints
   - Use FOREIGN KEY constraints to enforce referential integrity
   - Use CHECK constraints for domain validation
   - Use NOT NULL for required fields

## Advanced DDL Features

### Temporary Tables

```sql
-- Create temporary table
CREATE TEMPORARY TABLE temp_results (
    id INT,
    result VARCHAR(100)
);
```

### Partitioning

```sql
-- Create partitioned table (MySQL example)
CREATE TABLE sales (
    sale_id INT,
    product_id INT,
    sale_date DATE,
    amount DECIMAL(10,2)
)
PARTITION BY RANGE (YEAR(sale_date)) (
    PARTITION p0 VALUES LESS THAN (2020),
    PARTITION p1 VALUES LESS THAN (2021),
    PARTITION p2 VALUES LESS THAN (2022),
    PARTITION p3 VALUES LESS THAN (2023),
    PARTITION p4 VALUES LESS THAN MAXVALUE
);
```

### Sequences (PostgreSQL, Oracle)

```sql
-- PostgreSQL sequence
CREATE SEQUENCE student_id_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
```
