-- ========================
-- 0. Create Database
-- ========================
-- NOTE: Run this part separately in psql or pgAdmin before running the rest
-- CREATE DATABASE companycycle39;

-- Then connect to it:
-- \c companycycle39

-- ========================
-- 1. Create Tables
-- ========================

CREATE TABLE Department (
    DNumber SERIAL PRIMARY KEY,
    DName VARCHAR(15) NOT NULL UNIQUE,
    MGRSSN INT,
    MGRStartDate DATE
);

CREATE TABLE Employee (
    SSN SERIAL PRIMARY KEY,
    FName VARCHAR(15) NOT NULL,
    MInit CHAR(1),
    LName VARCHAR(15),
    BDate DATE,
    Address VARCHAR(50) DEFAULT 'Cairo',
    Sex CHAR(1),
    Salary MONEY,
    SuperSSN INT REFERENCES Employee(SSN),
    DNo INT REFERENCES Department(DNumber)
);

ALTER TABLE Department
ADD CONSTRAINT fk_mgr FOREIGN KEY (MGRSSN) REFERENCES Employee(SSN);

CREATE TABLE Dept_Locations (
    DNumber INT REFERENCES Department(DNumber),
    DLocation VARCHAR(50),
    PRIMARY KEY(DNumber, DLocation)
);

CREATE TABLE Project (
    PNumber SERIAL PRIMARY KEY,
    PName VARCHAR(20) NOT NULL,
    PLocation VARCHAR(50),
    DNum INT REFERENCES Department(DNumber)
);

CREATE TABLE Works_On (
    ESSN INT REFERENCES Employee(SSN),
    PNo INT REFERENCES Project(PNumber),
    Hours SMALLINT,
    PRIMARY KEY(ESSN, PNo)
);

CREATE TABLE Dependent (
    ESSN INT REFERENCES Employee(SSN),
    Dependent_Name VARCHAR(20),
    Sex CHAR(1),
    BDate DATE,
    Relationship VARCHAR(20),
    PRIMARY KEY(ESSN, Dependent_Name)
);

-- ========================
-- 2. Insert Sample Data
-- ========================

-- Insert Departments
INSERT INTO Department (DName, MGRSSN, MGRStartDate) VALUES 
('HR', NULL, '2020-01-01'),
('IT', NULL, '2020-02-01');

-- Insert Employees
INSERT INTO Employee (FName, LName, MInit, BDate, Address, Sex, Salary, DNo)
VALUES 
('Mohammed', 'Mostafa', 'A', '1963-02-07', 'Alex', 'M', 8000, 1),
('Mohamed', 'Ali', 'B', '1999-03-22', 'Cairo', 'M', 4000, 1),
('Mona', 'Nasr', 'H', '1963-02-22', 'Cairo', 'F', 8000, 1),
('Amr', 'Ibrahim', 'S', '1963-02-22', 'Tanta', 'M', 8000, 1),
('Aya', 'Ali', 'A', '1963-02-22', 'Giza', 'F', 8000, 1),
('Mohamed', 'Amr', 'Z', '1963-02-22', 'Mansoura', 'M', 8000, 1);

-- Insert Dept Locations
INSERT INTO Dept_Locations (DNumber, DLocation)
VALUES (1, 'Cairo'), (1, 'Alex'), (2, 'Giza');

-- Insert Projects
INSERT INTO Project (PName, PLocation, DNum)
VALUES 
('Payroll System', 'Cairo', 1),
('Website Redesign', 'Giza', 2);

-- Insert Works_On
INSERT INTO Works_On (ESSN, PNo, Hours)
VALUES 
(1, 1, 10),
(2, 1, 15),
(1, 2, 8),
(3, 2, 20);

-- Insert Dependents
INSERT INTO Dependent (ESSN, Dependent_Name, Sex, BDate, Relationship)
VALUES 
(1, 'Sara', 'F', '2000-01-01', 'Daughter'),
(2, 'Yousef', 'M', '1995-03-01', 'Son');

-- ========================
-- 3. DML (Update/Delete)
-- ========================

-- Update Examples
UPDATE Employee SET Address = 'Dokki' WHERE SSN = 1;
UPDATE Employee SET FName = 'Hamda', LName = 'Hambozo' WHERE SSN = 2;
UPDATE Employee SET Salary = Salary * 1.1 WHERE Salary <= 5000 AND Address = 'Cairo';

-- Delete Example (will fail if ID doesn't exist, just a placeholder)
-- DELETE FROM Employee WHERE SSN = 9;

-- ========================
-- 4. DQL (Queries)
-- ========================

-- View All Employees
SELECT * FROM Employee;

-- Concatenated Names
SELECT FName || ' ' || LName AS FullName FROM Employee;

-- LIKE Pattern (name with 'a' as second letter)
SELECT * FROM Employee WHERE FName ~ '^.a.*';

-- Distinct First Names
SELECT DISTINCT FName FROM Employee;

-- Order by First Name then Birth Date Descending
SELECT SSN, FName, BDate FROM Employee ORDER BY FName, BDate DESC;

-- ========================
-- 5. JOINS
-- ========================

-- Cross Join
SELECT E.FName, D.DName
FROM Employee E CROSS JOIN Department D;

-- Inner Join
SELECT E.FName, D.DName
FROM Employee E INNER JOIN Department D ON D.DNumber = E.DNo;

-- Left Join
SELECT E.FName, D.DName
FROM Employee E LEFT OUTER JOIN Department D ON D.DNumber = E.DNo;

-- Right Join
SELECT E.FName, D.DName
FROM Employee E RIGHT OUTER JOIN Department D ON D.DNumber = E.DNo;

-- Full Outer Join
SELECT E.FName, D.DName
FROM Employee E FULL OUTER JOIN Department D ON D.DNumber = E.DNo;

-- ========================
-- 6. Aggregations & Grouping
-- ========================

-- Total Employees
SELECT COUNT(*) AS TotalEmployees FROM Employee;

-- Average Salary
SELECT AVG(Salary) AS AvgSalary FROM Employee;

-- Count Employees per Department
SELECT D.DName, COUNT(E.SSN) AS NumEmployees
FROM Department D
LEFT JOIN Employee E ON D.DNumber = E.DNo
GROUP BY D.DName;

-- Sum of Work Hours per Project
SELECT P.PName, SUM(W.Hours) AS TotalHours
FROM Project P
JOIN Works_On W ON P.PNumber = W.PNo
GROUP BY P.PName;

-- Project Count per Employee
SELECT E.FName || ' ' || E.LName AS EmployeeName, COUNT(W.PNo) AS Projects
FROM Employee E
LEFT JOIN Works_On W ON E.SSN = W.ESSN
GROUP BY E.FName, E.LName;

-- Number of Dependents per Employee
SELECT E.FName || ' ' || E.LName AS EmployeeName, COUNT(D.Dependent_Name) AS Dependents
FROM Employee E
LEFT JOIN Dependent D ON E.SSN = D.ESSN
GROUP BY E.FName, E.LName;
