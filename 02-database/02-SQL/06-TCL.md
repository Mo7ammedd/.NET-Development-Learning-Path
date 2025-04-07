# Transaction Control Language (TCL)

TCL (Transaction Control Language) manages transactions within a database. A transaction is a logical unit of work that contains one or more SQL statements, which either all succeed (commit) or all fail (rollback).

## ACID Properties

Database transactions follow ACID properties:

1. **Atomicity**: All operations in a transaction succeed or all are rolled back
2. **Consistency**: A transaction takes the database from one valid state to another
3. **Isolation**: Concurrent transactions don't interfere with each other
4. **Durability**: Once committed, changes remain permanent even after system failures

## Transaction Control Commands

### BEGIN TRANSACTION

Marks the start of a transaction.

```sql
-- Standard SQL
BEGIN TRANSACTION;

-- MySQL
START TRANSACTION;

-- Oracle (implicit transaction start)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

### COMMIT

Saves all changes made during the current transaction.

```sql
-- Commit a transaction
COMMIT;

-- Commit with comment (Oracle)
COMMIT COMMENT 'Updated student grades for Fall semester';
```

### ROLLBACK

Undoes all changes made during the current transaction.

```sql
-- Rollback entire transaction
ROLLBACK;

-- Rollback to a savepoint
ROLLBACK TO SAVEPOINT before_update;
```

### SAVEPOINT

Creates a point within a transaction to which you can later roll back.

```sql
-- Create a savepoint
SAVEPOINT before_update;

-- Create multiple savepoints
SAVEPOINT after_inserts;
SAVEPOINT after_updates;
SAVEPOINT before_deletes;

-- Rollback to a specific savepoint
ROLLBACK TO SAVEPOINT after_inserts;
```

## Transaction Isolation Levels

SQL-standard isolation levels control how transactions interact:

| Isolation Level | Dirty Read | Non-repeatable Read | Phantom Read |
|-----------------|------------|---------------------|--------------|
| READ UNCOMMITTED| May occur  | May occur           | May occur    |
| READ COMMITTED  | Prevented  | May occur           | May occur    |
| REPEATABLE READ | Prevented  | Prevented           | May occur    |
| SERIALIZABLE    | Prevented  | Prevented           | Prevented    |

```sql
-- Set transaction isolation level (standard SQL)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Set default isolation level (MySQL)
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Set isolation level (SQL Server)
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

## Transaction Phenomena

1. **Dirty Read**: Transaction reads data written by a concurrent uncommitted transaction
2. **Non-repeatable Read**: Transaction reads same row twice and gets different values
3. **Phantom Read**: Transaction re-executes a query and finds new rows added by another transaction
4. **Lost Update**: Two transactions select same row, then first writes update, then second writes update, overwriting first update

## Practical Transaction Examples

### Basic Transaction Example

```sql
-- Register a student for courses
BEGIN TRANSACTION;

-- Add student to system
INSERT INTO students (student_id, first_name, last_name, grade_level)
VALUES (108, 'David', 'Wilson', 9);

-- Enroll student in required courses
INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date)
VALUES 
    (5001, 108, 301, CURRENT_DATE),
    (5002, 108, 302, CURRENT_DATE),
    (5003, 108, 303, CURRENT_DATE);

-- Update course enrollment counts
UPDATE courses
SET current_enrollment = current_enrollment + 1
WHERE course_id IN (301, 302, 303);

-- If everything is successful, commit the changes
COMMIT;
```

### Transaction with Error Handling

```sql
-- SQL Server transaction with error handling
BEGIN TRY
    BEGIN TRANSACTION;
    
    -- Update student grade
    UPDATE enrollments
    SET final_grade = 'A'
    WHERE student_id = 101 AND course_id = 301;
    
    -- Update GPA in student record
    UPDATE students
    SET grade_point_average = (
        SELECT AVG(grade_point)
        FROM enrollments e
        JOIN grade_values g ON e.final_grade = g.letter_grade
        WHERE e.student_id = 101
    )
    WHERE student_id = 101;
    
    COMMIT TRANSACTION;
    PRINT 'Transaction committed successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
END CATCH;
```

### Transaction with Savepoints

```sql
-- Process end of semester operations
BEGIN TRANSACTION;

-- Archive old enrollment data
INSERT INTO enrollment_history
SELECT * FROM enrollments WHERE semester = 'Spring 2023';

SAVEPOINT after_archive;

-- Delete old enrollment data
DELETE FROM enrollments WHERE semester = 'Spring 2023';

SAVEPOINT after_delete;

-- Update student status based on GPA
UPDATE students
SET academic_status = CASE
    WHEN grade_point_average >= 3.5 THEN 'Honor Roll'
    WHEN grade_point_average >= 2.0 THEN 'Good Standing'
    ELSE 'Academic Probation'
END;

-- If the updates look correct, commit
-- If just the delete is problematic: ROLLBACK TO SAVEPOINT after_archive
-- If everything is problematic: ROLLBACK
COMMIT;
```

## Deadlocks and Handling

A deadlock occurs when two transactions wait for each other to release locks.

```sql
-- Set deadlock priority (SQL Server)
SET DEADLOCK_PRIORITY LOW;

-- Deadlock retry logic (pseudocode)
BEGIN
    DECLARE retry_count INT = 0;
    WHILE retry_count < 3 BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;
            
            -- Transaction operations here
            
            COMMIT TRANSACTION;
            BREAK;  -- Exit loop if successful
        END TRY
        BEGIN CATCH
            IF ERROR_NUMBER() = 1205 -- Deadlock victim error code
            BEGIN
                ROLLBACK TRANSACTION;
                SET retry_count = retry_count + 1;
                -- Wait before retrying
                WAITFOR DELAY '00:00:00.1';
            END
            ELSE
            BEGIN
                -- Non-deadlock error
                ROLLBACK TRANSACTION;
                -- Re-throw error
                THROW;
            END
        END CATCH
    END
END
```

## Best Practices for Transactions

1. **Keep transactions short** to minimize lock contention
2. **Access objects in the same order** in different transactions to avoid deadlocks
3. **Use appropriate isolation levels** for your needs
4. **Include error handling** and proper ROLLBACK logic
5. **Consider read-only transactions** where appropriate
6. **Avoid user interaction** during an open transaction
7. **Be careful with autocommit** settings
8. **Use explicit transactions** rather than relying on implicit behavior
9. **Test transaction behavior** under concurrent load
10. **Monitor long-running transactions** in production systems
