# SQL Overview

SQL (Structured Query Language) is a standard programming language designed for managing and manipulating relational databases. It allows users to create, read, update, and delete database records.

---

## SQL Command Categories

![SQL Command Categories](https://tse2.mm.bing.net/th?id=OIP.grp_N6bKRwXuKfxy55zPgwHaHq&pid=Api)

SQL commands are grouped into several categories based on their functionality:

1. **DDL (Data Definition Language)** – Used to define database structure  
2. **DML (Data Manipulation Language)** – Used to manipulate data within the database  
3. **DQL (Data Query Language)** – Used to retrieve data from the database  
4. **DCL (Data Control Language)** – Used to control access to data within the database  
5. **TCL (Transaction Control Language)** – Used to manage transactions in the database  

Each category serves a specific purpose in database management and development.

---

## SQL Database Systems

![Database Systems](https://tse2.mm.bing.net/th?id=OIP.vmJyit9iM6-RQDbT0OoDaQHaFj&pid=Api)

Popular SQL database systems include:

- Microsoft SQL Server  
- MySQL  
- PostgreSQL  
- Oracle Database  
- SQLite  

These systems implement SQL with variations but adhere to core standards.

---

## History of SQL

![History of SQL](https://tse2.mm.bing.net/th?id=OIP.FEUaS5uuNw2Bx-zX_9jD-wHaGL&pid=Api)

SQL was developed at IBM in the early 1970s by Donald D. Chamberlin and Raymond F. Boyce. Originally called SEQUEL (Structured English Query Language), it was created to manipulate and retrieve data in IBM's System R database.

In 1979, Oracle (then Relational Software, Inc.) released the first commercial SQL implementation. ANSI standardized SQL in 1986, followed by ISO in 1987.

---

## SQL Syntax Foundations

SQL syntax is built around a few core statement types:

```sql
-- Simple SELECT statement
SELECT column1, column2 FROM table_name;

-- Filtering with WHERE clause
SELECT column1, column2 FROM table_name WHERE condition;

-- Sorting results
SELECT column1, column2 FROM table_name ORDER BY column1;

-- Grouping data
SELECT column1, COUNT(*) FROM table_name GROUP BY column1;

-- Joining tables
SELECT a.column1, b.column2 
FROM table_a a
JOIN table_b b ON a.id = b.a_id;
```

---

## SQL Implementation Differences

![Types of SQL Commands](https://tse4.mm.bing.net/th?id=OIP.RHOq6imhLSyWQJ7II_xP4AHaJQ&pid=Api)

Although SQL is standardized, different database systems implement some syntax and behavior differently:

| Feature               | MySQL             | SQL Server | PostgreSQL | Oracle       |
|-----------------------|-------------------|------------|------------|--------------|
| String Concatenation  | `CONCAT()` or `+` | `+`        | `||`       | `||`         |
| LIMIT Syntax          | `LIMIT n`         | `TOP n`    | `LIMIT n`  | `ROWNUM <= n`|
| Date Functions        | `NOW()`           | `GETDATE()`| `CURRENT_TIMESTAMP` | `SYSDATE` |
| Auto-increment        | `AUTO_INCREMENT`  | `IDENTITY` | `SERIAL`   | Sequences    |

---
