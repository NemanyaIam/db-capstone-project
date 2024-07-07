-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jul 07, 2024 at 10:30 AM
-- Server version: 8.3.0
-- PHP Version: 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `little_lemon_db`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `BasicSalesReport`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `BasicSalesReport` ()   BEGIN
                DECLARE total_sales DECIMAL(10, 2);
                DECLARE avg_sale DECIMAL(10, 2);
                DECLARE min_bill DECIMAL(10, 2);
                DECLARE max_bill DECIMAL(10, 2);

                -- Calculate total sales
                SELECT SUM(BillAmount) INTO total_sales
                FROM Orders;

                -- Calculate average sale
                SELECT AVG(BillAmount) INTO avg_sale
                FROM Orders;

                -- Calculate minimum bill paid
                SELECT MIN(BillAmount) INTO min_bill
                FROM Orders;

                -- Calculate maximum bill paid
                SELECT MAX(BillAmount) INTO max_bill
                FROM Orders;

                -- Return the results
                SELECT total_sales AS TotalSales,
                       avg_sale AS AverageSale,
                       min_bill AS MinimumBillPaid,
                       max_bill AS MaximumBillPaid;
            END$$

DROP PROCEDURE IF EXISTS `GuestStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GuestStatus` ()   BEGIN
        SELECT 
            CONCAT(GuestFirstName, ' ', GuestLastName) AS GuestName,
            CASE 
                WHEN Employees.Role = 'Manager' OR Employees.Role = 'Assistant Manager' THEN 'Ready to pay'
                WHEN Employees.Role = 'Head Chef' THEN 'Ready to serve'
                WHEN Employees.Role = 'Assistant Chef' THEN 'Preparing Order'
                WHEN Employees.Role = 'Head Waiter' THEN 'Order served'
                ELSE 'Unknown'
            END AS OrderStatus
        FROM Bookings
        LEFT JOIN Employees ON Bookings.EmployeeID = Employees.EmployeeID;
    END$$

DROP PROCEDURE IF EXISTS `PeakHours`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PeakHours` ()   BEGIN
    SELECT HOUR(BookingSlot) AS BookingHour, COUNT(*) AS NumberOfBookings
    FROM Bookings
    GROUP BY BookingHour
    ORDER BY NumberOfBookings DESC;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
CREATE TABLE IF NOT EXISTS `bookings` (
  `BookingID` int NOT NULL AUTO_INCREMENT,
  `TableNo` int DEFAULT NULL,
  `GuestFirstName` varchar(100) NOT NULL,
  `GuestLastName` varchar(100) NOT NULL,
  `BookingSlot` time NOT NULL,
  `EmployeeID` int DEFAULT NULL,
  PRIMARY KEY (`BookingID`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`BookingID`, `TableNo`, `GuestFirstName`, `GuestLastName`, `BookingSlot`, `EmployeeID`) VALUES
(1, 12, 'Anna', 'Iversen', '19:00:00', 1),
(2, 12, 'Joakim', 'Iversen', '19:00:00', 1),
(3, 19, 'Vanessa', 'McCarthy', '15:00:00', 3),
(4, 15, 'Marcos', 'Romero', '17:30:00', 4),
(5, 5, 'Hiroki', 'Yamane', '18:30:00', 2),
(6, 8, 'Diana', 'Pinto', '20:00:00', 5),
(7, 8, 'Anees', 'Java', '18:00:00', 6),
(8, 5, 'Bald', 'Vin', '19:00:00', 6),
(9, 8, 'Anees', 'Java', '18:00:00', 6),
(10, 5, 'Bald', 'Vin', '19:00:00', 6);

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
CREATE TABLE IF NOT EXISTS `employees` (
  `EmployeeID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `Role` varchar(100) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `Contact_Number` int DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Annual_Salary` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`EmployeeID`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`EmployeeID`, `Name`, `Role`, `Address`, `Contact_Number`, `Email`, `Annual_Salary`) VALUES
(1, 'Mario Gollini', 'Manager', '724, Parsley Lane, Old Town, Chicago, IL', 351258074, 'Mario.g@littlelemon.com', '$70,000'),
(2, 'Adrian Gollini', 'Assistant Manager', '334, Dill Square, Lincoln Park, Chicago, IL', 351474048, 'Adrian.g@littlelemon.com', '$65,000'),
(3, 'Giorgos Dioudis', 'Head Chef', '879 Sage Street, West Loop, Chicago, IL', 351970582, 'Giorgos.d@littlelemon.com', '$50,000'),
(4, 'Fatma Kaya', 'Assistant Chef', '132  Bay Lane, Chicago, IL', 351963569, 'Fatma.k@littlelemon.com', '$45,000'),
(5, 'Elena Salvai', 'Head Waiter', '989 Thyme Square, EdgeWater, Chicago, IL', 351074198, 'Elena.s@littlelemon.com', '$40,000'),
(6, 'John Millar', 'Receptionist', '245 Dill Square, Lincoln Park, Chicago, IL', 351584508, 'John.m@littlelemon.com', '$35,000');

-- --------------------------------------------------------

--
-- Table structure for table `menuitems`
--

DROP TABLE IF EXISTS `menuitems`;
CREATE TABLE IF NOT EXISTS `menuitems` (
  `ItemID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) DEFAULT NULL,
  `Type` varchar(100) DEFAULT NULL,
  `Price` int DEFAULT NULL,
  PRIMARY KEY (`ItemID`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `menuitems`
--

INSERT INTO `menuitems` (`ItemID`, `Name`, `Type`, `Price`) VALUES
(1, 'Olives', 'Starters', 5),
(2, 'Flatbread', 'Starters', 5),
(3, 'Minestrone', 'Starters', 8),
(4, 'Tomato bread', 'Starters', 8),
(5, 'Falafel', 'Starters', 7),
(6, 'Hummus', 'Starters', 5),
(7, 'Greek salad', 'Main Courses', 15),
(8, 'Bean soup', 'Main Courses', 12),
(9, 'Pizza', 'Main Courses', 15),
(10, 'Greek yoghurt', 'Desserts', 7),
(11, 'Ice cream', 'Desserts', 6),
(12, 'Cheesecake', 'Desserts', 4),
(13, 'Athens White wine', 'Drinks', 25),
(14, 'Corfu Red Wine', 'Drinks', 30),
(15, 'Turkish Coffee', 'Drinks', 10),
(16, 'Turkish Coffee', 'Drinks', 10),
(17, 'Kabasa', 'Main Courses', 17);

-- --------------------------------------------------------

--
-- Table structure for table `menus`
--

DROP TABLE IF EXISTS `menus`;
CREATE TABLE IF NOT EXISTS `menus` (
  `MenuID` int NOT NULL,
  `ItemID` int NOT NULL,
  `Cuisine` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`MenuID`,`ItemID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `menus`
--

INSERT INTO `menus` (`MenuID`, `ItemID`, `Cuisine`) VALUES
(1, 1, 'Greek'),
(1, 7, 'Greek'),
(1, 10, 'Greek'),
(1, 13, 'Greek'),
(2, 3, 'Italian'),
(2, 9, 'Italian'),
(2, 12, 'Italian'),
(2, 15, 'Italian'),
(3, 5, 'Turkish'),
(3, 17, 'Turkish'),
(3, 11, 'Turkish'),
(3, 16, 'Turkish');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `OrderID` int NOT NULL,
  `TableNo` int NOT NULL,
  `MenuID` int DEFAULT NULL,
  `BookingID` int DEFAULT NULL,
  `BillAmount` int DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  PRIMARY KEY (`OrderID`,`TableNo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`OrderID`, `TableNo`, `MenuID`, `BookingID`, `BillAmount`, `Quantity`) VALUES
(1, 12, 1, 1, 86, 2),
(2, 19, 2, 2, 37, 1),
(3, 15, 2, 3, 37, 1),
(4, 5, 3, 4, 40, 1),
(5, 8, 1, 5, 43, 1);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
