USE project;
-- query with having/group by
 SELECT pg.experiment_id,
		pg.project_id,
        pg.funding_amount,
        r.result_id,
        r.start_date,
        r.results_status
FROM project_grant pg
INNER JOIN results r
ON pg.experiment_id = r.experiment_id
GROUP BY r.start_date
HAVING r.results_status = "live";