-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jul 07, 2024 at 05:05 PM
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
DROP PROCEDURE IF EXISTS `AddBooking`$$
CREATE DEFINER=`meta`@`%` PROCEDURE `AddBooking` (IN `table_number` INT, IN `booking_date` DATE, IN `customer_id` INT)   BEGIN
    INSERT INTO bookings (table_number, booking_date, customer_id)
    VALUES (table_number, booking_date, customer_id);
    
    SELECT 'Booking added successfully' AS Message;
END$$

DROP PROCEDURE IF EXISTS `AddValidBooking`$$
CREATE DEFINER=`meta`@`%` PROCEDURE `AddValidBooking` (IN `booking_date` DATE, IN `table_number` INT, IN `customer_id` INT)   BEGIN
    DECLARE table_status VARCHAR(50);

    -- Start a transaction
    START TRANSACTION;

    -- Check if the table is already booked on the given date
    SELECT 
        CASE 
            WHEN EXISTS (
                SELECT * 
                FROM bookings 
                WHERE booking_date = booking_date 
                AND table_number = table_number
            )
            THEN 'Booked'
            ELSE 'Available'
        END INTO table_status;

    -- If the table is already booked, rollback the transaction
    IF table_status = 'Booked' THEN
        ROLLBACK;
        SELECT 'Table is already booked' AS Message;
    ELSE
        -- Otherwise, insert the new booking record
        INSERT INTO bookings (booking_date, table_number, customer_id)
        VALUES (booking_date, table_number, customer_id);

        -- Commit the transaction
        COMMIT;
        SELECT 'Booking added successfully' AS Message;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `CancelBooking`$$
CREATE DEFINER=`meta`@`%` PROCEDURE `CancelBooking` (IN `booking_id` INT)   BEGIN
    DECLARE booking_exists INT;
    
    -- Check if the booking_id exists
    SELECT COUNT(*) INTO booking_exists
    FROM bookings
    WHERE booking_id = booking_id;
    
    -- If booking exists, delete it
    IF booking_exists > 0 THEN
        DELETE FROM bookings
        WHERE booking_id = booking_id;
        
        SELECT CONCAT('Booking with ID ', booking_id, ' has been successfully cancelled.') AS Message;
    ELSE
        SELECT 'Booking ID does not exist.' AS Message;
    END IF;
    
END$$

DROP PROCEDURE IF EXISTS `CheckBooking`$$
CREATE DEFINER=`meta`@`%` PROCEDURE `CheckBooking` (IN `booking_date` DATE, IN `table_number` INT)   BEGIN
    DECLARE table_status VARCHAR(50);

    -- Check if the table is booked on the given date
    SELECT 
        CASE 
            WHEN EXISTS (
                SELECT * 
                FROM bookings 
                WHERE booking_date = booking_date 
                AND table_number = table_number
            )
            THEN 'Booked'
            ELSE 'Available'
        END INTO table_status;

    -- Return the status of the table
    SELECT table_status AS TableStatus;
END$$

DROP PROCEDURE IF EXISTS `GetMaxQuantity`$$
CREATE DEFINER=`meta`@`%` PROCEDURE `GetMaxQuantity` ()   BEGIN
    SELECT MAX(quantity) AS MaxQuantity
    FROM orders;
END$$

DROP PROCEDURE IF EXISTS `UpdateBooking`$$
CREATE DEFINER=`meta`@`%` PROCEDURE `UpdateBooking` (IN `booking_id` INT, IN `new_booking_date` DATE)   BEGIN
    UPDATE bookings
    SET booking_date = new_booking_date
    WHERE booking_id = booking_id;
    
    SELECT 'Booking updated successfully' AS Message;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
CREATE TABLE IF NOT EXISTS `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `table_number` int DEFAULT NULL,
  `booking_date` date DEFAULT NULL,
  `customer_id` int DEFAULT NULL,
  PRIMARY KEY (`booking_id`),
  UNIQUE KEY `booking_id_UNIQUE` (`booking_id`),
  KEY `booking_id_fk_idx` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
CREATE TABLE IF NOT EXISTS `customers` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) DEFAULT NULL,
  `contact_number` int DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `customer_id_UNIQUE` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `full_name`, `contact_number`, `email`) VALUES
(1, 'Petar Petrovic', 12345678, 'email1@example.com'),
(2, 'Jovan Jovanovic', 23456789, 'email2@example.com'),
(3, 'Ivan Ivanovic', 34567890, 'email3@example.com');

-- --------------------------------------------------------

--
-- Table structure for table `menus`
--

DROP TABLE IF EXISTS `menus`;
CREATE TABLE IF NOT EXISTS `menus` (
  `menu_id` int NOT NULL AUTO_INCREMENT,
  `menu_items_id` int DEFAULT NULL,
  `menu_name` varchar(255) DEFAULT NULL,
  `cuisine` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`menu_id`),
  UNIQUE KEY `menu_id_UNIQUE` (`menu_id`),
  KEY `menu_items_id_fk_idx` (`menu_items_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `menus`
--

INSERT INTO `menus` (`menu_id`, `menu_items_id`, `menu_name`, `cuisine`) VALUES
(1, 1, 'Moussaka', 'cuisine 1'),
(2, 2, 'Manti', 'cuisine 2');

-- --------------------------------------------------------

--
-- Table structure for table `menu_items`
--

DROP TABLE IF EXISTS `menu_items`;
CREATE TABLE IF NOT EXISTS `menu_items` (
  `menu_items_id` int NOT NULL AUTO_INCREMENT,
  `course_name` varchar(255) DEFAULT NULL,
  `starter_name` varchar(255) DEFAULT NULL,
  `desert_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`menu_items_id`),
  UNIQUE KEY `menu_items_id_UNIQUE` (`menu_items_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COMMENT='	';

--
-- Dumping data for table `menu_items`
--

INSERT INTO `menu_items` (`menu_items_id`, `course_name`, `starter_name`, `desert_name`) VALUES
(1, 'Greek salad', 'Starter 1', 'Desert 1'),
(2, 'Kabasa', 'Starter 2', 'Desert 2');

-- --------------------------------------------------------

--
-- Stand-in structure for view `ordercost`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `ordercost`;
CREATE TABLE IF NOT EXISTS `ordercost` (
`customer_id` int
,`full_name` varchar(255)
,`order_id` int
,`cost` int
,`menu_name` varchar(255)
,`course_name` varchar(255)
,`starter_name` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `orderquantity`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `orderquantity`;
CREATE TABLE IF NOT EXISTS `orderquantity` (
`menu_name` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `orders_id` int NOT NULL AUTO_INCREMENT,
  `menu_id` int DEFAULT NULL,
  `customer_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `total_cost` int DEFAULT NULL,
  PRIMARY KEY (`orders_id`),
  UNIQUE KEY `orders_id_UNIQUE` (`orders_id`),
  KEY `menu_id_fk_idx` (`menu_id`),
  KEY `customer_id_fk_idx` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`orders_id`, `menu_id`, `customer_id`, `quantity`, `total_cost`) VALUES
(1, 1, 1, 3, 200),
(2, 1, 2, 5, 250),
(3, 2, 3, 1, 150),
(4, 1, 1, 2, 140),
(5, 2, 2, 6, 300),
(6, 2, 3, 1, 50);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ordersview`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `ordersview`;
CREATE TABLE IF NOT EXISTS `ordersview` (
`OrderID` int
,`Quantity` int
,`Cost` int
);

-- --------------------------------------------------------

--
-- Structure for view `ordercost`
--
DROP TABLE IF EXISTS `ordercost`;

DROP VIEW IF EXISTS `ordercost`;
CREATE ALGORITHM=UNDEFINED DEFINER=`meta`@`%` SQL SECURITY DEFINER VIEW `ordercost`  AS SELECT `c`.`customer_id` AS `customer_id`, `c`.`full_name` AS `full_name`, `o`.`orders_id` AS `order_id`, `o`.`total_cost` AS `cost`, `m`.`menu_name` AS `menu_name`, `mi`.`course_name` AS `course_name`, `mi`.`starter_name` AS `starter_name` FROM (((`orders` `o` join `customers` `c` on((`o`.`customer_id` = `c`.`customer_id`))) join `menus` `m` on((`o`.`menu_id` = `m`.`menu_id`))) join `menu_items` `mi` on((`m`.`menu_items_id` = `mi`.`menu_items_id`))) WHERE (`o`.`total_cost` > 150) ORDER BY `o`.`total_cost` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `orderquantity`
--
DROP TABLE IF EXISTS `orderquantity`;

DROP VIEW IF EXISTS `orderquantity`;
CREATE ALGORITHM=UNDEFINED DEFINER=`meta`@`%` SQL SECURITY DEFINER VIEW `orderquantity`  AS SELECT `menus`.`menu_name` AS `menu_name` FROM `menus` WHERE `menus`.`menu_id` in (select `orders`.`menu_id` from `orders` group by `orders`.`menu_id` having (count(0) > 2)) ;

-- --------------------------------------------------------

--
-- Structure for view `ordersview`
--
DROP TABLE IF EXISTS `ordersview`;

DROP VIEW IF EXISTS `ordersview`;
CREATE ALGORITHM=UNDEFINED DEFINER=`meta`@`%` SQL SECURITY DEFINER VIEW `ordersview`  AS SELECT `orders`.`orders_id` AS `OrderID`, `orders`.`quantity` AS `Quantity`, `orders`.`total_cost` AS `Cost` FROM `orders` WHERE (`orders`.`quantity` > 2) ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `booking_id_fk` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `menus`
--
ALTER TABLE `menus`
  ADD CONSTRAINT `menu_items_id_fk` FOREIGN KEY (`menu_items_id`) REFERENCES `menu_items` (`menu_items_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `customer_id_fk` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `menu_id_fk` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`menu_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
