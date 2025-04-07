# Data Manipulation Language (DML)

DML (Data Manipulation Language) is used to manipulate data stored in database tables. The primary DML commands are INSERT, UPDATE, DELETE, and SELECT (though SELECT is sometimes categorized separately under DQL).

## INSERT Command

The INSERT command adds new rows to a table.

### Basic INSERT

```sql
-- Insert a single row with all columns in order
INSERT INTO students 
VALUES (101, 'mohammed', 'mostafa', '2005-03-15', '2022-09-01', 10, 'mohammed.mostafa@example.com');

-- Insert with specified columns
INSERT INTO students (student_id, first_name, last_name, grade_level) 
VALUES (102, 'Emma', 'mohammedson', 9);

-- Insert multiple rows
INSERT INTO students (student_id, first_name, last_name, grade_level) 
VALUES 
    (103, 'Michael', 'Williams', 11),
    (104, 'Sophia', 'Brown', 10),
    (105, 'William', 'Jones', 12);
```

### INSERT with Subquery

```sql
-- Insert data from another table
INSERT INTO archived_students (student_id, first_name, last_name, graduation_date)
SELECT student_id, first_name, last_name, CURRENT_DATE
FROM students
WHERE grade_level = 12;
```

### INSERT with DEFAULT values

```sql
-- Use DEFAULT keyword for columns with default values
INSERT INTO assignments (assignment_id, title, due_date, course_id)
VALUES (201, 'Term Paper', '2023-12-15', 301, DEFAULT);

-- Use DEFAULT for all columns that have defaults
INSERT INTO log_entries (log_id, log_message)
VALUES (1001, 'System start');
```

## UPDATE Command

The UPDATE command modifies existing data in a table.

### Basic UPDATE

```sql
-- Update a single column for one row
UPDATE students
SET email = 'mohammed.mostafa.new@example.com'
WHERE student_id = 101;

-- Update multiple columns
UPDATE students
SET 
    grade_level = 11,
    last_updated = CURRENT_TIMESTAMP
WHERE student_id = 102;

-- Update all rows
UPDATE courses
SET academic_year = '2023-2024';
```

### UPDATE with Calculated Values

```sql
-- Update with calculation
UPDATE assignments
SET points_possible = points_possible * 1.1
WHERE difficulty_level = 'Hard';

-- Update with CASE statement
UPDATE students
SET status = CASE
    WHEN grade_point_average >= 3.5 THEN 'Honor Roll'
    WHEN grade_point_average >= 2.0 THEN 'Good Standing'
    ELSE 'Academic Probation'
END;
```

### UPDATE with Subquery

```sql
-- Update based on data in another table
UPDATE courses
SET enrollment_count = (
    SELECT COUNT(*) 
    FROM enrollments 
    WHERE enrollments.course_id = courses.course_id
);

-- Update with correlated subquery in WHERE clause
UPDATE students
SET needs_advisor = TRUE
WHERE grade_level = 9 AND
NOT EXISTS (
    SELECT 1 
    FROM advisors 
    WHERE advisors.student_id = students.student_id
);
```

## DELETE Command

The DELETE command removes rows from a table.

### Basic DELETE

```sql
-- Delete a single row
DELETE FROM students
WHERE student_id = 105;

-- Delete multiple rows
DELETE FROM enrollments
WHERE semester = 'Fall 2022' AND status = 'Withdrawn';

-- Delete all rows
DELETE FROM temp_data;
```

### DELETE with Subquery

```sql
-- Delete based on subquery
DELETE FROM assignments
WHERE course_id IN (
    SELECT course_id
    FROM courses
    WHERE status = 'Cancelled'
);

-- Delete with complex condition
DELETE FROM student_activities
WHERE student_id IN (
    SELECT student_id
    FROM students
    WHERE grade_level = 12 AND graduation_status = 'Graduated'
) AND activity_date < CURRENT_DATE - INTERVAL '1 year';
```

## MERGE Command (UPSERT)

The MERGE command (also called UPSERT in some databases) combines INSERT and UPDATE operations.

```sql
-- SQL Server syntax
MERGE INTO students AS target
USING imported_students AS source
ON target.student_id = source.student_id
WHEN MATCHED THEN
    UPDATE SET
        target.first_name = source.first_name,
        target.last_name = source.last_name,
        target.grade_level = source.grade_level,
        target.last_updated = CURRENT_TIMESTAMP
WHEN NOT MATCHED THEN
    INSERT (student_id, first_name, last_name, grade_level, enrollment_date)
    VALUES (source.student_id, source.first_name, source.last_name, 
            source.grade_level, CURRENT_DATE);

-- PostgreSQL syntax
INSERT INTO students (student_id, first_name, last_name, grade_level)
VALUES (106, 'Robert', 'Taylor', 10)
ON CONFLICT (student_id)
DO UPDATE SET
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    grade_level = EXCLUDED.grade_level;
```

## DML Performance Considerations

1. **Batch Processing**: Group multiple INSERT/UPDATE statements for efficiency
2. **Indexes**: Be aware that DML operations may be slower on heavily indexed tables
3. **Triggers**: Remember that triggers can be fired by DML operations, affecting performance
4. **Locks**: Large UPDATE/DELETE operations can lock tables and block other operations
5. **Transaction Size**: Keep transactions reasonably sized for better concurrency

## DML Error Handling

```sql
-- SQL Server transaction with error handling
BEGIN TRY
    BEGIN TRANSACTION;
    
    INSERT INTO students (student_id, first_name, last_name)
    VALUES (107, 'Jessica', 'Miller');
    
    UPDATE courses
    SET instructor_id = 201
    WHERE course_id = 301;
    
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    -- Log error
    INSERT INTO error_log (error_message)
    VALUES (ERROR_MESSAGE());
END CATCH;
```
