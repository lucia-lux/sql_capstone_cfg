/*reate view that shows researchers who currently
have active projects + the eligibility id of participants
signed up for their studies*/

USE project;
CREATE OR REPLACE VIEW exp_participation_vw AS
SELECT
	r.last_name,
    r.specialty,
    res.results_status,
    elg_exp.experiment_type,
    elg_exp.participation_date,
    elg_exp.eligibility_id
FROM
	(
    SELECT
		ex.experiment_type,
        ex.participation_date,
        ex.experiment_id,
        el.eligibility_id
	FROM experiment ex
    INNER JOIN eligibility_criteria el
    ON ex.eligibility_id = el.eligibility_id
    ) AS elg_exp
INNER JOIN lead_researcher r
USING (experiment_id)
INNER JOIN results res
USING (experiment_id)
GROUP BY elg_exp.participation_date
HAVING res.results_status = "live";

-- see it in action:
SELECT *
FROM exp_participation_vw
LIMIT 15;