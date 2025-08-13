CREATE TABLE EMPLOYEE (
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    ssn CHAR(9) PRIMARY KEY,  -- SSN must be a 9-character string
    sex CHAR(1) NOT NULL,      -- 'M' for male, 'F' for female
    salary DECIMAL(10, 2) NOT NULL,
    joindate DATE NOT NULL,
    superssn CHAR(9),         -- Supervisor's SSN, NULL allowed
    dno INT CHECK (dno < 1000)  -- deptno should be less than 4 digits
);

-- Create DEPT table
CREATE TABLE DEPT (
    dname VARCHAR(50) NOT NULL,
    dnum INT PRIMARY KEY CHECK (dnum < 1000),  -- deptno should be less than 4 digits
    mgrssn CHAR(9) NOT NULL, -- Manager's SSN
    dlocation VARCHAR(100) NOT NULL
);

-- Create PROJECT table
CREATE TABLE PROJECT1 (
    ppname VARCHAR(50) NOT NULL,
    pno INT PRIMARY KEY CHECK (pno > 0),
    plocation VARCHAR(100) NOT NULL,
    dnumber INT,  -- Foreign key for deptnum
    FOREIGN KEY (dnumber) REFERENCES DEPT(dnum)
);
drop table WORK_ON;
-- Create WORK_ON table
CREATE TABLE WORK_ON (
    ssn CHAR(9),  -- Employee SSN
    pno INT,      -- Project Number
	dnumber int ,
    hours DECIMAL(5, 2),  -- Hours worked on project
    PRIMARY KEY (ssn, pno),
    FOREIGN KEY (ssn) REFERENCES EMPLOYEE(ssn),
    FOREIGN KEY (pno) REFERENCES PROJECT1(pno)
);
Step 2: Insert Sample Data (at least 10 records in each table)
sql
CopyEdit
-- Insert into EMPLOYEE
INSERT INTO EMPLOYEE (fname, lname, ssn, sex, salary, joindate, superssn, dno)
VALUES 
('John', 'Doe', '123456789', 'M', 50000, '2020-01-15', NULL, 1),
('Jane', 'Smith', '987654321', 'F', 60000, '2019-03-22', '123456789', 2),
('Emily', 'Johnson', '112233445', 'F', 70000, '2018-06-12', '987654321', 3),
('Michael', 'Brown', '998877665', 'M', 55000, '2021-07-01', NULL, 1),
('David', 'Davis', '223344556', 'M', 48000, '2022-05-11', '112233445', 2),
('Sarah', 'Miller', '667788990', 'F', 62000, '2020-02-28', '223344556', 3),
('Daniel', 'Garcia', '334455667', 'M', 54000, '2021-09-10', NULL, 1),
('Sophia', 'Martinez', '778899224', 'F', 75000, '2018-10-03', '334455667', 2),
('James', 'Rodriguez', '556677889', 'M', 69000, '2019-12-14', '778899224', 3),
('Olivia', 'Lopez', '445566778', 'F', 57000, '2022-08-25', '556677889', 1);

-- Insert into DEPT
INSERT INTO DEPT (dname, dnum, mgrssn, dlocation)
VALUES
('HR', 1, '123456789', 'New York'),
('Engineering', 2, '987654321', 'San Francisco'),
('Sales', 3, '112233445', 'Chicago');

-- Insert into PROJECT
INSERT INTO PROJECT1 (ppname, pno, plocation, dnumber)
VALUES
('Project A', 101, 'New York', 1),
('Project B', 102, 'San Francisco', 2),
('Project C', 103, 'Chicago', 3),
('Project D', 104, 'Los Angeles', 1),
('Project E', 105, 'Boston', 2),
('Project F', 106, 'Miami', 3),
('Project G', 107, 'Dallas', 1),
('Project H', 108, 'Seattle', 2),
('Project I', 109, 'Denver', 3),
('Project J', 110, 'Austin', 1);

-- Insert into WORK_ON
INSERT INTO WORK_ON (ssn, pno, hours)
VALUES
('123456789', 101, 35.5),
('987654321', 102, 40.0),
('112233445', 103, 25.0),
('998877665', 101, 20.0),
('223344556', 104, 30.5),
('667788990', 105, 15.0),
('334455667', 106, 28.0),
('778899224', 107, 33.5),
('556677889', 108, 19.5),
('445566778', 109, 22.0);
--Step 3: SQL Queries
--a) Find the SSN of all employees who work on pno 101, 102, or 103.

SELECT DISTINCT ssn
FROM WORK_ON
WHERE pno IN (101, 102, 103);
--b) List of all pno for projects that involve an employee whose last name is 'sonar' either as a worker or as a manager of the dept that controls the project.

SELECT DISTINCT pno
FROM PROJECT1
WHERE dnumber IN (
    SELECT dno
    FROM EMPLOYEE
    WHERE lname = 'sonar'
)
OR pno IN (
    SELECT pno
    FROM WORK_ON
    WHERE ssn IN (
        SELECT ssn
        FROM EMPLOYEE
        WHERE lname = 'sonar'
    )
);
--c) Trigger on insert on WORK_ON table such that if total work hours of employee in company are less than 20 hours, their salary is deducted.

CREATE TRIGGER DeductSalaryOnLowHours
ALTER INSERT ON WORK_ON
FOR EACH ROW
BEGIN
    DECLARE total_hours DECIMAL(10, 2);
    DECLARE current_salary DECIMAL(10, 2);
    
    -- Calculate total work hours for the employee
    SELECT SUM(hours) INTO total_hours
    FROM WORK_ON
    WHERE ssn = NEW.ssn;

    -- Check if total work hours are less than 20
    IF total_hours < 20 THEN
        -- Deduct 10% salary
        SELECT salary INTO current_salary
        FROM EMPLOYEE
        WHERE ssn = NEW.ssn;
        
        UPDATE EMPLOYEE
        SET salary = current_salary * 0.9
        WHERE ssn = NEW.ssn;
    END IF;
END;
