
--Project 1 :Airlines Management system

-- Airlines table
CREATE TABLE Airlines (
    AirlineID INT PRIMARY KEY,
    AirlineName VARCHAR(255) NOT NULL,
    Headquarters VARCHAR(255),
    ContactNumber VARCHAR(20)
);

-- Aircrafts table
CREATE TABLE Aircrafts (
    AircraftID INT PRIMARY KEY,
    AircraftType VARCHAR(255) NOT NULL,
    RegistrationNumber VARCHAR(20) NOT NULL,
    Capacity INT NOT NULL,
    CurrentStatus VARCHAR(20) DEFAULT 'Active',
    AirlineID INT,
    FOREIGN KEY (AirlineID) REFERENCES Airlines(AirlineID)
);

--  Flights table
CREATE TABLE Flights (
    FlightID INT PRIMARY KEY,
    FlightNumber VARCHAR(10) NOT NULL,
    DepartureAirport VARCHAR(255) NOT NULL,
    ArrivalAirport VARCHAR(255) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    AirlineID INT,
    AircraftID INT,
    FOREIGN KEY (AirlineID) REFERENCES Airlines(AirlineID),
    FOREIGN KEY (AircraftID) REFERENCES Aircrafts(AircraftID)
);

-- Create Passengers table
CREATE TABLE Passengers (
    PassengerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(255),
    Phone VARCHAR(20),
    UNIQUE (Email, Phone)
);

-- Create Reservations table
CREATE TABLE Reservations (
    ReservationID INT,
    PassengerID INT,
    FlightID INT,
    SeatNumber VARCHAR(10),
    ReservationTime DATETIME NOT NULL,
    PRIMARY KEY (PassengerID, FlightID),
    FOREIGN KEY (PassengerID) REFERENCES Passengers(PassengerID),
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID)
);

-- Insert data for Airlines
INSERT INTO Airlines (AirlineID, AirlineName, Headquarters, ContactNumber) VALUES
(1, 'Indigo Airlines', 'New Delhi', '011-23456789'),
(2, 'SpiceJet', 'Gurugram', '0124-6543210');

-- Insert data for Aircrafts
INSERT INTO Aircrafts (AircraftID, AircraftType, RegistrationNumber, Capacity, CurrentStatus, AirlineID) VALUES
(1, 'Airbus A320', 'VT-IND123', 180, 'Active', 1),
(2, 'Boeing 737', 'VT-SPJ789', 160, 'Active', 2);

-- Insert sample data for Flights
INSERT INTO Flights (FlightID, FlightNumber, DepartureAirport, ArrivalAirport, DepartureTime, ArrivalTime, AirlineID, AircraftID) VALUES
(1, '6E101', 'DEL', 'BOM', '2023-01-01 06:00:00', '2023-01-01 08:00:00', 1, 1),
(2, 'SG202', 'BLR', 'HYD', '2023-01-02 09:00:00', '2023-01-02 10:15:00', 2, 2);

-- Insert data for Passengers
INSERT INTO Passengers (PassengerID, FirstName, LastName, Email, Phone) VALUES
(1, 'Rahul', 'Sharma', 'rahul.sharma@email.com', '9876543210'),
(2, 'Priya', 'Mehta', 'priya.mehta@email.com', '9123456780');

-- Insert data for Reservations
INSERT INTO Reservations (ReservationID, PassengerID, FlightID, SeatNumber, ReservationTime) VALUES
(1, 1, 1, '12A', '2022-12-31 20:30:00'),
(2, 2, 2, '18C', '2023-01-01 14:45:00');
--Problem Statements: 
--1)Retrieve information about all airlines:
 SELECT * FROM Airlines;

--2)Retrieve information about all aircraft:
SELECT * FROM Aircrafts;

--3)Retrieve a list of passengers for a specific flight: 
SELECT P.*
FROM Passengers P
JOIN Reservations R ON P.PassengerID = R.PassengerID
WHERE R.FlightID = 1;
--(you can change fliteid as per you wish)

--4)Retrieve a list of flights for a specific airline:
SELECT * FROM Flights
WHERE AirlineID = 1;
 
--5)Retrieve available seats for a specific flight: 
SELECT A.Capacity - COUNT(R.SeatNumber) AS AvailableSeats
FROM Flights F
JOIN Aircrafts A ON F.AircraftID = A.AircraftID
LEFT JOIN Reservations R ON F.FlightID = R.FlightID
WHERE F.FlightID = 1
GROUP BY A.Capacity;


--6)Retrieve the total number of reservations for a specific flight: 
SELECT COUNT(*) AS TotalReservations
FROM Reservations
WHERE FlightID = 1;

--7)Retrieve a list of passengers with their flight details for a specific airline: 
SELECT P.FirstName, P.LastName, P.Email, F.FlightNumber, F.DepartureAirport, F.ArrivalAirport, F.DepartureTime
FROM Passengers P
JOIN Reservations R ON P.PassengerID = R.PassengerID
JOIN Flights F ON R.FlightID = F.FlightID
WHERE F.AirlineID = 1;
