-- MySQL database project, TEAM B
-- Create database and tables
CREATE DATABASE IF NOT EXISTS research;
USE research;

SET FOREIGN_KEY_CHECKS = 0;
-- will change to:
-- CREATE TABLE IF NOT EXISTS table_name()
-- For the moment it's just more convenient to do it like this
-- just to avoid having to constantly modify existing tables.

DROP TABLE IF EXISTS subjects;
CREATE TABLE  subjects
(
	subject_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	fname VARCHAR(20) NOT NULL,
	lname VARCHAR(20) NOT NULL,
	street_address VARCHAR(60) NOT NULL,
	postcode VARCHAR(7) NOT NULL,
    phone_number VARCHAR(50) DEFAULT NULL,
    email_address VARCHAR(50) NOT NULL,
    dob DATE,
	CONSTRAINT pk_subject_id PRIMARY KEY (subject_id)
);

DROP TABLE IF EXISTS screening;
CREATE TABLE screening
(
	screening_id SMALLINT UNSIGNED AUTO_INCREMENT,
	subject_id SMALLINT UNSIGNED NOT NULL,
	height_metres FLOAT DEFAULT NULL,
	weight_kg FLOAT DEFAULT NULL, 
	medical_condition VARCHAR(20) DEFAULT NULL,
    handedness ENUM ("L", "R"),
    normal_vision ENUM ("NOR", "COR", "IMP"),
	CONSTRAINT pk_screening_id PRIMARY KEY (screening_id),
    CONSTRAINT fk_screening_subject_id FOREIGN KEY (subject_id)
    REFERENCES subjects (subject_id)
);

DROP TABLE IF EXISTS researcher;
CREATE TABLE researcher
(
	researcher_id SMALLINT UNSIGNED AUTO_INCREMENT,
    supervisor VARCHAR(20),
    department ENUM ("NEURO", "PHARM", "PSYCH", "MEDIC"),
	CONSTRAINT pk_researcher_id PRIMARY KEY (researcher_id)
);

DROP TABLE IF EXISTS experiment;
CREATE TABLE experiment
(
	experiment_id  SMALLINT UNSIGNED AUTO_INCREMENT,
    screening_id SMALLINT UNSIGNED NOT NULL,
    researcher_id SMALLINT UNSIGNED NOT NULL,
    -- synonym for boolean
	ethics_approved BOOLEAN,
	experiment_type ENUM("pharm", "image", "behav", "onlne"),
    completion_date DATE,
	CONSTRAINT pk_experiment_id PRIMARY KEY (experiment_id),
    CONSTRAINT fk_experiment_screening_id FOREIGN KEY (screening_id)
    REFERENCES screening (screening_id),
    CONSTRAINT fk_experiment_researcher_id FOREIGN KEY (researcher_id)
    REFERENCES researcher (researcher_id)
);

DROP TABLE IF EXISTS payments;
CREATE TABLE payments
(
	payment_id SMALLINT UNSIGNED AUTO_INCREMENT,
    subject_id SMALLINT UNSIGNED NOT NULL,
    experiment_id SMALLINT UNSIGNED,
    payment_date DATE NOT NULL,
    payment_amount FLOAT NOT NULL,
    CONSTRAINT pk_payment_id PRIMARY KEY (payment_id),
    CONSTRAINT fk_payment_subject_id FOREIGN KEY (subject_id)
    REFERENCES subjects (subject_id),
    CONSTRAINT fk_payment_experiment_id FOREIGN KEY (experiment_id)
    REFERENCES experiment (experiment_id)
);

DROP TABLE IF EXISTS payment_details;
CREATE TABLE payment_details
(
	subject_id SMALLINT UNSIGNED NOT NULL,
    experiment_id SMALLINT UNSIGNED,
	iban VARCHAR(50) NOT NULL,
    swift VARCHAR(50) NOT NULL,
    -- not sure if this is the way to go?
    CONSTRAINT pk_subject_id_experiment_id PRIMARY KEY (subject_id, experiment_id),
    CONSTRAINT fk_subject_id_payment_dets FOREIGN KEY (subject_id)
    REFERENCES subjects (subject_id),
    CONSTRAINT fk_experiment_id_payment_dets FOREIGN KEY (experiment_id)
    REFERENCES experiment (experiment_id)
);
SET FOREIGN_KEY_CHECKS = 1;
