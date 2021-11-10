-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema kiva_snowflake
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema kiva_snowflake
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `kiva_snowflake` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `kiva_snowflake` ;

-- -----------------------------------------------------
-- Table `kiva_snowflake`.`dim_world_region`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `kiva_snowflake`.`dim_world_region` (
  `world_region_key` SMALLINT NOT NULL AUTO_INCREMENT,
  `world_region_id` INT NOT NULL,
  `world_region_name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`world_region_key`))
ENGINE = InnoDB
AUTO_INCREMENT = 32
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `kiva_snowflake`.`dim_country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `kiva_snowflake`.`dim_country` (
  `country_key` SMALLINT NOT NULL AUTO_INCREMENT,
  `country_id` INT NOT NULL,
  `country_code` TEXT NULL DEFAULT NULL,
  `country_name` TEXT NULL DEFAULT NULL,
  `currency` TEXT NULL DEFAULT NULL,
  `population_in_thousands` INT NULL DEFAULT NULL,
  `gdp` INT NULL DEFAULT NULL,
  `gdp_growth_rate` DOUBLE NULL DEFAULT NULL,
  `population_below_poverty_line` DOUBLE NULL DEFAULT NULL,
  `hdi` DOUBLE NULL DEFAULT NULL,
  `life_expectancy` DOUBLE NULL DEFAULT NULL,
  `gni` DOUBLE NULL DEFAULT NULL,
  `country_mpi` DOUBLE NULL DEFAULT NULL,
  `world_region_key` SMALLINT NULL DEFAULT NULL,
  PRIMARY KEY (`country_key`),
  INDEX `fk_dim_country_dim_world_region1_idx` (`world_region_key` ASC) VISIBLE,
  CONSTRAINT `fk_dim_country_dim_world_region1`
    FOREIGN KEY (`world_region_key`)
    REFERENCES `kiva_snowflake`.`dim_world_region` (`world_region_key`))
ENGINE = InnoDB
AUTO_INCREMENT = 128
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `kiva_snowflake`.`dim_region`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `kiva_snowflake`.`dim_region` (
  `region_key` INT NOT NULL AUTO_INCREMENT,
  `region_id` INT NOT NULL,
  `region_name` VARCHAR(80) NULL DEFAULT NULL,
  `region_mpi` DOUBLE NULL DEFAULT NULL,
  `country_key` SMALLINT NULL DEFAULT NULL,
  PRIMARY KEY (`region_key`),
  INDEX `fk_dim_region_dim_country1_idx` (`country_key` ASC) VISIBLE,
  CONSTRAINT `fk_dim_region_dim_country1`
    FOREIGN KEY (`country_key`)
    REFERENCES `kiva_snowflake`.`dim_country` (`country_key`))
ENGINE = InnoDB
AUTO_INCREMENT = 16384
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `kiva_snowflake`.`dim_borrower`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `kiva_snowflake`.`dim_borrower` (
  `borrower_key` INT NOT NULL AUTO_INCREMENT,
  `borrower_id` INT NOT NULL,
  `gender` VARCHAR(45) NULL DEFAULT NULL,
  `region_key` INT NULL DEFAULT NULL,
  PRIMARY KEY (`borrower_key`),
  INDEX `fk_dim_borrower_dim_region1_idx` (`region_key` ASC) VISIBLE,
  CONSTRAINT `fk_dim_borrower_dim_region1`
    FOREIGN KEY (`region_key`)
    REFERENCES `kiva_snowflake`.`dim_region` (`region_key`))
ENGINE = InnoDB
AUTO_INCREMENT = 720886
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `kiva_snowflake`.`dim_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `kiva_snowflake`.`dim_category` (
  `category_key` SMALLINT NOT NULL AUTO_INCREMENT,
  `category_id` SMALLINT NOT NULL,
  `category_name` VARCHAR(45) NULL DEFAULT NULL,
  `sector_name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`category_key`))
ENGINE = InnoDB
AUTO_INCREMENT = 256
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `kiva_snowflake`.`dim_partner`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `kiva_snowflake`.`dim_partner` (
  `partner_key` SMALLINT NOT NULL AUTO_INCREMENT,
  `partner_id` INT NOT NULL,
  `partner_name` VARCHAR(150) NULL DEFAULT NULL,
  PRIMARY KEY (`partner_key`))
ENGINE = InnoDB
AUTO_INCREMENT = 512
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `kiva_snowflake`.`fact_loan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `kiva_snowflake`.`fact_loan` (
  `loan_key` INT NOT NULL AUTO_INCREMENT,
  `loan_id` INT NOT NULL,
  `borrower_key` INT NULL DEFAULT NULL,
  `partner_key` SMALLINT NULL DEFAULT NULL,
  `category_key` SMALLINT NOT NULL,
  `loan_amount` DOUBLE NOT NULL,
  `funded_amount` DOUBLE NOT NULL,
  `region_key` INT NULL DEFAULT NULL,
  `country_key` SMALLINT NOT NULL,
  `lenders_count` INT NULL DEFAULT NULL,
  `posted_time` DATE NULL DEFAULT NULL,
  `disbursed_time` DATE NULL DEFAULT NULL,
  `funded_time` DATE NULL DEFAULT NULL,
  `repayment_interval` VARCHAR(45) NULL DEFAULT NULL,
  `repayment_terms` INT NULL DEFAULT NULL,
  `loan_theme_type` VARCHAR(60) NULL DEFAULT NULL,
  `loan_state` INT NULL DEFAULT NULL COMMENT 'Whether the loan request was created on kiva website',
  `disbursed_state` INT NULL DEFAULT NULL COMMENT 'Whether the loan was disbursed ',
  `funded_state` INT NULL DEFAULT NULL COMMENT 'Whether the fund was fully funded by kiva lenders',
  PRIMARY KEY (`loan_key`),
  INDEX `fk_fact_loan_dim_country_idx` (`country_key` ASC) VISIBLE,
  INDEX `fk_fact_loan_dim_partner1_idx` (`partner_key` ASC) VISIBLE,
  INDEX `fk_fact_loan_dim_borrower1_idx` (`borrower_key` ASC) VISIBLE,
  INDEX `fk_fact_loan_dim_region1_idx` (`region_key` ASC) VISIBLE,
  INDEX `fk_fact_loan_dim_category_idx` (`category_key` ASC) VISIBLE,
  CONSTRAINT `fk_fact_loan_dim_borrower1`
    FOREIGN KEY (`borrower_key`)
    REFERENCES `kiva_snowflake`.`dim_borrower` (`borrower_key`),
  CONSTRAINT `fk_fact_loan_dim_category`
    FOREIGN KEY (`category_key`)
    REFERENCES `kiva_snowflake`.`dim_category` (`category_key`),
  CONSTRAINT `fk_fact_loan_dim_country`
    FOREIGN KEY (`country_key`)
    REFERENCES `kiva_snowflake`.`dim_country` (`country_key`),
  CONSTRAINT `fk_fact_loan_dim_partner1`
    FOREIGN KEY (`partner_key`)
    REFERENCES `kiva_snowflake`.`dim_partner` (`partner_key`),
  CONSTRAINT `fk_fact_loan_dim_region1`
    FOREIGN KEY (`region_key`)
    REFERENCES `kiva_snowflake`.`dim_region` (`region_key`))
ENGINE = InnoDB
AUTO_INCREMENT = 720886
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
