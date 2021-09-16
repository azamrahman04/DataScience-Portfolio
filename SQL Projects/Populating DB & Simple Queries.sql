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