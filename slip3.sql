CREATE TABLE Product10(
  Maker   VARCHAR(50)    NOT NULL,
  Modelno VARCHAR(10)    PRIMARY KEY,
  Type    VARCHAR(10)    NOT NULL CHECK (Type IN ('PC','Laptop','Printer'))
);
drop table Product10
CREATE TABLE PC1(
  Modelno VARCHAR(10) PRIMARY KEY REFERENCES Product(Modelno),
  Speed   INT         NOT NULL,
  RAM     INT         NOT NULL,
  HD      INT         NOT NULL,
  CD      VARCHAR(50) NOT NULL,
  Price   DECIMAL(10,2) NOT NULL
);

CREATE TABLE Laptop1(
  Modelno VARCHAR(10) PRIMARY KEY REFERENCES Product(Modelno),
  Speed   INT         NOT NULL,
  RAM     INT         NOT NULL,
  HD      INT         NOT NULL,
  Price   DECIMAL(10,2) NOT NULL
);
drop table Printer
CREATE TABLE Printer (
  Modelno VARCHAR(10) PRIMARY KEY REFERENCES Product(Modelno),
  Color   CHAR(1)     NOT NULL CHECK (Color IN ('T','F')),
  Type    VARCHAR(20) NOT NULL CHECK (Type IN ('laser','ink-jet','dot-matrix','dry')),
  Price   DECIMAL(10,2) NOT NULL
);

INSERT INTO Product10 VALUES
('IBM', 1001, 'PC'),
('Compaq', 1002, 'PC'),
('Dell', 1003, 'PC'),
('HP', 1004, 'Laptop'),
('Compaq', 1005, 'Laptop'),
('IBM', 1006, 'Laptop'),
('Epson', 1007, 'Printer'),
('Epson', 1008, 'Printer'),
('HP', 1009, 'Printer'),
('Dell', 1010, 'Printer');

select * from Printer;

-- PC
INSERT INTO PC1 VALUES
(1001, 2400, 512, 80, '52x', 500.00),
(1002, 3000, 1024, 160, '48x', 600.00),
(1003, 2200, 2048, 250, '52x', 700.00);

-- LAPTOP
INSERT INTO Laptop1 VALUES
(1004, 2500, 4096, 500, 1000.00),
(1005, 3200, 8192, 1000, 1500.00),
(1006, 2400, 2048, 256, 900.00);

-- Printer rows
INSERT INTO PRINTER VALUES
(1007, 'T', 'ink-jet', 120.00),
(1008, 'F', 'dot-matrix', 80.00),
(1009, 'T', 'laser', 200.00);

SELECT DISTINCT pr.Type
FROM Product10 AS p
JOIN Printer   AS pr
  ON p.Modelno = pr.Modelno
WHERE p.Maker = 'Epson';

SELECT HD
FROM PC
GROUP BY HD
HAVING COUNT(*) >= 2;



