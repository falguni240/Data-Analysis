create database E_Commerce;
use E_Commerce;

create table Customer(
  CustomerID int primary key,
  Name varchar(100) not null,
  Address Text,
  ContactDetails varchar(100),
  Email varchar(100) unique,
  PasswordHash varchar(255) not null
);

insert into Customer values
(1,'Mahesh Pawar','11 Shivaji Nagar, Pune','9406000001','maheshp@example.com','hash_m123'),
(2,'Sneha Kulkarni','22 MG Road, Nashik','9406000002','sneha.k@example.com','hash_s456'),
(3,'Rohan Deshmukh','55 FC Road, Mumbai','9406000003','rohan.d@example.com','hash_r789'),
(4,'Aarti Shinde','76 JM Street, Aurangabad','9406000004','aarti.s@example.com','hash_a321'),
(5,'Nikhil Jadhav','31 Tilak Path, Nagpur','9406000005','nikhil.j@example.com','hash_n654');

create table Categories(
  CategoryID int primary key,
  CategoryName varchar(30) not null
);

insert into Categories values 
(1,'Electronics'),
(2,'Books'),
(3,'Clothing'),
(4,'Toys'),
(5,'Furniture');

create table Products (
  ProductID int primary key,
  Name varchar(100) not null,
  Description Text,
  Price Decimal(10,2) not null,
  stockQuantity int Not null,
  CategoryID int foreign key references Categories(CategoryID)
);

insert into Products values
(1,'Gaming Laptop','15.6-inch, 16GB RAM, 1TB SSD',75999.00,25,1),
(2,'Smartphone X','6.5-inch OLED, 256GB',48999.00,80,1),
(3,'Wireless Headset','Bluetooth 5.0, 20hr Battery',5999.00,40,1),
(4,'Mechanical Keyboard','RGB, Blue Switches',3499.00,30,1),
(5,'Quantum Physics','Advanced concepts of quantum theory',799.00,60,2),
(6,'Cotton Kurta','Ethnic wear, Men, Size L',1199.00,20,3),
(7,'Denim Jacket','Trendy Blue Jacket for Women',1999.00,35,3),
(8,'Puzzle Set','1000-piece logic puzzle',449.00,15,4),
(9,'Wooden Table','Sheesham wood study table',5999.00,10,5);

-- Assuming this drop was by mistake; skipping drop
-- drop table Products

-- Skipping rename as 'Product' was never created
-- exec sp_rename 'Product' ,'Products'

-- Additional insert
insert into Products values(10,'HD Monitor','24-inch LED Full HD Monitor',8599.00,18,1);

select * from Products;

create table Orders(
  OrderID int primary key,
  OrderDate Date not null,
  TotalAmount Decimal(10,2) not null,
  Status varchar(50) not null
);

insert into Orders values
(1,'2025-06-01',15899.00,'Shipped'),
(2,'2025-06-03',4999.00,'Delivered'),
(3,'2025-06-05',3499.00,'Pending'),
(4,'2025-06-07',1899.00,'Cancelled'),
(5,'2025-06-09',5599.00,'Processing');

create table OrderItems(
  ItemId int primary key,
  OrderID int,
  ProductID int,
  Quantity int,
  Subtotal Decimal(10,2),
  foreign key (OrderID) references Orders(OrderID),
  foreign key (ProductID) references Products(ProductID)
);

insert into OrderItems values
(1,1,1,1,75999.00),
(2,4,3,2,11998.00),
(3,3,2,1,48999.00),
(4,5,1,2,151998.00),
(5,2,1,1,75999.00);

select * from OrderItems;

-- Number of order per month
select 
  Year(OrderDate) as orderYear,
  Month(OrderDate) as ordermonth,
  count(*) as NumberofOrders
from Orders 
group by year(OrderDate), month(OrderDate);

-- Calculate total revenue for a specific period 
select 
  sum(OrderItems.Quantity * OrderItems.Subtotal) as totalrevue
from Orders
join OrderItems on Orders.OrderID = OrderItems.OrderID
where Orders.OrderDate >= '2023-01-01' and Orders.OrderDate < '2023-02-01';

-- Retrieve products in a specific category
select Name from Products where CategoryID = 1;

-- Retrieve product details by name
select ProductID, Name, Price, Description from Products
where Name = 'Gaming Laptop';

-- Retrieve all orders for a customer
-- Note: Orders table has no CustomerID; if needed, you should add that column.
select * from Orders where OrderID = 1;

select * from Customer;
select * from Orders;
select * from Products;
