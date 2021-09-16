---------------------
-- ASSIGNMENT 1:
---------------------
-- For this first assignment, I created an ER diagram using MySQL Workbench then forward engineered it and manually populated it.
-- The model is based on a financial system regarding the stock exchange and advising clients financial advise.

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Assignment 1-Final
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Assignment 1-Final` ;

-- -----------------------------------------------------
-- Schema Assignment 1-Final
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Assignment 1-Final` DEFAULT CHARACTER SET utf8 ;
USE `Assignment 1-Final` ;

-- -----------------------------------------------------
-- Table `Assignment 1-Final`.`FinancialAdviser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Assignment 1-Final`.`FinancialAdviser` ;

CREATE TABLE IF NOT EXISTS `Assignment 1-Final`.`FinancialAdviser` (
  `adviser_SIN` INT(9) NOT NULL,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  `specialty` VARCHAR(45) NULL,
  `years_exp` INT NULL,
  PRIMARY KEY (`adviser_SIN`),
  UNIQUE INDEX `adviser_SIN_UNIQUE` (`adviser_SIN` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Assignment 1-Final`.`Client`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Assignment 1-Final`.`Client` ;

CREATE TABLE IF NOT EXISTS `Assignment 1-Final`.`Client` (
  `client_SIN` INT(9) NOT NULL,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  `address` VARCHAR(45) NULL,
  `age` INT NULL,
  `Financial Adviser_adviser_SIN` INT(9) NOT NULL,
  PRIMARY KEY (`client_SIN`, `Financial Adviser_adviser_SIN`),
  UNIQUE INDEX `client_SIN_UNIQUE` (`client_SIN` ASC),
  INDEX `fk_Client_Financial Adviser_idx` (`Financial Adviser_adviser_SIN` ASC),
  CONSTRAINT `fk_Client_Financial Adviser`
    FOREIGN KEY (`Financial Adviser_adviser_SIN`)
    REFERENCES `Assignment 1-Final`.`FinancialAdviser` (`adviser_SIN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Assignment 1-Final`.`FSI`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Assignment 1-Final`.`FSI` ;

CREATE TABLE IF NOT EXISTS `Assignment 1-Final`.`FSI` (
  `name` VARCHAR(45) NOT NULL,
  `phone_No` VARCHAR(45) NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Assignment 1-Final`.`FinancialSecurity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Assignment 1-Final`.`FinancialSecurity` ;

CREATE TABLE IF NOT EXISTS `Assignment 1-Final`.`FinancialSecurity` (
  `trade_name` VARCHAR(45) NOT NULL,
  `symbol` VARCHAR(45) NULL,
  `FSI_name` VARCHAR(45) NOT NULL,
  UNIQUE INDEX `trade_name_UNIQUE` (`trade_name` ASC),
  PRIMARY KEY (`trade_name`, `FSI_name`),
  INDEX `fk_Financial Security_FSI1_idx` (`FSI_name` ASC),
  CONSTRAINT `fk_Financial Security_FSI1`
    FOREIGN KEY (`FSI_name`)
    REFERENCES `Assignment 1-Final`.`FSI` (`name`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Assignment 1-Final`.`Exchange`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Assignment 1-Final`.`Exchange` ;

CREATE TABLE IF NOT EXISTS `Assignment 1-Final`.`Exchange` (
  `exchange_name` VARCHAR(45) NOT NULL,
  `address` VARCHAR(45) NULL,
  `phone_No` VARCHAR(45) NULL,
  PRIMARY KEY (`exchange_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Assignment 1-Final`.`Financial Security_has_Exchange`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Assignment 1-Final`.`Financial Security_has_Exchange` ;

CREATE TABLE IF NOT EXISTS `Assignment 1-Final`.`Financial Security_has_Exchange` (
  `Financial Security_trade_name` VARCHAR(45) NOT NULL,
  `Financial Security_FSI_name` VARCHAR(45) NOT NULL,
  `Exchange_exchange_name` VARCHAR(45) NOT NULL,
  `price` DOUBLE NULL,
  `currency` VARCHAR(45) NULL,
  PRIMARY KEY (`Financial Security_trade_name`, `Financial Security_FSI_name`, `Exchange_exchange_name`),
  INDEX `fk_Financial Security_has_Exchange_Exchange1_idx` (`Exchange_exchange_name` ASC),
  INDEX `fk_Financial Security_has_Exchange_Financial Security1_idx` (`Financial Security_trade_name` ASC, `Financial Security_FSI_name` ASC),
  CONSTRAINT `fk_Financial Security_has_Exchange_Financial Security1`
    FOREIGN KEY (`Financial Security_trade_name` , `Financial Security_FSI_name`)
    REFERENCES `Assignment 1-Final`.`FinancialSecurity` (`trade_name` , `FSI_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Financial Security_has_Exchange_Exchange1`
    FOREIGN KEY (`Exchange_exchange_name`)
    REFERENCES `Assignment 1-Final`.`Exchange` (`exchange_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Assignment 1-Final`.`Contract`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Assignment 1-Final`.`Contract` ;

CREATE TABLE IF NOT EXISTS `Assignment 1-Final`.`Contract` (
  `Exchange_exchange_name` VARCHAR(45) NOT NULL,
  `FSI_name` VARCHAR(45) NOT NULL,
  `start_date` DATE NULL,
  `end_date` DATE NULL,
  `text` VARCHAR(255) NULL,
  PRIMARY KEY (`Exchange_exchange_name`, `FSI_name`),
  INDEX `fk_Exchange_has_FSI_FSI1_idx` (`FSI_name` ASC),
  INDEX `fk_Exchange_has_FSI_Exchange1_idx` (`Exchange_exchange_name` ASC),
  CONSTRAINT `fk_Exchange_has_FSI_Exchange1`
    FOREIGN KEY (`Exchange_exchange_name`)
    REFERENCES `Assignment 1-Final`.`Exchange` (`exchange_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Exchange_has_FSI_FSI1`
    FOREIGN KEY (`FSI_name`)
    REFERENCES `Assignment 1-Final`.`FSI` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Assignment 1-Final`.`Recommendation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Assignment 1-Final`.`Recommendation` ;

CREATE TABLE IF NOT EXISTS `Assignment 1-Final`.`Recommendation` (
  `Financial Security_trade_name` VARCHAR(45) NOT NULL,
  `Financial Security_FSI_name` VARCHAR(45) NOT NULL,
  `Financial Adviser_adviser_SIN` INT(9) NOT NULL,
  `recommend_date` DATE NULL,
  `quantity` INT NULL,
  PRIMARY KEY (`Financial Security_trade_name`, `Financial Security_FSI_name`, `Financial Adviser_adviser_SIN`),
  INDEX `fk_Financial Security_has_Financial Adviser_Financial Advis_idx` (`Financial Adviser_adviser_SIN` ASC),
  INDEX `fk_Financial Security_has_Financial Adviser_Financial Secur_idx` (`Financial Security_trade_name` ASC, `Financial Security_FSI_name` ASC),
  CONSTRAINT `fk_Financial Security_has_Financial Adviser_Financial Security1`
    FOREIGN KEY (`Financial Security_trade_name` , `Financial Security_FSI_name`)
    REFERENCES `Assignment 1-Final`.`FinancialSecurity` (`trade_name` , `FSI_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Financial Security_has_Financial Adviser_Financial Adviser1`
    FOREIGN KEY (`Financial Adviser_adviser_SIN`)
    REFERENCES `Assignment 1-Final`.`FinancialAdviser` (`adviser_SIN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- -----------------------------------------------------
-- Manually inserted 3 rows into each table below (total of 8 tables)
-- -----------------------------------------------------
-- -----------------------------------------------------
-- NOTE: I didn't realize that we can automatically populate the tables using the mwb 
-- file until after I finished the code below. So, I manually did it.
-- I first forward engineered my ER-Model, then inserted data using the code below.
-- -----------------------------------------------------

INSERT INTO `Assignment 1-Final`.`FinancialAdviser`
(`adviser_SIN`,`first_name`,`last_name`,`specialty`,`years_exp`)
VALUES
(478543344,'Helen', 'Yankkovic', 'Economics',20),
(356725578,'Jennifer', 'Cooly', 'Mathematics',7),
(805369146,'Juan', 'Lopez', 'Economics',9);


INSERT INTO `Assignment 1-Final`.`Client`
(`client_SIN`,`first_name`,`last_name`,`address`,`age`, `Financial Adviser_adviser_SIN`)
VALUES
(294056545,'John','Doe','1045 Downview Drive', 25, (SELECT `FinancialAdviser`.`adviser_SIN`
FROM `Assignment 1-Final`.`FinancialAdviser` WHERE adviser_SIN = 478543344)),
(357854458,'Emily','Smith','45 Cricer Avenue', 37, (SELECT `FinancialAdviser`.`adviser_SIN`
FROM `Assignment 1-Final`.`FinancialAdviser` WHERE adviser_SIN = 356725578)),
(457787632,'Jimmy','Finn','10 Gigwire Drive', 29, (SELECT `FinancialAdviser`.`adviser_SIN`
FROM `Assignment 1-Final`.`FinancialAdviser` WHERE adviser_SIN = 805369146)) ;


INSERT INTO `Assignment 1-Final`.`FSI`
(`name`,`phone_No`)
VALUES
('IBM','905-435-3456'),
('Apple','905-579-6905'),
('TELUS','905-589-9520') ;


INSERT INTO `Assignment 1-Final`.`FinancialSecurity`
(`trade_name`,`symbol`,`FSI_name`)
VALUES
('Class A Shares','T.TO',(SELECT `FSI`.`name`
FROM `Assignment 1-Final`.`FSI` WHERE name = 'TELUS')),
('Class B Shares','AAPL',(SELECT `FSI`.`name`
FROM `Assignment 1-Final`.`FSI` WHERE name = 'Apple')),
('Class C Shares','IBM',(SELECT `FSI`.`name`
FROM `Assignment 1-Final`.`FSI` WHERE name = 'IBM'));


INSERT INTO `Assignment 1-Final`.`Exchange`
(`exchange_name`,`address`,`phone_No`)
VALUES
('Toronto Stock Exchange','3574 Bay Street','905-653-1926'),
('New York Stock Exchange','61 Wall Street','905-367-2467'),
('NASDAQ','4689 Bay Street','905-356-5442');


INSERT INTO `Assignment 1-Final`.`Financial Security_has_Exchange`
(`Financial Security_trade_name`,`Financial Security_FSI_name`,`Exchange_exchange_name`,`price`,`currency`)
VALUES
((SELECT `FinancialSecurity`.`trade_name`
FROM `Assignment 1-Final`.`FinancialSecurity` WHERE trade_name = 'Class A Shares'),
(SELECT `FSI`.`name`
FROM `Assignment 1-Final`.`FSI` WHERE name = 'TELUS'),
(SELECT `Exchange`.`exchange_name`
FROM `Assignment 1-Final`.`Exchange` WHERE exchange_name = 'Toronto Stock Exchange'),
25.97,
'CAD'),
((SELECT `FinancialSecurity`.`trade_name`
FROM `Assignment 1-Final`.`FinancialSecurity` WHERE trade_name = 'Class B Shares'),
(SELECT `FSI`.`name`
FROM `Assignment 1-Final`.`FSI` WHERE name = 'Apple'),
(SELECT `Exchange`.`exchange_name`
FROM `Assignment 1-Final`.`Exchange` WHERE exchange_name = 'New York Stock Exchange'),
128.57,
'USD'),
((SELECT `FinancialSecurity`.`trade_name`
FROM `Assignment 1-Final`.`FinancialSecurity` WHERE trade_name = 'Class C Shares'),
(SELECT `FSI`.`name`
FROM `Assignment 1-Final`.`FSI` WHERE name = 'IBM'),
(SELECT `Exchange`.`exchange_name`
FROM `Assignment 1-Final`.`Exchange` WHERE exchange_name = 'New York Stock Exchange'),
181.58,
'USD') ;


INSERT INTO `Assignment 1-Final`.`Recommendation`
(`Financial Security_trade_name`,`Financial Security_FSI_name`,`Financial Adviser_adviser_SIN`,
`recommend_date`,`quantity`)
VALUES
((SELECT `FinancialSecurity`.`trade_name`
FROM `Assignment 1-Final`.`FinancialSecurity` WHERE trade_name = 'Class A Shares'),
(SELECT `FSI`.`name`
FROM `Assignment 1-Final`.`FSI` WHERE name = 'TELUS'),
(SELECT `FinancialAdviser`.`adviser_SIN`
FROM `Assignment 1-Final`.`FinancialAdviser` WHERE adviser_SIN = 478543344),
'2021-05-17',
80),
((SELECT `FinancialSecurity`.`trade_name`
FROM `Assignment 1-Final`.`FinancialSecurity` WHERE trade_name = 'Class B Shares'),
(SELECT `FSI`.`name`
FROM `Assignment 1-Final`.`FSI` WHERE name = 'Apple'),
(SELECT `FinancialAdviser`.`adviser_SIN`
FROM `Assignment 1-Final`.`FinancialAdviser` WHERE adviser_SIN = 356725578),
'2021-05-13',
200),
((SELECT `FinancialSecurity`.`trade_name`
FROM `Assignment 1-Final`.`FinancialSecurity` WHERE trade_name = 'Class C Shares'),
(SELECT `FSI`.`name`
FROM `Assignment 1-Final`.`FSI` WHERE name = 'IBM'),
(SELECT `FinancialAdviser`.`adviser_SIN`
FROM `Assignment 1-Final`.`FinancialAdviser` WHERE adviser_SIN = 805369146),
'2021-05-03',
50) ; 


INSERT INTO `Assignment 1-Final`.`Contract`
(`Exchange_exchange_name`,`FSI_name`,`start_date`,`end_date`,`text`)
VALUES
((SELECT `Exchange`.`exchange_name`
FROM `Assignment 1-Final`.`Exchange` WHERE exchange_name = 'Toronto Stock Exchange'),
(SELECT `FSI`.`name`
FROM `Assignment 1-Final`.`FSI` WHERE name = 'TELUS'),
'2019-05-21',
'2022-05-22',
'issuer must be signed for 3 years'),
((SELECT `Exchange`.`exchange_name`
FROM `Assignment 1-Final`.`Exchange` WHERE exchange_name = 'New York Stock Exchange'),
(SELECT `FSI`.`name`
FROM `Assignment 1-Final`.`FSI` WHERE name = 'Apple'),
'2020-06-15',
'2022-06-16',
'issuer must be signed for 2 years'),
((SELECT `Exchange`.`exchange_name`
FROM `Assignment 1-Final`.`Exchange` WHERE exchange_name = 'New York Stock Exchange'),
(SELECT `FSI`.`name`
FROM `Assignment 1-Final`.`FSI` WHERE name = 'IBM'),
'2018-02-09',
'2024-02-10',
'issuer must be signed for 6 years') ;


------------------
--ASSIGNMENT 2:
------------------

-- This Assignment is to create a database, populate it, then run queries on it to grab the requires information.
-- This model is based on a simple Salesman, Customer, and Order tables.

-- -----------------------------------------------------
-- Schema Sales
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Sales` DEFAULT CHARACTER SET utf8 ;
USE `Sales` ;

-- -----------------------------------------------------
-- Table `Sales`.`Salesman`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Sales`.`Salesman` (
  `salesman_ID` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `commission` FLOAT NULL,
  PRIMARY KEY (`salesman_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Sales`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Sales`.`Customer` (
  `customer_ID` INT NOT NULL,
  `cust_name` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `grade` INT NULL,
  `salesman_ID` INT NULL,
  PRIMARY KEY (`customer_ID`),
  INDEX `salesman_ID_idx` (`salesman_ID` ASC),
  CONSTRAINT `salesman_ID`
    FOREIGN KEY (`salesman_ID`)
    REFERENCES `Sales`.`Salesman` (`salesman_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Sales`.`Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Sales`.`Orders` (
  `Order_No` INT NOT NULL,
  `Purch_Amt` FLOAT NULL,
  `Ord_Date` DATE NULL,
  `customer_ID` INT NULL,
  `salesman_ID` INT NULL,
  PRIMARY KEY (`Order_No`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
 
-- # INSERT VALUES
 
INSERT INTO Salesman VALUES  
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5003, 'Lauson Hen', NULL, 0.12),
(5007, 'Paul Adam', 'Rome', 0.13);

 INSERT INTO Customer VALUES 
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3001, 'Brad Guzan', 'London', NULL, 5005),
(3004, 'Fabian Johns', 'Paris', 300, 5006),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3009, 'Geoff Camero', 'Berlin', 100, 5003),
(3008, 'Julian Green', 'London', 300, 5002),
(3003, 'Jozy Altidor', 'Moscow', 200, 5007) ;

INSERT INTO Orders VALUES 
(70001, 150.5, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.5, '2012-08-17', 3009, 5003),
(70007, 948.5, '2012-09-10', 3005, 5002),
(70005, 2400.6, '2012-07-27', 3007, 5001),
(70008, 5760, '2012-09-10', 3002, 5001),
(70010, 1983.43, '2012-10-10', 3004, 5006),
(70003, 2480.4, '2012-10-10', 3009, 5003),
(70012, 250.45, '2012-06-27', 3008, 5002),
(70011, 75.29, '2012-08-17', 3003, 5007),
(70013, 3045.6, '2012-04-25', 3002, 5001);

-- Queries to Assignment 2: 

-- # Query 1: A list with salesman name, customer name and their cities for the salesmen and customer who belong to same city.
 SELECT cust_name, name, S.city FROM Customer as C
 INNER JOIN Salesman AS S ON C.city = S.city ; 
 
 --  # Query 2: A list with order no, purchase amount, customer name and their cities for the orders where order amount is between 500 and 2000.
 SELECT O.Order_No, O.Purch_Amt, C.cust_name, C.city FROM Orders as O JOIN Customer as C ON (O.customer_ID = C.customer_ID)  
 WHERE O.Purch_Amt BETWEEN 500 AND 2000 ;
 
-- # Query 3: Find out which salesmen are working for which customer.
 SELECT S.name as 'Salesman', C.cust_name as 'Customer' FROM Salesman as S RIGHT JOIN Customer as C ON S.salesman_ID = C.salesman_ID 
 ORDER BY S.name ;
 
-- # Query 4: Find the list of customers who appointed a salesman for their jobs whose commission is more than 12%.
 SELECT C.customer_ID,
  C.cust_name
 FROM Customer as C LEFT JOIN Salesman as S ON C.salesman_ID = S.salesman_ID
 WHERE S.commission >= 0.12 ;
 
--# Query 5: Find the list of customers who appointed a salesman fortheir jobs who does not live in same city where the customer lives, and gets a commission above 12%.
 SELECT C.customer_ID,
  C.cust_name 
  FROM Customer as C INNER JOIN Salesman as S ON C.salesman_ID = S.salesman_ID
 WHERE S.commission >= 0.12 AND C.city <> S.city ;
 
-- # Query 6: Find the details of an order i. e. order number, order date, amount of order, which customer gives the order and which salesman works for that customer and how much commission he gets for an order.
 SELECT 
 Order_No, Ord_Date, Purch_Amt, C.cust_name as 'Customer', S.name as 'Salesman', S.commission FROM Orders as O 
 LEFT JOIN Customer as C ON O.salesman_ID = C.salesman_ID  
 LEFT JOIN Salesman as S ON C.salesman_ID = S.salesman_ID;
 
-- # Query 7: Make a join within the tables salesman, customer and orders such that the same column of each table will appear once and only the related rows will be returned.
 SELECT * FROM Orders 
 NATURAL JOIN Customer
 NATURAL JOIN Salesman ;

 ------------------
 --ASSIGNMENT 3:
 ------------------




