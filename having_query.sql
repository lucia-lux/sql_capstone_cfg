USE research;

-- select all subjects whose first name
-- starts with s
-- group by last name
SELECT s.fname,s.lname
FROM subjects s 
GROUP BY s.lname
HAVING s.fname LIKE "S%";