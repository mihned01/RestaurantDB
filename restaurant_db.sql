DROP DATABASE IF EXISTS RestaurantDB;
CREATE DATABASE RestaurantDB;
USE RestaurantDB;


CREATE TABLE PostalCode (
    postalCode varchar(10) NOT NULL PRIMARY KEY,
    city varchar(50) NOT NULL
);

CREATE TABLE Restaurant (
    restaurantID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    postalCode varchar(10) NOT NULL,
    name varchar(100) NOT NULL,
    street varchar(100) NOT NULL,
    openingTime time NOT NULL,
    closingTime time NOT NULL,
    phone varchar(20) NOT NULL,
    email varchar(100) NOT NULL,
    FOREIGN KEY (postalCode) REFERENCES PostalCode(postalCode),
    CHECK (openingTime < closingTime)
);

CREATE TABLE RestaurantTable (
    tableID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    restaurantID int NOT NULL,
    tableNumber int NOT NULL,
    capacity int NOT NULL,
    UNIQUE (restaurantID, tableNumber),
    CHECK (capacity > 0),
    FOREIGN KEY (restaurantID) REFERENCES Restaurant(restaurantID)
);

CREATE TABLE Customer (
    customerID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstName varchar(50) NOT NULL,
    lastName varchar(50) NOT NULL,
    phone varchar(20) NOT NULL,
    email varchar(100) NOT NULL
);

CREATE TABLE Booking (
    bookingID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customerID int NOT NULL,
    bookingDate date NOT NULL,
    bookingTime time NOT NULL,
    numberOfGuests int NOT NULL,
    CHECK (numberOfGuests > 0),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID)
);

CREATE TABLE Reserves (
    tableID int NOT NULL,
    bookingID int NOT NULL,
    CONSTRAINT PK_Reserves PRIMARY KEY (tableID, bookingID),
    FOREIGN KEY (tableID) REFERENCES RestaurantTable(tableID),
    FOREIGN KEY (bookingID) REFERENCES Booking(bookingID)
);

-- Test data: two restaurants with their tables, eight customers and ten bookings

INSERT INTO PostalCode (postalCode, city) VALUES
('6700', 'Esbjerg'),
('6000', 'Kolding');

INSERT INTO Restaurant (restaurantID, postalCode, name, street, openingTime, closingTime, phone, email) VALUES
(1, '6700', 'Bistro Havnen', 'Skolegade 14', '11:00', '22:00', '+45 75 12 40 10', 'info@bistrohavnen.dk'),
(2, '6000', 'Smag Kolding', 'Jernbanegade 7', '12:00', '23:00', '+45 75 50 22 33', 'kontakt@smagkolding.dk');

INSERT INTO RestaurantTable (tableID, restaurantID, tableNumber, capacity) VALUES
(1, 1, 1, 2),
(2, 1, 2, 2),
(3, 1, 3, 4),
(4, 1, 4, 4),
(5, 1, 5, 6),
(6, 1, 6, 8),
(7, 2, 1, 2),
(8, 2, 2, 4),
(9, 2, 3, 4),
(10, 2, 4, 6);

INSERT INTO Customer (customerID, firstName, lastName, phone, email) VALUES
(1, 'Anders', 'Kristensen', '+45 26 41 83 90', 'anders.kristensen@gmail.com'),
(2, 'Camilla', 'Poulsen', '+45 30 52 17 64', 'camilla.poulsen@outlook.com'),
(3, 'Jonas', 'Møller', '+45 41 29 75 08', 'jonas.moeller@mail.dk'),
(4, 'Astrid', 'Thomsen', '+45 53 68 24 19', 'astrid.thomsen@gmail.com'),
(5, 'Magnus', 'Rasmussen', '+45 22 96 31 57', 'magnus.rasmussen@hotmail.com'),
(6, 'Nanna', 'Holm', '+45 61 07 45 82', 'nanna.holm@gmail.com'),
(7, 'Villads', 'Knudsen', '+45 28 53 90 14', 'villads.knudsen@mail.dk'),
(8, 'Laura', 'Mortensen', '+45 50 38 62 71', 'laura.mortensen@gmail.com');

INSERT INTO Booking (bookingID, customerID, bookingDate, bookingTime, numberOfGuests) VALUES
(1, 1, '2026-10-16', '18:00', 2),
(2, 2, '2026-10-16', '19:30', 4),
(3, 3, '2026-10-16', '18:00', 3),
(4, 4, '2026-10-17', '18:30', 8),
(5, 5, '2026-10-17', '12:30', 2),
(6, 1, '2026-10-23', '19:00', 10),
(7, 6, '2026-10-17', '19:00', 4),
(8, 7, '2026-10-18', '13:00', 6),
(9, 2, '2026-10-24', '20:00', 2),
(10, 8, '2026-10-16', '20:30', 2);

INSERT INTO Reserves (tableID, bookingID) VALUES
(1, 1),
(3, 2),
(4, 3),
(6, 4),
(2, 5),
(5, 6),
(4, 6),
(8, 7),
(10, 8),
(1, 9),
(1, 10);

-- 1st Query: List all tables in restaurant 1

SELECT tableID, tableNumber, capacity
FROM RestaurantTable
WHERE restaurantID = 1
ORDER BY tableNumber;

-- 2nd Query: List all bookings for customer 1, ordered by arrival date and time

SELECT *
FROM Booking
WHERE customerID = 1
ORDER BY bookingDate, bookingTime;

-- 3rd Query: List all bookings for table 1 on 2026-10-16, including customer details

SELECT b.bookingID, b.bookingDate, b.bookingTime, b.numberOfGuests,
       c.firstName, c.lastName, c.phone
FROM Reserves r
JOIN Booking b ON r.bookingID = b.bookingID
JOIN Customer c ON b.customerID = c.customerID
WHERE r.tableID = 1
AND b.bookingDate = '2026-10-16';