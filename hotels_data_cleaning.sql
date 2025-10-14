-- DATA CLEANING AND RESTRUCTURING

-- create table combining annual tables
SELECT *
INTO Hotels
FROM (
	SELECT * FROM Hotels2018
	UNION
	SELECT * FROM Hotels2019
	UNION
	SELECT * FROM Hotels2020
) AS annual_tables;

-- observe rows missing agent or company
SELECT
	SUM(CASE WHEN agent IS NULL THEN 1 ELSE 0 END) AS missing_agent,
	SUM(CASE WHEN agent IS NOT NULL THEN 1 ELSE 0 END) AS present_agent
FROM Hotels -- 14528 rows

SELECT
	SUM(CASE WHEN company = 'NULL' THEN 1 ELSE 0 END) AS missing_company,
	SUM(CASE WHEN company <> 'NULL' THEN 1 ELSE 0 END) AS present_company
FROM Hotels; -- 94565 rows

-- delete agent and company column
ALTER TABLE Hotels
DROP COLUMN agent, company;

-- remove bookings with 2014 date
SELECT *
FROM Hotels
WHERE YEAR(reservation_status_date) = 2014; -- 24 rows

DELETE
FROM Hotels
WHERE YEAR(reservation_status_date) = 2014;

-- remove NULLs from children
SELECT *
FROM Hotels
WHERE children IS NULL; -- 8 rows (all cancelled bookings)

DELETE
FROM Hotels
WHERE children IS NULL;

SELECT *
FROM Hotels
WHERE booking_changes IS NULL;