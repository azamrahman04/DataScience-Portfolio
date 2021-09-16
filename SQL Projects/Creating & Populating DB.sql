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




