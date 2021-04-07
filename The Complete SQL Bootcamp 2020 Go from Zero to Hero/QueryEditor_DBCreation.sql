/*ONLY RUN EACH BLOCK ONCE!*/

/***CREATE***/
/*Creating a Table*/
CREATE TABLE account(
	user_id SERIAL PRIMARY KEY,           -- user_id will be of SERIAL datatype (a.k.a.: counter) to be the primary key
	username VARCHAR(50) UNIQUE NOT NULL, -- username cannot be longer than 50 characters, must be unique and not-null
	password VARCHAR(50) NOT NULL,
	email VARCHAR(250) UNIQUE NOT NULL,
	created_on TIMESTAMP NOT NULL,
	last_login TIMESTAMP                  -- No NOT NULL since, when a person creates an account, there is no LAST login!
);

/*Creating another Table*/
CREATE TABLE job(
	job_id SERIAL PRIMARY KEY,
	job_name VARCHAR(200) UNIQUE NOT NULL
);

/*Create a table to Link other tables*/
CREATE TABLE account_job(
	user_id INTEGER REFERENCES account(user_id), -- SERIAL should only be used as a primary key for the table that it is in
	job_id INTEGER REFERENCES job(job_id),
	hire_date TIMESTAMP
);

/***INSERT***/
/*Insert data into a table*/
INSERT INTO account(username, password, email, created_on)
VALUES
('Jose','password','jose@mail.com',CURRENT_TIMESTAMP);       -- Insert a row of values

SELECT * FROM account;                                       -- View data

/*Insert data into another table*/
INSERT INTO job(job_name)
VALUES
('astronaut');

INSERT INTO job(job_name)
VALUES
('President');

SELECT * FROM job;

/*Link accounts to jobs*/
INSERT INTO account_job(user_id, job_id, hire_date)
VALUES
(1,1,CURRENT_TIMESTAMP);

SELECT * FROM account_job;

/***UPDATE***/
/*Update a Table*/
SELECT * FROM account;

-- If there is a NULL last_login, set it with CURRENT_TIMESTAMP (i.e., account creation)
UPDATE account
SET last_login = CURRENT_TIMESTAMP;

-- Have Last Login match the Created On Column
UPDATE account
SET last_login = created_on;

/*Update, based on 2 Tables*/
SELECT * FROM account_job;

UPDATE account_job
SET hire_date = account.created_on
FROM account
WHERE account_job.user_id = account.user_id;

/*Return affected rows*/
UPDATE account
SET last_login = CURRENT_TIMESTAMP
RETURNING email,created_on,last_login;

/***DELETE***/
/*Delete a row and Return rows that were removed*/
INSERT INTO job(job_name)
VALUES
('Cowboy');

DELETE FROM job
WHERE job_name = 'Cowboy'
RETURNING job_id,job_name;

/***ALTER***/
CREATE TABLE information(
	info_id SERIAL PRIMARY KEY,
	title VARCHAR(500) NOT NULL,
	person VARCHAR(50) NOT NULL UNIQUE
);

SELECT * FROM information;

/*Rename a Table*/
ALTER TABLE information
RENAME TO new_info;

SELECT * FROM new_info;

/*Rename a Column*/
ALTER TABLE new_info
RENAME COLUMN person TO people;

SELECT * FROM new_info;

/*Change a constraint*/
INSERT INTO new_info(title)
VALUES
('some new title');                -- people column cannot be NULL!!!

ALTER TABLE new_info
ALTER COLUMN people DROP NOT NULL;

INSERT INTO new_info(title)
VALUES
('some new title');                -- you can now insert a title only!

/***DROP***/
/*Drop a Column*/
ALTER TABLE new_info
DROP COLUMN IF EXISTS people;      -- IF EXISTS to avoid an error message

SELECT * FROM new_info;

/***CHECK***/
/*Adds more specific constraints/conditions*/
CREATE TABLE employees(
	emp_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	birthdate DATE CHECK (birthdate > '1900-01-01'),
	hire_date DATE CHECK (hire_date > birthdate),
	salary INTEGER CHECK (salary > 0)
);

INSERT INTO employees(first_name,last_name,birthdate,hire_date,salary)
VALUES
('Jose','Portilla','1899-11-03','2010-01-01',100); -- Constraint FAILURE

INSERT INTO employees(first_name,last_name,birthdate,hire_date,salary)
VALUES
('Jose','Portilla','1990-11-03','2010-01-01',100); -- SUCCESS

INSERT INTO employees(first_name,last_name,birthdate,hire_date,salary)
VALUES
('Sammy','Smith','1990-11-03','2010-01-01',-100); -- Constraint FAILURE

INSERT INTO employees(first_name,last_name,birthdate,hire_date,salary)
VALUES
('Sammy','Smith','1990-11-03','2010-01-01',100); -- SUCCESS

SELECT * FROM employees;

/******************************************************ASSESSMENT TEST 3***************************************************************/
/*1. Create a new database called "school" with 2 tables: teachers and students                                                       */
/*2. students table should have columns for student_id, first_name, last_name, homeroom_number, phone, email and graduation_year      */
/*3. teachers table should have columns for teacher_id, first_name, last_name, homeroom_number, department, email and phone           */
/*4. Constraints are up to you. However, ensure that                                                                                  */
/*      4.1. Phone number must exist, to contact in case of emergency                                                                 */
/*      4.2. IDs must be the primary keys of the tables                                                                               */
/*      4.3. Phone numbers and emails must be unique to the individual                                                                */
/*5. Insert a student Mark Watney (id=1), phone number 777-555-1234 and no email. Graduates in 2035 and has 5 as homeroom number      */
/*5. Insert a teacher Jonas Salk (id=1), phone number 777-555-4321 and email jsalk@school.org                                         */
/*   Has 5 as homeroom number and is from the Biology department                                                                      */

-- 1,2,3,4
CREATE TABLE students(
	student_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	homeroom_number INTEGER NOT NULL,
	phone VARCHAR(50) NOT NULL UNIQUE,
	email VARCHAR(250) UNIQUE,
	graduation_year INTEGER
);

CREATE TABLE teachers(
	teacher_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	homeroom_number INTEGER NOT NULL,
	phone VARCHAR(50) NOT NULL UNIQUE,
	email VARCHAR(250) NOT NULL UNIQUE,
	department VARCHAR(250)
);

-- 5
INSERT INTO students(first_name, last_name, homeroom_number, phone, graduation_year)
VALUES
('Mark','Watney',5,'777-555-1234',2035);
 
INSERT INTO teachers(first_name, last_name, homeroom_number, phone, email, department)
VALUES
('Jonas','Salk',5,'777-555-4321','jsalk@2school.org','Biology');

SELECT * FROM students;
SELECT * FROM teachers;
/*END**********************************************************************************************************************************/