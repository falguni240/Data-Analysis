CREATE TABLE Product (
  Maker VARCHAR(50) NOT NULL,
  Modelno VARCHAR(10) PRIMARY KEY,
  Type VARCHAR(10) NOT NULL
    CHECK (Type IN ('PC', 'Laptop', 'Printer'))
);

CREATE TABLE PC (
  Modelno VARCHAR(10) PRIMARY KEY,
  Speed INT NOT NULL,
  RAM INT NOT NULL,
  HD INT NOT NULL,
  CD VARCHAR(50) NOT NULL,
  Price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (Modelno) REFERENCES Product(Modelno)
);

CREATE TABLE Laptop (
  Modelno VARCHAR(10) PRIMARY KEY,
  Speed INT NOT NULL,
  RAM INT NOT NULL,
  HD INT NOT NULL,
  Price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (Modelno) REFERENCES Product(Modelno)
);

CREATE TABLE Printer (
  Modelno VARCHAR(10) PRIMARY KEY,
  Color CHAR(1) NOT NULL CHECK (Color IN ('T','F')),
  Type VARCHAR(20) NOT NULL CHECK (Type IN ('laser', 'ink-jet', 'dot-matrix', 'dry')),
  Price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (Modelno) REFERENCES Product(Modelno)
);

-- PRODUCT
INSERT INTO PRODUCT VALUES
('IBM', 1001, 'PC'), ('IBM', 1002, 'Laptop'), ('Compaq', 1003,
'PC'),
('HP', 1004, 'Printer'), ('Dell', 1005, 'Laptop'), ('Lenovo', 1006,
'PC'),

('HP', 1007, 'Laptop'), ('Canon', 1008, 'Printer'), ('Asus', 1009,
'Laptop'),
('Epson', 1010, 'Printer'), ('Dell', 1011, 'PC'), ('Asus', 1012,
'Laptop');

-- PC
INSERT INTO PC VALUES
(1001, 200, 8, 500, '52X', 40000),
(1003, 150, 4, 320, '40X', 35000),
(1006, 180, 8, 256, '48X', 37000),
(1011, 170, 4, 500, '52X', 33000);

-- LAPTOP
INSERT INTO LAPTOP VALUES
(1002, 250, 8, 512, 45000),
(1005, 220, 4, 256, 40000),
(1007, 180, 4, 320, 35000),
(1009, 240, 8, 500, 48000),
(1012, 200, 8, 512, 30000);

-- PRINTER
INSERT INTO PRINTER VALUES

(1004, 'T', 'laser', 25000),
(1008, 'F', 'dot-matrix', 15000),
(1010, 'T', 'ink-jet', 20000);

--3. Queries
--a) PC models with speed >= 150 MHz
SELECT * FROM PC
WHERE Speed >= 150;

--b) Manufacturers that make Laptops but not PCs
SELECT DISTINCT p.Maker
FROM PRODUCT p
WHERE p.Type = 'Laptop'
AND p.Maker NOT IN (
SELECT DISTINCT Maker
FROM PRODUCT
WHERE Type = 'PC'
);

CREATE PROCEDURE usp_MostExpensiveLaptopMaker
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @model VARCHAR(10),
          @maker VARCHAR(50);

  SELECT TOP 1
    @model = l.Modelno
  FROM Laptop l
  ORDER BY l.Price DESC;

  SELECT @maker = Maker
  FROM Product
  WHERE Modelno = @model;

  SELECT @maker AS Maker, @model AS Modelno;
END;
GO
