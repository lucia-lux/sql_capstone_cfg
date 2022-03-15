USE project;
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
