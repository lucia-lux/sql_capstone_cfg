CREATE DATABASE IF NOT EXISTS project;
USE project;


SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS contact_info;
CREATE TABLE contact_info
(
	name_id SMALLINT UNSIGNED AUTO_INCREMENT,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	email_address VARCHAR(50) NOT NULL,
    -- might varchar be better here (as someone might enter +44...)
	phone_number VARCHAR(20) DEFAULT NULL,
    -- char might be more performant than varchar here
    -- as we know the format of UK postcodes (6-8 characters incl space)?
	postcode CHAR(8) DEFAULT NULL,
	CONSTRAINT pk_name_id PRIMARY KEY (name_id)
);

DROP TABLE IF EXISTS eligibility_criteria;
CREATE TABLE eligibility_criteria
(
	name_id SMALLINT UNSIGNED,
	eligibility_id SMALLINT UNSIGNED AUTO_INCREMENT,
	height float,
	weight float,
	age TINYINT UNSIGNED,
	handedness ENUM('R','L','B'),
	CONSTRAINT PK_ELIGIBILITY_ID PRIMARY KEY (eligibility_id),
	FOREIGN KEY (name_id) REFERENCES contact_info(name_id)
);

DROP TABLE IF EXISTS experiment;
CREATE TABLE experiment
(
	experiment_id SMALLINT UNSIGNED AUTO_INCREMENT,
    eligibility_id SMALLINT UNSIGNED,
	experiment_type VARCHAR(30),
    lead_researcher VARCHAR(30),
    participation_date DATE,
    CONSTRAINT pk_experiment_id PRIMARY KEY (experiment_id),
    CONSTRAINT fk_eligibility_id_experiment FOREIGN KEY (eligibility_id)
    REFERENCES eligibility_criteria (eligibility_id)
);

DROP TABLE IF EXISTS location;
CREATE TABLE location (
location_id SMALLINT UNSIGNED AUTO_INCREMENT,
building_name VARCHAR (50),
room_number INTEGER,
experiment_id SMALLINT UNSIGNED,
CONSTRAINT PK_LOCATION_ID PRIMARY KEY (location_id),
FOREIGN KEY (experiment_id) REFERENCES experiment(experiment_id));

DROP TABLE IF EXISTS payments;
CREATE TABLE payments
(
	name_id SMALLINT UNSIGNED,
    experiment_id SMALLINT UNSIGNED,
    payment_id SMALLINT UNSIGNED AUTO_INCREMENT, 
    sortcode INT NOT NULL,
    account_num INT NOT NULL,
    date_payment_processed DATE,
    CONSTRAINT
    pk_PAYMENT_ID
    PRIMARY KEY (payment_id),
    CONSTRAINT fk_experiment_id
	FOREIGN KEY (experiment_id)
	REFERENCES experiment (experiment_id),
    CONSTRAINT fk_name_id
    FOREIGN KEY (name_id)
	REFERENCES contact_info (name_id)
);

DROP TABLE IF EXISTS lead_researcher;
CREATE TABLE lead_researcher
(
	researcher_id SMALLINT UNSIGNED AUTO_INCREMENT,
    experiment_id SMALLINT UNSIGNED NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialty VARCHAR(50),
    supervisor VARCHAR(50),
    CONSTRAINT 
    pk_RESEARCHER_ID
    PRIMARY KEY (researcher_id),
    CONSTRAINT fk_experiment_id_researcher
	FOREIGN KEY (experiment_id)
	REFERENCES experiment (experiment_id)
);

DROP TABLE IF EXISTS results;
CREATE TABLE results
(
	result_id SMALLINT UNSIGNED AUTO_INCREMENT,
    experiment_id SMALLINT UNSIGNED,
    start_date DATE,
    sample_size SMALLINT UNSIGNED,
    results_status ENUM("live", "completed"),
    CONSTRAINT pk_result_id PRIMARY KEY (result_id),
    CONSTRAINT fk_experiment_id_results FOREIGN KEY (experiment_id)
    REFERENCES experiment (experiment_id)
);

DROP TABLE IF EXISTS project_grant;
CREATE TABLE project_grant
(
	project_id SMALLINT UNSIGNED AUTO_INCREMENT,
    experiment_id SMALLINT UNSIGNED,
    researcher_id SMALLINT UNSIGNED,
	funding_amount FLOAT,
    CONSTRAINT pk_project_id PRIMARY KEY (project_id),
    CONSTRAINT fk_experiment_id_project FOREIGN KEY (experiment_id)
    REFERENCES experiment (experiment_id),
    CONSTRAINT fk_researcher_id_project FOREIGN KEY (researcher_id)
    REFERENCES lead_researcher (researcher_id)
);

SET FOREIGN_KEY_CHECKS = 1;
-- Populate tables with some data

INSERT INTO contact_info
(
	first_name,
    last_name,
    email_address,
    phone_number,
    postcode
)
VALUES
	("Sophie","Mayer","sophie@me.com", "+44789078534", "SW1A 2AA"),
    ("Andrew","Biggins","abiggins@mail.com", "0799087534", "N17 5BG"),
    ("Mary","Smith","smithy@gmail.com", "07745872345", "N7 3TS"),
    ("Joseph","Harris","jo_harris@me.com", "07865347621", "SE19 2AA");

INSERT INTO eligibility_criteria
(
	NAME_ID,
    HEIGHT,
    WEIGHT,
	AGE,
    HANDEDNESS
)
VALUES 
	(1, 1.64,70.22,35,'L'),
	(2,1.77, 65.10, 29, 'L'),
	(3, 1.80, 67.23, 18, 'R'),
	(4, 1.69, 64.23, 23, 'B');

INSERT INTO experiment
(
	eligibility_id,
    experiment_type,
    lead_researcher,
    participation_date
)
VALUES
	(2, "behavioural","Lees","2019-08-01"),
    (3,"online","Warner","2021-07-06"),
    (4,"behavioural","Bezo","2022-02-01"),
    (1,"pharmacological","Hare","2018-10-10");

INSERT INTO location
( 
	building_name,
	room_number,
    experiment_id
)
VALUES
('TATE', 7, 3),
('TATE', 22, 4),
('AQUATICS_CENTRE', 9, 2),
('HERON_TOWER', 30, 1);

INSERT INTO payments
(name_id, experiment_id, sortcode, account_num, date_payment_processed)
VALUES
(1, 3, 223344, 67790022, "2022-02-23"),
(2, 1, 223355, 67790088, "2022-02-01"),
(3, 1, 224488, 67990991, "2022-02-28)"),
(4, 2, 223366, 66677788, "2022-01-29");

INSERT INTO lead_researcher
(
	experiment_id,
    first_name,
    last_name,
    specialty,
    supervisor
    )
VALUES
    (1, 'Jane', 'Lees', 'Neurology', 'Jones'),
    (2, 'Alan', 'Warner', 'Fertility', 'Watson'),
    (3, 'Jeff', 'Bezo', 'Pyschology', 'Turner'),
    (4, 'Hetty', 'Hare', 'Behavioural', 'Walker');


INSERT INTO results
(
	experiment_id,
    start_date,
    sample_size,
    results_status
)
VALUES
	(2,"2019-08-01",80, "completed"),
    (3,"2021-07-06",120, "live"),
    (4,"2022-02-01",76, "live"),
    (1,"2018-10-10",35, "completed");


INSERT INTO project_grant
(
	experiment_id,
    researcher_id,
    funding_amount
)
VALUES
	(2,1,80000),
    (1,2,45600),
    (4,2,100000),
    (3,1,46000);






