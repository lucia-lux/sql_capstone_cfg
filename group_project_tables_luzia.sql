USE project;

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
