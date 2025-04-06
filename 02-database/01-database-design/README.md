# Database Design Fundamentals

## Table of Contents
1. [Introduction to Database Design](#introduction)
2. [Key Concepts](#key-concepts)
3. [Normalization](#normalization)
4. [Entity Relationship Diagrams (ERD)](#erd)
5. [Best Practices](#best-practices)
6. [Advanced Concepts](#advanced-concepts)
7. [Real-World Examples](#real-world-examples)

## Introduction
Database design is the process of creating a detailed data model of a database. This includes defining tables, relationships, and constraints to ensure data integrity and optimal performance.

### Why Database Design Matters
- Ensures data integrity and consistency
- Optimizes performance and query speed
- Reduces data redundancy
- Makes maintenance easier
- Facilitates scalability

## Key Concepts

### 1. Tables and Fields
- **Tables**: Collections of related data organized in rows and columns
  - Example: `users`, `orders`, `products`
- **Fields**: Individual data elements within a table
  - Example: `user_id`, `first_name`, `email`
- **Primary Keys**: Unique identifiers for each record
  - Example: `user_id INT PRIMARY KEY`
- **Foreign Keys**: References to primary keys in other tables
  - Example: `order_id INT REFERENCES orders(id)`

### 2. Data Types
- **Numeric**:
  - `INTEGER`: Whole numbers (-2,147,483,648 to 2,147,483,647)
  - `DECIMAL(p,s)`: Exact decimal numbers (p=precision, s=scale)
  - `FLOAT`: Approximate decimal numbers
  - `BIGINT`: Large whole numbers
  - `SMALLINT`: Small whole numbers

- **Character**:
  - `CHAR(n)`: Fixed-length string (n characters)
  - `VARCHAR(n)`: Variable-length string (up to n characters)
  - `TEXT`: Variable unlimited length
  - `ENUM`: List of predefined values

- **Date/Time**:
  - `DATE`: Date only (YYYY-MM-DD)
  - `TIME`: Time only (HH:MM:SS)
  - `TIMESTAMP`: Date and time
  - `INTERVAL`: Time period

- **Boolean**: TRUE/FALSE
- **Binary**: BLOB, BINARY
- **JSON**: JSON data type
- **Array**: Array of values

### 3. Relationships
- **One-to-One**: Each record in one table relates to exactly one record in another
  - Example: User and UserProfile tables
  ```sql
  CREATE TABLE users (
      user_id INT PRIMARY KEY,
      username VARCHAR(50)
  );

  CREATE TABLE user_profiles (
      profile_id INT PRIMARY KEY,
      user_id INT UNIQUE,
      FOREIGN KEY (user_id) REFERENCES users(user_id)
  );
  ```

- **One-to-Many**: One record in a table relates to many records in another
  - Example: Customer and Orders tables
  ```sql
  CREATE TABLE customers (
      customer_id INT PRIMARY KEY,
      name VARCHAR(100)
  );

  CREATE TABLE orders (
      order_id INT PRIMARY KEY,
      customer_id INT,
      order_date DATE,
      FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
  );
  ```

- **Many-to-Many**: Records in both tables can relate to multiple records in the other
  - Example: Students and Courses tables
  ```sql
  CREATE TABLE students (
      student_id INT PRIMARY KEY,
      name VARCHAR(100)
  );

  CREATE TABLE courses (
      course_id INT PRIMARY KEY,
      title VARCHAR(100)
  );

  CREATE TABLE student_courses (
      student_id INT,
      course_id INT,
      PRIMARY KEY (student_id, course_id),
      FOREIGN KEY (student_id) REFERENCES students(student_id),
      FOREIGN KEY (course_id) REFERENCES courses(course_id)
  );
  ```

## Normalization

### First Normal Form (1NF)
- Eliminate repeating groups
- Ensure atomic values
- Create separate tables for related data

Example of converting to 1NF:
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

### Second Normal Form (2NF)
- Meet 1NF requirements
- Remove partial dependencies
- All non-key attributes must depend on the entire primary key

Example:
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

### Third Normal Form (3NF)
- Meet 2NF requirements
- Remove transitive dependencies
- No non-key attribute should depend on another non-key attribute

Example:
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

## Entity Relationship Diagrams (ERD)

### Components
- **Entities**: Tables in the database
  - Represented as rectangles
  - Example: Customer, Order, Product
- **Attributes**: Columns in the tables
  - Represented as ovals
  - Example: customer_id, name, email
- **Relationships**: Connections between tables
  - Represented as diamonds
  - Example: "places" between Customer and Order
- **Cardinality**: Number of relationships between entities
  - One-to-One: 1:1
  - One-to-Many: 1:N
  - Many-to-Many: M:N

### Notation Examples
```
Customer (1) ----< Order (N)
   |                  |
   |                  |
   v                  v
[Attributes]      [Attributes]
```

## Best Practices

1. **Naming Conventions**
   - Use clear, descriptive names
   - Follow consistent naming patterns
   - Avoid reserved words
   - Use singular form for table names
   - Use lowercase with underscores
   - Prefix foreign keys with table name
   ```sql
   -- Good naming examples
   CREATE TABLE users (
       user_id INT PRIMARY KEY,
       first_name VARCHAR(50),
       email_address VARCHAR(100)
   );

   CREATE TABLE user_roles (
       user_role_id INT PRIMARY KEY,
       user_id INT,
       role_id INT,
       FOREIGN KEY (user_id) REFERENCES users(user_id)
   );
   ```

2. **Data Integrity**
   - Implement proper constraints
   - Use appropriate data types
   - Maintain referential integrity
   - Add CHECK constraints for valid data
   ```sql
   CREATE TABLE employees (
       employee_id INT PRIMARY KEY,
       salary DECIMAL(10,2) CHECK (salary >= 0),
       hire_date DATE CHECK (hire_date <= CURRENT_DATE),
       email VARCHAR(100) CHECK (email LIKE '%@%.%')
   );
   ```

3. **Performance Considerations**
   - Index frequently queried columns
   - Optimize table structure
   - Consider denormalization when necessary
   - Use appropriate data types
   ```sql
   -- Create indexes for frequently queried columns
   CREATE INDEX idx_customer_email ON customers(email);
   CREATE INDEX idx_order_date ON orders(order_date);
   ```

4. **Security**
   - Implement proper access controls
   - Encrypt sensitive data
   - Regular backups
   - Use parameterized queries
   - Implement audit trails
   ```sql
   -- Example of audit trail
   CREATE TABLE audit_log (
       audit_id INT PRIMARY KEY,
       table_name VARCHAR(50),
       action VARCHAR(10),
       user_id INT,
       timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       old_value TEXT,
       new_value TEXT
   );
   ```

## Advanced Concepts

### 1. Denormalization
- When to denormalize:
  - For reporting purposes
  - To improve read performance
  - For data warehousing
  - When dealing with complex calculations

### 2. Partitioning
- Types of partitioning:
  - Range partitioning
  - List partitioning
  - Hash partitioning
  - Composite partitioning

### 3. Sharding
- Horizontal partitioning
- Distributed databases
- Considerations for sharding:
  - Key selection
  - Data distribution
  - Query routing

## Real-World Examples

### 1. E-commerce Database
```sql
-- Core tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(200),
    description TEXT,
    price DECIMAL(10,2),
    stock_quantity INT,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP,
    total_amount DECIMAL(10,2),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### 2. Social Media Database
```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    content TEXT,
    created_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE comments (
    comment_id INT PRIMARY KEY,
    post_id INT,
    user_id INT,
    content TEXT,
    created_at TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE likes (
    user_id INT,
    post_id INT,
    created_at TIMESTAMP,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (post_id) REFERENCES posts(post_id)
);
```

## Practice Exercises
1. Design a database for a library management system
2. Create an ERD for an e-commerce platform
3. Normalize a denormalized table structure
4. Design a database for a hospital management system
5. Create a database schema for a school management system
6. Design a database for a restaurant management system 