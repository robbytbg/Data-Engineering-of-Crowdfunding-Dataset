-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/NqTsR5
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE `Campaign` (
    `cf_id` INTEGER  NOT NULL ,
    `contact_id` INTEGER  NOT NULL ,
    `company_name` VARCHAR(50)  NOT NULL ,
    `blurb` VARCHAR(255)  NOT NULL ,
    `goal` INTEGER  NOT NULL ,
    `pledged` INTEGER  NOT NULL ,
    `outcome` VARCHAR(50)  NOT NULL ,
    `backers_count` INTEGER  NOT NULL ,
    `country` VARCHAR(50)  NOT NULL ,
    `currency` VARCHAR(50)  NOT NULL ,
    `launched_at` DATE  NOT NULL ,
    `deadline` DATE  NOT NULL ,
    `category_id` INTEGER  NOT NULL ,
    `sub_category_id` INTEGER  NOT NULL ,
    PRIMARY KEY (
        `cf_id`
    )
);

CREATE TABLE `Sub_category` (
    `sub_category` VARCHAR(50)  NOT NULL ,
    `sub_category_id` INTEGER  NOT NULL ,
    PRIMARY KEY (
        `sub_category_id`
    )
);

CREATE TABLE `Category` (
    `category` VARCHAR(50)  NOT NULL ,
    `category_id` INTEGER  NOT NULL ,
    PRIMARY KEY (
        `category_id`
    )
);

CREATE TABLE `Contact` (
    `contact_id` INTEGER  NOT NULL ,
    `email` VARCHAR(100)  NOT NULL ,
    `first_name` VARCHAR(100)  NOT NULL ,
    `last_name` VARCHAR(100)  NOT NULL ,
    PRIMARY KEY (
        `contact_id`
    )
);

ALTER TABLE `Campaign` ADD CONSTRAINT `fk_Campaign_contact_id` FOREIGN KEY(`contact_id`)
REFERENCES `Contact` (`contact_id`);

ALTER TABLE `Campaign` ADD CONSTRAINT `fk_Campaign_category_id` FOREIGN KEY(`category_id`)
REFERENCES `Category` (`category_id`);

ALTER TABLE `Campaign` ADD CONSTRAINT `fk_Campaign_sub_category_id` FOREIGN KEY(`sub_category_id`)
REFERENCES `Sub_category` (`sub_category_id`);

