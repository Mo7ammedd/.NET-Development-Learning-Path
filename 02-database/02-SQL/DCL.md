# Data Control Language (DCL)

DCL (Data Control Language) manages access permissions and security in a database system. It controls who can access which objects and what operations they can perform.

## User Management

Before granting permissions, we need to create database users:

```sql
-- Create a new user (MySQL)
CREATE USER 'john'@'localhost' IDENTIFIED BY 'password123';

-- Create a new user (SQL Server)
CREATE LOGIN john WITH PASSWORD = 'password123';
CREATE USER john FOR LOGIN john;

-- Create a new user (PostgreSQL)
CREATE USER john WITH PASSWORD 'password123';

-- Create a new user (Oracle)
CREATE USER john IDENTIFIED BY password123;
```

## GRANT Command

The GRANT command gives specific privileges to users or roles.

### Table Privileges

```sql
-- Grant specific table privileges
GRANT SELECT, INSERT ON students TO john;

-- Grant all privileges on a table
GRANT ALL PRIVILEGES ON courses TO jane;

-- Grant privileges with grant option (allows user to grant these privileges to others)
GRANT SELECT, UPDATE ON grades TO professor WITH GRANT OPTION;

-- Grant column-level privileges
GRANT SELECT (student_id, first_name, last_name), 
      UPDATE (email, phone) 
ON students TO admin_assistant;
```

### Database Privileges

```sql
-- Grant database-level privileges (MySQL)
GRANT CREATE, ALTER, DROP ON school.* TO dba_user;

-- Grant schema privileges (PostgreSQL)
GRANT USAGE ON SCHEMA public TO app_user;

-- Grant system privileges (Oracle)
GRANT CREATE SESSION, CREATE TABLE TO developer;

-- Grant role to user (SQL Server)
GRANT db_datareader TO reporting_user;
```

## REVOKE Command

The REVOKE command removes previously granted privileges.

```sql
-- Revoke specific privileges
REVOKE INSERT, UPDATE ON students FROM john;

-- Revoke all privileges
REVOKE ALL PRIVILEGES ON courses FROM jane;

-- Revoke grant option
REVOKE GRANT OPTION FOR SELECT ON grades FROM professor;

-- Revoke from multiple users
REVOKE SELECT ON financial_data FROM user1, user2, user3;
```

## Role-Based Access Control

Roles group privileges together for easier management.

```sql
-- Create role (most database systems)
CREATE ROLE teacher_role;

-- Grant privileges to role
GRANT SELECT ON ALL TABLES IN SCHEMA public TO teacher_role;
GRANT INSERT, UPDATE, DELETE ON assignments, grades TO teacher_role;

-- Grant role to users
GRANT teacher_role TO teacher1, teacher2, teacher3;

-- Revoke role
REVOKE teacher_role FROM teacher3;

-- Drop role
DROP ROLE IF EXISTS temp_role;
```

## Advanced Permissions

### Row-Level Security (PostgreSQL)

```sql
-- Create policy for row-level security
CREATE POLICY student_data_policy ON students
    USING (advisor_id = current_user_id());

-- Enable row-level security on table
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
```

### Dynamic Data Masking (SQL Server)

```sql
-- Create a column with masking
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    ssn VARCHAR(11) MASKED WITH (FUNCTION = 'partial(0,"XXX-XX-",4)'),
    birth_date DATE MASKED WITH (FUNCTION = 'default()')
);

-- Grant unmask permission
GRANT UNMASK TO administrator;
```

### Column Encryption (MySQL)

```sql
-- Create table with encrypted column
CREATE TABLE payment_info (
    payment_id INT PRIMARY KEY,
    student_id INT,
    credit_card VARCHAR(255) ENCRYPTION KEY_ID 3,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
```

## Implementing Principle of Least Privilege

The principle of least privilege means giving users only the permissions they need:

1. **Identify user roles** (e.g., students, teachers, administrators)
2. **Define permission sets** for each role
3. **Create database roles** matching the identified roles
4. **Assign minimum necessary permissions** to each role
5. **Grant roles to users** rather than individual permissions
6. **Regularly audit permissions** to ensure they remain appropriate

Example implementation:

```sql
-- Create application roles
CREATE ROLE app_readonly;
CREATE ROLE app_standard;
CREATE ROLE app_power;
CREATE ROLE app_admin;

-- Set up tiered permissions
GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_readonly;

GRANT SELECT, INSERT, UPDATE ON students, enrollments TO app_standard;
GRANT SELECT ON courses, teachers TO app_standard;
GRANT app_readonly TO app_standard;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_power;
GRANT app_standard TO app_power;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app_admin;
GRANT CREATE, ALTER, DROP ON SCHEMA public TO app_admin;
GRANT app_power TO app_admin;

-- Assign users to appropriate roles
GRANT app_readonly TO reporting_user;
GRANT app_standard TO registrar;
GRANT app_power TO department_head;
GRANT app_admin TO system_admin;
```

## Security Best Practices

1. **Use roles** to manage permissions rather than individual grants
2. **Implement least privilege** by default
3. **Audit permissions** regularly using system views
4. **Use parameterized queries** to prevent SQL injection
5. **Encrypt sensitive data** at rest and in transit
6. **Avoid using database root/owner accounts** in applications
7. **Separate schema owner** from application user
8. **Implement row-level security** where appropriate
9. **Use views** to restrict column access
10. **Set password policies** and rotation schedules
