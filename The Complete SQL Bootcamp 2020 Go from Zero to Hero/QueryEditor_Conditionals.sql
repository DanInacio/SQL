/*Conditional Expressions and Procedures*/
SELECT * FROM customer;

-- CASE (Same as an If/Else)
SELECT customer_id,
CASE
	WHEN (customer_id <= 100) THEN 'Premium'
	WHEN (customer_id BETWEEN 100 AND 200) THEN 'Plus'
	ELSE 'Regular'
END AS customer_class
FROM customer;

-- (another version, for equality '=')
SELECT customer_id,
CASE customer_id
	WHEN 2 THEN 'Winner'
	WHEN 5 THEN '2nd Place'
	ELSE 'Regular'
END AS raffle_results
FROM customer;

-- (another version for just the Case column)
SELECT
CASE rental_rate
	WHEN 0.99 THEN 1
	ELSE 0
END
FROM film;

-- (get a sum of occurrences - same as a GROUP BY)
SELECT
SUM(CASE rental_rate
	WHEN 0.99 THEN 1
	ELSE 0
END) AS number_of_bargains
FROM film;

-- (get several CASE columns)
SELECT
SUM(CASE rental_rate
	WHEN 0.99 THEN 1
	ELSE 0
END) AS bargains,
SUM(CASE rental_rate
	WHEN 2.99 THEN 1
	ELSE 0
END) AS regular,
SUM(CASE rental_rate
	WHEN 4.99 THEN 1
	ELSE 0
END) AS premium
FROM film;

/*START****************************************************************************************************************/
/*CHALLENGE 1: Compare the various amounts of films per movie rating. Use CASE and the dvdrental database             */
SELECT DISTINCT(rating) FROM film;

SELECT
SUM(CASE rating
	WHEN 'R' THEN 1
	ELSE 0
END) AS R,
SUM(CASE rating
	WHEN 'NC-17' THEN 1
	ELSE 0
END) AS NC17,
SUM(CASE rating
	WHEN 'G' THEN 1
	ELSE 0
END) AS "G",
SUM(CASE rating
	WHEN 'PG' THEN 1
	ELSE 0
END) AS PG,
SUM(CASE rating
	WHEN 'PG-13' THEN 1
	ELSE 0
END) AS PG13
FROM film;
/*END******************************************************************************************************************/

-- COALESCE (returns the 1st argument that is NOT NULL)
-- Used often to query tables with NULL values and replacing it with values
-- SELECT item, (price - discount) AS final FROM table
-- Could be that discount is null!
-- SELECT item, (price - COALESCE(discount,0)) AS final FROM table

-- CAST (datatype conversion)
SELECT CAST('5' AS INTEGER) AS new_int;
-- OR
SELECT '5'::INTEGER;

-- (count the digits in inventory_id, i.e., length of String)
SELECT * FROM rental;
SELECT CHAR_LENGTH(CAST(inventory_id AS VARCHAR)) FROM rental

-- NULLIF (returns NULL if both arguments are equal, otherwise returns argument 1)
-- Used often when a NULL value would cause an error
CREATE TABLE depts(
	first_name VARCHAR(50),
	department VARCHAR(50)
);

INSERT INTO depts(first_name,department)
VALUES
('Vinton','A'),
('Lauren','A'),
('Claire','B');

SELECT * FROM depts;

-- (check male to female ratio)
SELECT
SUM(CASE WHEN (department = 'A') THEN 1	ELSE 0 END) / -- division!!!
SUM(CASE WHEN (department = 'B') THEN 1	ELSE 0 END)
AS department_ratio
FROM depts;

-- (now the person from department B left...)
DELETE FROM depts
WHERE department = 'B';
SELECT * FROM depts;

-- (division by ZERO!!!)
-- NULLIF USAGE HERE!!!
SELECT
SUM(CASE WHEN (department = 'A') THEN 1	ELSE 0 END) /          -- division
NULLIF(SUM(CASE WHEN (department = 'B') THEN 1 ELSE 0 END),0) -- return NULL if this SUM is 0
AS department_ratio
FROM depts;

DROP TABLE depts;

-- VIEWS (avoid performing the same query every time)
SELECT * FROM customer;
SELECT * FROM address;

-- (we always need customer names and address! Let us save this query!)
SELECT first_name,last_name,address FROM customer
INNER JOIN address
ON customer.address_id = address.address_id;

CREATE VIEW customer_info AS
SELECT first_name,last_name,address FROM customer
INNER JOIN address
ON customer.address_id = address.address_id;

SELECT * FROM customer_info;

-- (Edit our view to add district column)
CREATE OR REPLACE VIEW customer_info AS
SELECT first_name,last_name,address,district FROM customer
INNER JOIN address
ON customer.address_id = address.address_id;

SELECT * FROM customer_info;

-- (Rename a View)
ALTER VIEW IF EXISTS customer_info RENAME TO c_info;

SELECT * FROM c_info;

-- (Drop View)
DROP VIEW c_info;

-- IMPORTING AND EXPORTING DATA
-- https://stackoverflow.com/questions/2987433/how-to-import-csv-file-data-into-a-postgresql-table
-- https://www.enterprisedb.com/postgres-tutorials/how-import-and-export-data-using-csv-files-postgresql
-- https://stackoverflow.com/questions/21018256/can-i-automatically-create-a-table-in-postgresql-from-a-csv-file-with-headers

-- Importing data will NOT create a table for you. It must be created before importing.
-- Right-click table and select "Import/Export"
CREATE TABLE imported(
	a INTEGER,
	b INTEGER,
	c INTEGER
);

SELECT * FROM imported;

DROP TABLE imported;