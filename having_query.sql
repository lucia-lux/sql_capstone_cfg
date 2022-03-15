USE research;
-- query with having/group by
 SELECT pg.experiment_id,
		pg.project_name,
        pg.funding_amount,
        r.result_id,
        r.start_date,
        r.results_status
FROM project_grant pg
INNER JOIN results r
ON pg.experiment_id = r.experiment_id
GROUP BY r.start_date
HAVING r.results_status = "complete";

-- stored function
-- we often need to know the BMI range
-- to check eligiblity.
-- This is especially important for drug studies.
DROP FUNCTION IF EXISTS BMICheck;
DELIMITER //
CREATE FUNCTION BMICheck(
	 height FLOAT,
     weight FLOAT
) 
RETURNS VARCHAR(20)
-- always returns same OP for same IP
-- (pure or impure functions??)
DETERMINISTIC
BEGIN
    DECLARE BMIRange VARCHAR(10);
    DECLARE BMI FLOAT;
    DECLARE height_sq FLOAT;
    SET height_sq = POWER(height,2);
	SET BMI = weight/height_sq;
    IF BMI < 18.5 THEN
		SET BMIRange = "low";
    ELSEIF (BMI >= 18.5 AND 
			BMI <= 25) THEN
        SET BMIRange = "normal";
    ELSEIF BMI > 25 THEN
        SET BMIRange = "high";
    END IF;
	-- return BMI Range
	RETURN (BMIRange);
END //
DELIMITER ;

-- To view it in action:
SELECT eligibility_id, BMICheck(height,weight)
FROM eligibility_criteria;

-- complex view
CREATE OR REPLACE VIEW exp_participation_vw AS
SELECT
	r.last_name,
    r.specialty,
    res.results_status,
    elg_exp.experiment_type,
    elg_exp.experiment_date
FROM
	(
    SELECT
		ex.experiment_type,
        ex.experiment_date,
        ex.experiment_id,
        el.eligibility_id
	FROM experiment ex
    INNER JOIN eligibility el
    ON ex.experiment_id = el.experiment_id
    ) AS elg_exp
INNER JOIN lead_researcher r
USING (experiment_id)
INNER JOIN results res
USING (experiment_id)
GROUP BY elg_exp.experiment_date
HAVING res.results_status = "complete";
