-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema KIVA
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema KIVA
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `KIVA` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `KIVA` ;

-- -----------------------------------------------------
-- Table `KIVA`.`world_region`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `KIVA`.`world_region` (
  `world_region_id` INT NOT NULL,
  `world_region_name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`world_region_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `KIVA`.`country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `KIVA`.`country` (
  `country_id` INT NOT NULL,
  `country_code` TINYTEXT NULL DEFAULT NULL,
  `country_name` TINYTEXT NOT NULL,
  `world_region_id` INT NULL DEFAULT NULL,
  `currency` TINYTEXT NOT NULL,
  `population_in_thousands` INT NULL DEFAULT NULL,
  `gdp` INT NULL DEFAULT NULL,
  `gdp_growth_rate` DOUBLE NULL DEFAULT NULL,
  `population_below_poverty_line` DOUBLE NULL DEFAULT NULL,
  `hdi` DOUBLE NULL DEFAULT NULL,
  `life_expectancy` DOUBLE NULL DEFAULT NULL,
  `gni` DOUBLE NULL DEFAULT NULL,
  `country_mpi` DOUBLE NULL DEFAULT NULL,
  PRIMARY KEY (`country_id`),
  INDEX `fk_world_region_idx` (`world_region_id` ASC) VISIBLE,
  CONSTRAINT `fk_world_region`
    FOREIGN KEY (`world_region_id`)
    REFERENCES `KIVA`.`world_region` (`world_region_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `KIVA`.`region`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `KIVA`.`region` (
  `region_id` INT NOT NULL,
  `country_id` INT NOT NULL,
  `region_name` VARCHAR(80) NULL DEFAULT NULL,
  `region_mpi` DOUBLE NULL DEFAULT NULL,
  PRIMARY KEY (`region_id`),
  INDEX `fk_Region_Country1_idx` (`country_id` ASC) VISIBLE,
  CONSTRAINT `fk_Region_Country1`
    FOREIGN KEY (`country_id`)
    REFERENCES `KIVA`.`country` (`country_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `KIVA`.`borrower`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `KIVA`.`borrower` (
  `borrower_id` INT NOT NULL AUTO_INCREMENT,
  `gender` VARCHAR(45) NULL DEFAULT NULL,
  `region_id` INT NOT NULL,
  PRIMARY KEY (`borrower_id`),
  INDEX `fk_region_id_idx` (`region_id` ASC) VISIBLE,
  CONSTRAINT `fk_region_id`
    FOREIGN KEY (`region_id`)
    REFERENCES `KIVA`.`region` (`region_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 671206
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `KIVA`.`sector`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `KIVA`.`sector` (
  `sector_id` SMALLINT NOT NULL,
  `sector_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`sector_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `KIVA`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `KIVA`.`category` (
  `category_id` SMALLINT NOT NULL,
  `category_name` VARCHAR(45) NULL DEFAULT NULL,
  `sector_id` SMALLINT NOT NULL,
  PRIMARY KEY (`category_id`),
  INDEX `fk_Category_Sector1_idx` (`sector_id` ASC) VISIBLE,
  CONSTRAINT `fk_Category_Sector1`
    FOREIGN KEY (`sector_id`)
    REFERENCES `KIVA`.`sector` (`sector_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `KIVA`.`partner`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `KIVA`.`partner` (
  `partner_id` INT NOT NULL,
  `partner_name` VARCHAR(150) NULL DEFAULT NULL,
  PRIMARY KEY (`partner_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `KIVA`.`loan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `KIVA`.`loan` (
  `loan_id` INT NOT NULL,
  `borrower_id` INT NOT NULL,
  `partner_id` INT NULL DEFAULT NULL,
  `loan_amount` DOUBLE NOT NULL,
  `funded_amount` DOUBLE NOT NULL,
  `category_id` SMALLINT NOT NULL,
  `country_id` INT NOT NULL,
  `lenders_count` INT NULL DEFAULT NULL,
  `posted_time` DATE NULL DEFAULT NULL,
  `disbursed_time` DATE NULL DEFAULT NULL,
  `funded_time` DATE NULL DEFAULT NULL,
  `repayment_interval` VARCHAR(45) NOT NULL,
  `repayment_terms` INT NOT NULL,
  PRIMARY KEY (`loan_id`),
  INDEX `fk_Loan_Category_idx` (`category_id` ASC) VISIBLE,
  INDEX `fk_Loan_Borrower1_idx` (`borrower_id` ASC) VISIBLE,
  INDEX `fk_partner_id_idx` (`partner_id` ASC) VISIBLE,
  INDEX `fk_Loan_country_idx` (`country_id` ASC) VISIBLE,
  CONSTRAINT `fk_Loan_Borrower1`
    FOREIGN KEY (`borrower_id`)
    REFERENCES `KIVA`.`borrower` (`borrower_id`),
  CONSTRAINT `fk_Loan_Category`
    FOREIGN KEY (`category_id`)
    REFERENCES `KIVA`.`category` (`category_id`),
  CONSTRAINT `fk_Loan_country`
    FOREIGN KEY (`country_id`)
    REFERENCES `KIVA`.`country` (`country_id`),
  CONSTRAINT `fk_partner_id`
    FOREIGN KEY (`partner_id`)
    REFERENCES `KIVA`.`partner` (`partner_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `KIVA`.`loan_theme`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `KIVA`.`loan_theme` (
  `loan_theme_id` SMALLINT NOT NULL,
  `loan_theme_type` VARCHAR(60) NULL DEFAULT NULL,
  PRIMARY KEY (`loan_theme_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `KIVA`.`loan_theme_profile`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `KIVA`.`loan_theme_profile` (
  `loan_id` INT NOT NULL,
  `loan_theme_id` SMALLINT NOT NULL,
  PRIMARY KEY (`loan_id`),
  INDEX `fk_loan_theme_profile_loan_theme1_idx` (`loan_theme_id` ASC) VISIBLE,
  CONSTRAINT `fk_loan_id`
    FOREIGN KEY (`loan_id`)
    REFERENCES `KIVA`.`loan` (`loan_id`),
  CONSTRAINT `fk_loan_theme_profile_loan_theme1`
    FOREIGN KEY (`loan_theme_id`)
    REFERENCES `KIVA`.`loan_theme` (`loan_theme_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
