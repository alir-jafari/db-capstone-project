-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 23, 2023 at 07:52 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.0.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `littlelemondb`
--
CREATE DATABASE IF NOT EXISTS `littlelemondb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `littlelemondb`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `AddBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddBooking` (IN `BookingDate` DATE, IN `TableNumber` INT, IN `CustomerIDInput` INT, OUT `TableStatus` VARCHAR(255))   BEGIN
	DECLARE BookingCount INT;
    INSERT into bookings(TableNo,BookingSlot,EmployeeID,CustomerID) VALUES(TableNumber,BookingDate,6,CustomerIDInput);
    SELECT concat('New booking was addedd successfully') INTO TableStatus;    
END$$

DROP PROCEDURE IF EXISTS `AddValidBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddValidBooking` (IN `BookingDate` DATE, IN `TableNumber` INT, IN `CustomerIDInput` INT, OUT `TableStatus` VARCHAR(255))   BEGIN
	DECLARE BookingCount INT;
    
    
    SELECT count(BookingID) INTO BookingCount 
    FROM bookings
    WHERE Date(BookingSlot) = BookingDate and TableNo = TableNumber;
    
	START TRANSACTION;
    INSERT into bookings(TableNo,BookingSlot,EmployeeID,CustomerID) VALUES(TableNumber,BookingDate,6,CustomerIDInput);

    IF (BookingCount > 0) THEN 
     	SELECT concat('Table',' ',TableNumber,' is already Booked - booking canceled') INTO TableStatus; 
        ROLLBACK;
    ELSE 
    	SELECT  concat('Table',' ',TableNumber,' is booked by customer id of ',CustomerIDInput) INTO TableStatus; 
        COMMIT;
    END IF;
   
END$$

DROP PROCEDURE IF EXISTS `CancelBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelBooking` (IN `BookIDInput` INT, OUT `TableStatus` VARCHAR(255))   BEGIN
	DECLARE BookingCount INT;
    DELETE FROM bookings
    where BookingID = BookIDInput;
    
    SELECT concat('Booking ',BookIDInput,' was deleted successfully') INTO TableStatus;    
END$$

DROP PROCEDURE IF EXISTS `CancelOrder`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelOrder` (IN `OrderIDInput` INT, OUT `Description` VARCHAR(255))   BEGIN
	DELETE  
 	FROM orders
	WHERE OrderID = OrderIDInput;
    select concat('Order',' ',OrderIDInput,' is Canceled.')
    INTO Description;
END$$

DROP PROCEDURE IF EXISTS `CheckBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckBooking` (IN `BookingDate` DATE, IN `TableNumber` INT, OUT `TableStatus` VARCHAR(255))   BEGIN
	DECLARE BookingCount INT;
    SELECT count(BookingID) INTO BookingCount 
    FROM bookings
    WHERE Date(BookingSlot) = BookingDate and TableNo = TableNumber;
    
    IF (BookingCount > 0) THEN 
     	SELECT concat('Table',' ',TableNumber,' is already Booked.') INTO TableStatus; 
    ELSE 
    	SELECT  concat('Table',' ',TableNumber,' is free now.') INTO TableStatus; 
    END IF;
   
END$$

DROP PROCEDURE IF EXISTS `GetMaxQuantity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMaxQuantity` ()   BEGIN
	SELECT MAX(Quantity) as 'Max Quantiy in Orders'  FROM orders;
END$$

DROP PROCEDURE IF EXISTS `UpdateBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBooking` (IN `BookingDate` DATE, IN `BookIDInput` INT, OUT `TableStatus` VARCHAR(255))   BEGIN
	DECLARE BookingCount INT;
    UPDATE bookings
    set  BookingSlot = BookingDate
    where BookingID = BookIDInput;
    
    SELECT concat('Booking ',BookIDInput,' was updated successfully') INTO TableStatus;    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
CREATE TABLE IF NOT EXISTS `bookings` (
  `BookingID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `TableNo` int(11) DEFAULT NULL,
  `BookingSlot` date DEFAULT NULL,
  `EmployeeID` int(11) UNSIGNED NOT NULL,
  `CustomerID` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`BookingID`),
  KEY `fk_bookinb_customer` (`CustomerID`),
  KEY `fk_booking_employee` (`EmployeeID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`BookingID`, `TableNo`, `BookingSlot`, `EmployeeID`, `CustomerID`) VALUES
(1, 3, '2023-10-04', 6, 3),
(2, 4, '2023-10-06', 3, 1),
(3, 2, '2023-10-02', 2, 4),
(4, 1, '2023-10-01', 4, 2),
(5, 4, '2023-10-04', 6, 2);

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
CREATE TABLE IF NOT EXISTS `customers` (
  `CustomerID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(100) NOT NULL,
  `LastName` varchar(100) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `PhoneNumber` varchar(15) NOT NULL,
  PRIMARY KEY (`CustomerID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`CustomerID`, `FirstName`, `LastName`, `Email`, `PhoneNumber`) VALUES
(1, 'arian', 'ayuobi', 'aryan.ayoubi@example.com', '080090012'),
(2, 'asad', 'rezaye', 'asad.rezaye@test.com', '070090213'),
(3, 'farhad', 'aslani', 'farhad.aslani@gu.com', '045679032'),
(4, 'hafiz', 'haidary', 'hafiz.haydary@re.com', '06556454');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
CREATE TABLE IF NOT EXISTS `employees` (
  `EmployeeID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `Role` varchar(100) DEFAULT NULL,
  `Address` varchar(100) DEFAULT NULL,
  `Contact_Number` int(11) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Annual_Salary` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`EmployeeID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

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
  `ItemID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) DEFAULT NULL,
  `Type` varchar(100) DEFAULT NULL,
  `Price` int(11) DEFAULT NULL,
  PRIMARY KEY (`ItemID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4;

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
  `MenuID` int(11) UNSIGNED NOT NULL,
  `ItemID` int(11) UNSIGNED NOT NULL,
  `Cuisine` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`MenuID`,`ItemID`),
  KEY `fk_menuitem_menus` (`ItemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
(3, 11, 'Turkish'),
(3, 16, 'Turkish'),
(3, 17, 'Turkish');

-- --------------------------------------------------------

--
-- Table structure for table `orderdelivery`
--

DROP TABLE IF EXISTS `orderdelivery`;
CREATE TABLE IF NOT EXISTS `orderdelivery` (
  `OrderDeliveryID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `DeliveryDate` date NOT NULL,
  `Status` varchar(255) NOT NULL,
  `OrderID` int(11) NOT NULL,
  PRIMARY KEY (`OrderDeliveryID`),
  KEY `fk_orderdelivery_order` (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `OrderID` int(11) NOT NULL,
  `TableNo` int(11) NOT NULL,
  `MenuID` int(11) UNSIGNED DEFAULT NULL,
  `BookingID` int(11) UNSIGNED DEFAULT NULL,
  `BillAmount` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  PRIMARY KEY (`OrderID`,`TableNo`),
  KEY `fk_booking_order` (`BookingID`),
  KEY `fk_menus_order` (`MenuID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`OrderID`, `TableNo`, `MenuID`, `BookingID`, `BillAmount`, `Quantity`) VALUES
(1, 12, 1, 1, 86, 2),
(2, 19, 2, 2, 37, 1),
(3, 15, 2, 3, 37, 1),
(4, 5, 3, 4, 40, 1),
(5, 8, 1, 5, 43, 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ordersview`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `ordersview`;
CREATE TABLE IF NOT EXISTS `ordersview` (
`OrderID` int(11)
,`Quantity` int(11)
,`BillAmount` int(11)
);

-- --------------------------------------------------------

--
-- Structure for view `ordersview`
--
DROP TABLE IF EXISTS `ordersview`;

DROP VIEW IF EXISTS `ordersview`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ordersview`  AS SELECT `orders`.`OrderID` AS `OrderID`, `orders`.`Quantity` AS `Quantity`, `orders`.`BillAmount` AS `BillAmount` FROM `orders` WHERE `orders`.`Quantity` > 22  ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_bookinb_customer` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_employee` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `menus`
--
ALTER TABLE `menus`
  ADD CONSTRAINT `fk_menuitem_menus` FOREIGN KEY (`ItemID`) REFERENCES `menuitems` (`ItemID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `orderdelivery`
--
ALTER TABLE `orderdelivery`
  ADD CONSTRAINT `fk_orderdelivery_order` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_booking_order` FOREIGN KEY (`BookingID`) REFERENCES `bookings` (`BookingID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_menus_order` FOREIGN KEY (`MenuID`) REFERENCES `menus` (`MenuID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
