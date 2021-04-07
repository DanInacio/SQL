/*SELECT TASKS*/
/*1. Students between ages of 18 and 20*/
SELECT student_name,age FROM students
WHERE age BETWEEN 18 AND 20;

/*2. Students with letters "ch" in name or name ends with "nd"*/
SELECT student_name FROM students
WHERE student_name ILIKE '%ch%' OR student_name ILIKE '%nd';

/*3. Students with letters "ae" or "ph" in name and are NOT 19 years old*/
SELECT student_name FROM students
WHERE (student_name ILIKE '%ae%' OR student_name ILIKE '%ph%') AND (age != 19);

/*4. Sort students by age from largest to smallest*/
SELECT student_name FROM students
ORDER BY age DESC;

/*5. Names and ages of top 4 oldest students*/
SELECT student_name,age FROM students
ORDER BY age DESC
LIMIT 4;

/*6. Student must not be older than 20 if their student_no is between 3 and 5 or student_no is 7.
     Students older than 20 must have a student_no that is at least 4*/
SELECT * FROM students
WHERE (age < 20 AND student_no BETWEEN 3 AND 5)
   OR (student_no = 7)
   OR (age >20 AND student_no >= 4);
   
/*CONDITIONAL/CONCATENATION/BOOLEAN TASKS*/
/*1. Output the sentence: Chong works in the Science department*/
SELECT CONCAT(last_name,' works in the ',department,' department') FROM professors;

/*2. Output the sentences: It is true/false that professor ... is highly paid. Threshold is 95000*/
SELECT CONCAT('It is ', (salary>95000), ' that professor ', last_name, ' is highly paid') FROM professors;

/*3. Shorten the department name to the first 3 characters in UPPER case*/
SELECT last_name,UPPER(LEFT(department,3)) AS department, salary, hire_date from professors;
-- OR substring(department,1,3) AS department

/*4. Highest and lowest salary excluding 'Wilson'*/
SELECT MAX(salary) AS highest_salary,
       MIN(salary) AS lowest_salary FROM professors
WHERE last_name != 'Wilson';

/*5. Hire date of oldest professor*/
SELECT hire_date FROM professors
ORDER BY hire_date ASC
LIMIT 1;
-- OR MIN(hire_date)

/*GROUP BY TASKS: LOAD FRUIT DATA FIRST!*/
SELECT * FROM fruit_imports;
/*1. State with largest amount of fruit supply*/
SELECT "state" FROM fruit_imports
GROUP BY "state"
ORDER BY SUM(supply) DESC
LIMIT 1;

/*2. Most expensive cost_per_unit of every season*/
SELECT season, MAX(cost_per_unit) FROM fruit_imports
GROUP BY season;

/*3. State that has more than 1 import of the same fruit*/
SELECT "state" FROM fruit_imports
GROUP BY "state", "name"
HAVING COUNT("name") > 1;

/*4. Seasons with 3 or 4 fruits*/
SELECT season FROM fruit_imports
GROUP BY season
HAVING COUNT("name") = 3 OR COUNT("name") = 4;

/*5. Use supply and cost_per_unit to determine the total cost and return the most expensive state*/
SELECT "state", SUM(supply*cost_per_unit) AS total_cost FROM fruit_imports
GROUP BY "state"
ORDER BY total_cost DESC
LIMIT 1;

/*6. Run the script below and write a query that returns the count of 4*/
CREATE TABLE fruits(fruit_name varchar(10));
INSERT INTO fruits VALUES('Orange');
INSERT INTO fruits VALUES('Apple');
INSERT INTO fruits VALUES(NULL);
INSERT INTO fruits VALUES(NULL);

SELECT COUNT(COALESCE(fruit_name,'SOME VALUE...')) FROM fruits;
-- OR
SELECT COUNT(*) FROM fruits;

/*SUBQUERIES TASKS*/
/*1. Is students table directly related to courses table?*/
SELECT * FROM student_enrollment; -- NO. This is the correlation table!

/*2. Return the names of students taking courses in Physics and US history
     Use subqueries, not JOINs*/
SELECT student_name FROM students
WHERE student_no IN(
	SELECT student_no FROM student_enrollment
	WHERE course_no IN(
		SELECT course_no FROM courses
		WHERE course_title IN('Physics','US History')
	)
);

/*3. Name of student with the highest number of courses*/
SELECT student_name FROM students
WHERE student_no IN(
	SELECT student_no FROM (
		SELECT student_no,COUNT(course_no) AS course_cnt FROM student_enrollment
		GROUP BY student_no
		ORDER BY course_cnt DESC
		LIMIT 1
	)
	a
);

/*4. Find the oldest student without using LIMIT or ORDER BY*/
SELECT * FROM students
WHERE age = (SELECT MAX(age) FROM students);

/*CASE TASKS*/
/*1. Display fruit and total_supply along with category LOW (<20000), ENOUGH, FULL(>50000)*/
SELECT "name", total_supply,
	CASE
		WHEN total_supply < 20000 THEN 'LOW'
		WHEN total_supply BETWEEN 20000 AND 50000 THEN 'ENOUGH'
		WHEN total_supply > 50000 THEN 'FULL'
	END AS category
FROM (SELECT name,SUM(supply) AS total_supply FROM fruit_imports
      GROUP BY "name")a;

/*2. Get total_cost and transpose it using CASE*/
SELECT SUM(CASE WHEN season = 'Winter' THEN total_cost END) AS winter_total,
       SUM(CASE WHEN season = 'Summer' THEN total_cost END) AS summer_total,
	   SUM(CASE WHEN season = 'Spring' THEN total_cost END) AS spring_total,
	   SUM(CASE WHEN season = 'Fall' THEN total_cost END) AS fall_total,
	   SUM(CASE WHEN season = 'All Year' THEN total_cost END) AS year_total
FROM(
	SELECT season,SUM(supply*cost_per_unit) AS total_cost FROM fruit_imports
    GROUP BY season
)a;

/*JOINS, GROUP BY AND SUBQUERIES TASKS*/
/*1. Are student_enrollment and professors directly connected?*/
SELECT * FROM professors; -- No.

/*2. Get student name alphabetically, the courses of the student and the professor teaching the courses*/
SELECT student_name, student_enrollment.course_no, professors.last_name
FROM students
INNER JOIN student_enrollment
ON students.student_no = student_enrollment.student_no
INNER JOIN teach
ON student_enrollment.course_no = teach.course_no
INNER JOIN professors
ON teach.last_name = professors.last_name
ORDER BY student_name;

/*3. Repeat previous query but ignore duplicate student and courses for different teachers*/
SELECT student_name, course_no, MIN(last_name)
FROM(
SELECT student_name, student_enrollment.course_no, professors.last_name
FROM students
INNER JOIN student_enrollment
ON students.student_no = student_enrollment.student_no
INNER JOIN teach
ON student_enrollment.course_no = teach.course_no
INNER JOIN professors
ON teach.last_name = professors.last_name
)a
GROUP BY student_name, course_no
ORDER BY student_name, course_no;

/*4. Return employees whose salary is above average for their department*/
SELECT first_name,last_name FROM employees AS outer_emp
WHERE salary > (
	SELECT AVG(salary) FROM employees
	WHERE department = outer_emp.department
);

/*5. Return ALL students and ANY courses they may or may not be taking*/
SELECT students.student_no, student_name, course_no
FROM students LEFT JOIN student_enrollment
ON students.student_no = student_enrollment.student_no;

/*More data...*/
CREATE TABLE sales
(
	continent varchar(20),
	country varchar(20),
	city varchar(20),
	units_sold integer
);

INSERT INTO sales VALUES ('North America', 'Canada', 'Toronto', 10000);
INSERT INTO sales VALUES ('North America', 'Canada', 'Montreal', 5000);
INSERT INTO sales VALUES ('North America', 'Canada', 'Vancouver', 15000);
INSERT INTO sales VALUES ('Asia', 'China', 'Hong Kong', 7000);
INSERT INTO sales VALUES ('Asia', 'China', 'Shanghai', 3000);
INSERT INTO sales VALUES ('Asia', 'Japan', 'Tokyo', 5000);
INSERT INTO sales VALUES ('Europe', 'UK', 'London', 6000);
INSERT INTO sales VALUES ('Europe', 'UK', 'Manchester', 12000);
INSERT INTO sales VALUES ('Europe', 'France', 'Paris', 5000);