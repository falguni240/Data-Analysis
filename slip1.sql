CREATE TABLE Supplier (
  Sno VARCHAR(5) PRIMARY KEY
    CHECK (Sno LIKE 'S[0-9][0-9]%' AND LEN(Sno) BETWEEN 2 AND 5),
  Sname NVARCHAR(50) NOT NULL,
  Address NVARCHAR(100) NOT NULL,
  City NVARCHAR(20) NOT NULL
    CHECK (City IN ('London','Paris','Rome','New York','Amsterdam'))
);

CREATE TABLE Parts (
  Pno VARCHAR(5) PRIMARY KEY,
  Pname NVARCHAR(50) NOT NULL,
  Color NVARCHAR(20) NOT NULL,
  Weight DECIMAL(7,2) NOT NULL,
  Price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Project (
  Jno VARCHAR(5) PRIMARY KEY,
  Jname NVARCHAR(50) NOT NULL UNIQUE,
  City NVARCHAR(20) NOT NULL
    CHECK (City IN ('London','Paris','Rome','New York','Amsterdam'))
);

CREATE TABLE SPJ (
  Sno VARCHAR(5) NOT NULL,
  Pno VARCHAR(5) NOT NULL,
  Jno VARCHAR(5) NOT NULL,
  Qty INT NOT NULL,
  PRIMARY KEY (Sno, Pno, Jno),
  FOREIGN KEY (Sno) REFERENCES Supplier(Sno),
  FOREIGN KEY (Pno) REFERENCES Parts(Pno),
  FOREIGN KEY (Jno) REFERENCES Project(Jno)
);

INSERT INTO SUPPLIER VALUES
('S101', 'Alpha Ltd', '12 King St', 'London'),
('S102', 'Bravo Inc', '5 Rue de Lyon', 'Paris'),
('S103', 'Charlie LLC', '88 Roma Ave', 'Rome'),

('S104', 'Delta Corp', '123 Broadway', 'New York'),
('S105', 'Echo GmbH', '78 Amstel', 'Amsterdam'),
('S106', 'Foxtrot BV', '10 Canal Rd', 'Amsterdam'),
('S107', 'Golf Ltd', '456 Wall St', 'New York'),
('S108', 'Hotel PLC', '3 Champs Elysees', 'Paris'),
('S109', 'India Co', '7 Via Appia', 'Rome'),
('S110', 'Juliet Ltd', '1 Tower Bridge', 'London');

INSERT INTO PARTS VALUES
('P1', 'Bolt', 'Red', 0.50, 1.00),
('P2', 'Nut', 'Blue', 0.30, 0.50),
('P3', 'Screw', 'Green', 0.40, 0.75),
('P4', 'Washer', 'Red', 0.10, 0.25),
('P5', 'Gear', 'Black', 2.00, 5.00),
('P6', 'Wheel', 'Black', 4.50, 15.00),
('P7', 'Spring', 'Silver', 1.20, 2.50),
('P8', 'Chain', 'Gray', 3.00, 6.00),
('P9', 'Lever', 'Yellow', 1.50, 3.00),
('P10', 'Axle', 'Blue', 3.50, 7.50);

-- PROJECT
INSERT INTO PROJECT VALUES
('J1', 'Apollo', 'London'),
('J2', 'Zeus', 'Paris'),
('J3', 'Hermes', 'Rome'),
('J4', 'Athena', 'New York'),
('J5', 'Poseidon', 'Amsterdam'),
('J6', 'Hera', 'London'),
('J7', 'Artemis', 'Paris'),
('J8', 'Ares', 'Rome'),
('J9', 'Dionysus', 'New York'),
('J10', 'Hephaestus', 'Amsterdam');

-- SPJ
INSERT INTO SPJ VALUES
('S101', 'P1', 'J1', 100),
('S101', 'P2', 'J1', 200),
('S101', 'P3', 'J1', 220),
('S102', 'P3', 'J2', 150),
('S102', 'P4', 'J2', 250),
('S103', 'P5', 'J2', 190),
('S104', 'P6', 'J4', 100),
('S105', 'P7', 'J5', 200),
('S106', 'P8', 'J6', 150),
('S107', 'P9', 'J7', 200),
('S108', 'P10', 'J8', 180),
('S109', 'P1', 'J9', 160),
('S110', 'P2', 'J10', 140);

SELECT P.Jno, P.Jname
FROM Project P
JOIN SPJ S ON P.Jno = S.Jno
GROUP BY P.Jno, P.Jname
HAVING COUNT(DISTINCT S.Pno) >= 3;

SELECT *
FROM Project
WHERE City = 'London';

SELECT P.*, S.*
FROM Project P
LEFT JOIN SPJ S ON P.Jno = S.Jno
WHERE P.City = 'London';

CREATE TRIGGER trg_Project_NoDupName
ON Project
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check for duplicate project names
    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        JOIN Project AS p
          ON p.Jname = i.Jname
         AND p.Jno <> i.Jno
    )
    BEGIN
        DECLARE @dupName NVARCHAR(50);
        SELECT TOP 1 @dupName = i.Jname FROM inserted AS i;

        RAISERROR ('Duplicate project name: %s', 16, 1, @dupName);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE PROCEDURE usp_TotalSales_Paris
  @TotalSales DECIMAL(18,2) OUTPUT
AS
BEGIN
  SET NOCOUNT ON;

  SELECT @TotalSales = SUM(p.Price * s.Qty)
  FROM SPJ s
  JOIN Parts p ON s.Pno = p.Pno
  JOIN Project j ON s.Jno = j.Jno
  WHERE j.City = 'Paris';

  IF @TotalSales IS NULL SET @TotalSales = 0;
END;
GO
