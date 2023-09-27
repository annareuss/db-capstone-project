-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemon
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LittleLemon
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemon` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemon` ;

-- -----------------------------------------------------
-- Table `LittleLemon`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemon`.`Customers` (
  `CustomerID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(100) NOT NULL,
  `LastName` VARCHAR(100) NOT NULL,
  `PhoneNr` INT NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemon`.`Staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemon`.`Staff` (
  `StaffID` INT NOT NULL,
  `FirstName` VARCHAR(100) NOT NULL,
  `LastName` VARCHAR(100) NOT NULL,
  `PhoneNr` INT NOT NULL,
  `Role` VARCHAR(100) NOT NULL,
  `Salary` INT NOT NULL,
  PRIMARY KEY (`StaffID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemon`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemon`.`Bookings` (
  `BookingID` INT NOT NULL AUTO_INCREMENT,
  `BookingDate` DATE NOT NULL,
  `BookingTime` TIME NOT NULL,
  `TableNr` INT NOT NULL,
  `CustomerID` INT NOT NULL,
  `StaffID` INT NOT NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `CustomerID_fk_idx` (`CustomerID` ASC) VISIBLE,
  INDEX `StaffID_fk2_idx` (`StaffID` ASC) VISIBLE,
  CONSTRAINT `CustomerID_fk`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `LittleLemon`.`Customers` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `StaffID_fk2`
    FOREIGN KEY (`StaffID`)
    REFERENCES `LittleLemon`.`Staff` (`StaffID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemon`.`Menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemon`.`Menu` (
  `MenuID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(100) NOT NULL,
  `Type` VARCHAR(100) NOT NULL,
  `Cuisine` VARCHAR(100) NOT NULL,
  `Price` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`MenuID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemon`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemon`.`Orders` (
  `OrderID` INT NOT NULL AUTO_INCREMENT,
  `OrderDate` DATE NOT NULL,
  `MenuID` INT NOT NULL,
  `Quantity` INT NOT NULL,
  `TotalCost` VARCHAR(45) NOT NULL,
  `StaffID` INT NOT NULL,
  `CustomerID` INT NOT NULL,
  PRIMARY KEY (`OrderID`),
  INDEX `MenuID_fk_idx` (`MenuID` ASC) VISIBLE,
  INDEX `StaffID_fk_idx` (`StaffID` ASC) VISIBLE,
  INDEX `CustomerID_fk2_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `MenuID_fk`
    FOREIGN KEY (`MenuID`)
    REFERENCES `LittleLemon`.`Menu` (`MenuID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `StaffID_fk`
    FOREIGN KEY (`StaffID`)
    REFERENCES `LittleLemon`.`Staff` (`StaffID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `CustomerID_fk2`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `LittleLemon`.`Customers` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemon`.`Delivery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemon`.`Delivery` (
  `DeliveryID` INT NOT NULL AUTO_INCREMENT,
  `DeliveryDate` DATE NOT NULL,
  `DeliveryStatus` VARCHAR(50) NOT NULL,
  `OrderID` INT NOT NULL,
  PRIMARY KEY (`DeliveryID`),
  INDEX `OrderID_fk_idx` (`OrderID` ASC) VISIBLE,
  CONSTRAINT `OrderID_fk`
    FOREIGN KEY (`OrderID`)
    REFERENCES `LittleLemon`.`Orders` (`OrderID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
