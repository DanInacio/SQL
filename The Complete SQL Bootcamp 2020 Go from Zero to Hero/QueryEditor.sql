/*SELECT > DISTINCT()/COUNT()/ > AS > FROM > WHERE > BETWEEN/IN/LIKE/ILIKE > GROUP BY > HAVING > ORDER BY > LIMIT*/

-- SELECT
SELECT * FROM film;                     /*All columns from table film*/
SELECT * FROM actor;                    /*All columns from table actor*/

SELECT first_name,last_name FROM actor; /*Specific columns from a table*/
SELECT last_name,first_name FROM actor; /*Specific columns from a table (changed order)*/

/*START****************************************************************************************************************/
/*CHALLENGE 1: Send an email to our existing customers
	I will need first and last names and their email for this...*/
SELECT * FROM customer;
SELECT first_name,last_name,email FROM customer;
/*END******************************************************************************************************************/

-- SELECT DISTINCT (gets only unique values)
SELECT DISTINCT (release_year) FROM film; /*How many different release years are there in the film table?*/
SELECT DISTINCT (rental_rate) FROM film;  /*How many different rental rates are there in the film table?*/

/*START****************************************************************************************************************/
/*CHALLENGE 2: What types of movie ratings are there in our DB?*/
SELECT DISTINCT(rating) FROM film;
/*END******************************************************************************************************************/

-- COUNT (get number of rows matching condition)
SELECT COUNT(*) FROM film;         /*Number of rows in table*/
SELECT COUNT(amount) FROM payment; /*Number of rows in table*/

SELECT amount FROM payment;
SELECT DISTINCT(amount) FROM payment;        /*Unique payment types*/
SELECT COUNT(DISTINCT(amount)) FROM payment; /*Number of unique payment types*/

-- SELECT WHERE + AND/OR/NOT (specify conditions)
SELECT * FROM customer;
SELECT * FROM customer WHERE first_name='Jared'; /*Who is named Jared?*/

SELECT * FROM film;                                 /*SELECT DISTINCT(rental_rate) FROM film -> A double-check...*/
SELECT * FROM film WHERE rental_rate>4.00;          /*All rental rates higher than 4 dollars*/
SELECT * FROM film WHERE replacement_cost >= 19.99; /*All films with replacement cost >= than 19.99*/

SELECT * FROM film WHERE rental_rate>4.00 AND replacement_cost >= 19.99;                  /*2 conditions*/
SELECT * FROM film WHERE rental_rate>4.00 AND replacement_cost >= 19.99 AND rating = 'R'; /*3 conditions*/

SELECT title FROM film
WHERE rental_rate>4.00 AND replacement_cost >= 19.99 AND rating = 'R'; /*3 conditions, 1 column*/

SELECT COUNT(title) FROM film
WHERE rental_rate>4.00 AND replacement_cost >= 19.99 AND rating = 'R'; /*3 conditions, number of rows*/

SELECT COUNT(*) FROM film WHERE rating='R' OR rating='PG-13';          /*Number of movies with specific ratings*/
SELECT * FROM film WHERE rating !='R';                                 /*Non R-rated movies*/

/*START****************************************************************************************************************/
/*CHALLENGE 3:
3.1. What is the email for Nancy Thomas?
3.2. Description for movie Outlaw Hanky?
3.3. Phone number for customer who lives at 259 Ipoh Drive?*/
SELECT * FROM customer;
SELECT email FROM customer WHERE first_name='Nancy' AND last_name='Thomas';

SELECT * FROM film;
SELECT description FROM film WHERE title='Outlaw Hanky';

SELECT * FROM address;
SELECT phone FROM address WHERE address='259 Ipoh Drive';
/*END******************************************************************************************************************/

-- ORDER BY (reorder rows)
SELECT * FROM customer;
SELECT * FROM customer ORDER BY first_name ASC;          /*Order by first name*/
SELECT * FROM customer ORDER BY store_id,first_name ASC; /*Order by store, then by first name*/

SELECT store_id,first_name,last_name FROM customer
ORDER BY store_id ASC,first_name ASC;                    /*Same as above, but only specific columns*/

SELECT store_id,first_name,last_name FROM customer
ORDER BY store_id DESC,first_name ASC;                   /*Last store first, first_name ordered*/

SELECT first_name,last_name FROM customer
ORDER BY store_id DESC,first_name ASC;                   /*The order column does NOT need to be in your search!*/

-- LIMIT(limit rows returned)
SELECT * FROM payment
WHERE amount != 0.00
ORDER BY payment_date DESC
LIMIT 10;                  /*10 most recent purchases, where amount was NOT zero*/

/*START****************************************************************************************************************/
/*CHALLENGE 4:
4.1. Customer IDs of the first 10 paying customers?
4.2. Customer wants to watch a short movie during lunch. Titles of the 5 shortest movies?
4.3. If the previous customer can watch any movie that is 50 minutes or less, how many options does he have?
*/
SELECT * FROM payment;
SELECT customer_id,payment_date FROM payment
ORDER BY payment_date ASC
LIMIT 10;

SELECT * FROM film;
SELECT title,"length" FROM film
ORDER BY "length" ASC
LIMIT 5;

SELECT COUNT(title) FROM film
WHERE "length" <= 50;
/*END******************************************************************************************************************/

-- BETWEEN (returns values between 2 limits)
SELECT * FROM payment LIMIT 2;

SELECT * FROM payment WHERE amount BETWEEN 8 AND 9;        /*value >= low AND value <= high*/
SELECT COUNT(*) FROM payment WHERE amount BETWEEN 8 AND 9; /*number of rows of previous command*/

SELECT * FROM payment WHERE amount NOT BETWEEN 8 AND 9;        /*value < low AND value > high*/
SELECT COUNT(*) FROM payment WHERE amount NOT BETWEEN 8 AND 9; /*number of rows of previous command*/

SELECT * FROM payment
WHERE payment_date BETWEEN '2007-02-01' AND '2007-02-15'; /*Payments during the 1st half of the month*/
SELECT * FROM payment
WHERE payment_date BETWEEN '2007-02-01' AND '2007-02-14'; /*Up to 2007-02-14 00:00:00.000000 -> NO DATA!*/

-- IN (checks for value in a list of options)
SELECT * FROM payment LIMIT 2;
SELECT DISTINCT(amount) FROM payment ORDER BY amount DESC; /*What are the unique amount values?*/

SELECT * FROM payment
WHERE amount = 0.99 OR amount = 1.98 OR amount = 1.99; /*Return values 0.99,1.98,1.99*/
SELECT * FROM payment
WHERE amount IN(0.99,1.98,1.99);                       /*Return values 0.99,1.98,1.99 FASTER*/
SELECT * FROM payment
WHERE amount NOT IN(0.99,1.98,1.99);                   /*Return values NOT 0.99,1.98,1.99*/

SELECT * FROM customer
WHERE first_name IN('John','Jake','Julie');            /*No Jake... Returns 2 results*/

-- LIKE (case-sensitive) and ILIKE(case-insensitive) (find patterns, not complete strings)
SELECT * FROM customer
WHERE first_name LIKE 'J%';                           /* % -> Matches any sequence of characters*/ 
SELECT * FROM customer
WHERE first_name LIKE 'J%' AND last_name LIKE 'S%';   /*First Name starts with 'J', Last Name starts with 'S'*/
SELECT * FROM customer
WHERE first_name ILIKE 'j%';
SELECT * FROM customer
WHERE first_name ILIKE 'j%' AND last_name ILIKE 's%';

SELECT * FROM customer
WHERE first_name ILIKE '%er%';                        /*ER somewhere in the first name*/

SELECT * FROM customer
WHERE first_name ILIKE '_her%';                       /* _ -> Matches any SINGLE character*/
SELECT * FROM customer
WHERE first_name NOT ILIKE '_her%';                   /* _ -> Matches any SINGLE character*/

SELECT * FROM customer
WHERE first_name LIKE 'A%' AND last_name NOT LIKE 'B%'
ORDER BY last_name;

/*START****************************************************************************************************************/
/*                                               GENERAL CHALLENGE 1                                                  */
/*1. How many payment transactions were greater than 5 dollars?                                                       */
/*2. How many actors have a first name that starts with the letter 'P'?                                               */
/*3. How many unique districts are our customers from?                                                                */
/*4. Retrieve the list of names for those distinct districts from question 3                                          */
/*5. How many films have a rating of R and a replacement cost between 5 and 15 dollars?                               */
/*6. How many films have the word Truman somewhere in the title?                                                      */

SELECT * FROM payment LIMIT 2;
SELECT COUNT(*) FROM payment
WHERE amount > 5.00;

SELECT * FROM actor LIMIT 2;
SELECT COUNT(*) FROM actor
WHERE first_name LIKE 'P%';

SELECT * FROM address LIMIT 2;
SELECT COUNT(DISTINCT(district)) FROM address;

SELECT * FROM address LIMIT 2;
SELECT DISTINCT(district) FROM address;

SELECT * FROM film LIMIT 2;
SELECT COUNT(*) FROM film
WHERE rating = 'R' AND replacement_cost BETWEEN 5.00 AND 15.00;

SELECT * FROM film LIMIT 2;
SELECT COUNT(title) FROM film
WHERE title LIKE '%Truman%';
/*END******************************************************************************************************************/

-- AGGREGATE FUNCTIONS (https://www.postgresql.org/docs/9.5/functions-aggregate.html)
SELECT MIN(replacement_cost) FROM film;
SELECT MAX(replacement_cost) FROM film;
SELECT MIN(replacement_cost),MAX(replacement_cost) FROM film;

SELECT COUNT(*) FROM film;

SELECT ROUND(AVG(replacement_cost),3) FROM film;

SELECT SUM(replacement_cost) FROM film;

--SELECT MAX(replacement_cost),film_id FROM film; /*DOES NOT WORK!!! Calling a single value and 1 column!!!*/

-- GROUP BY (aggregate columns, to be able to call single values and columns)
SELECT * FROM payment;

SELECT customer_id FROM payment
GROUP BY customer_id;                       /*DISTINCT() function...*/

SELECT customer_id,SUM(amount) FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC;                  /*Total paid per customer, ordered by best customers*/

SELECT customer_id,COUNT(amount) FROM payment
GROUP BY customer_id
ORDER BY COUNT(amount) DESC;                /*Number of transactions per customer*/

SELECT customer_id,staff_id,SUM(amount) FROM payment
GROUP BY staff_id,customer_id
ORDER BY customer_id;                       /*Total paid per customer, per each staff member*/

SELECT DATE(payment_date),SUM(amount) FROM payment  /*Removes timestamp from date!!!*/
GROUP BY DATE(payment_date)
ORDER BY SUM(amount) DESC;                          /*View dates where most money was spent*/

/*START****************************************************************************************************************/
/*CHALLENGE 5:
5.1. How many payments did each staff member handle and who gets the bonus?
5.2. Average replacement cost per rating?
5.3. Customer IDs of the top 5 customers bjy total spent?
*/
SELECT * FROM payment;
SELECT staff_id,COUNT(amount) FROM payment
GROUP BY staff_id;

SELECT * FROM film;
SELECT rating,ROUND(AVG(replacement_cost),2) FROM film
GROUP BY rating;

SELECT * FROM payment;
SELECT customer_id,SUM(amount) FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 5;
/*END******************************************************************************************************************/

-- HAVING (filter results AFTER an aggregation - WHERE filters BEFORE)
SELECT * FROM payment LIMIT 2;
SELECT customer_id,SUM(amount) FROM payment
WHERE customer_id NOT IN(184,47,477)
GROUP BY customer_id
HAVING SUM(amount) > 100;

SELECT * FROM customer LIMIT 2;
SELECT store_id,COUNT(customer_id) FROM customer
GROUP BY store_id
HAVING COUNT(customer_id) > 300;

/*START****************************************************************************************************************/
/*CHALLENGE 6:
6.1. Which customers have had 40 or more transaction payments?
6.2. What are the customer_ids of customers who spent more than 100 dollars with staff_id 2?
*/
SELECT * FROM payment;
SELECT customer_id,COUNT(amount) FROM payment
GROUP BY customer_id
HAVING COUNT(amount) >= 40;

SELECT * FROM payment;
SELECT customer_id,SUM(amount) FROM payment
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount) > 100;
/*END******************************************************************************************************************/

/*START****************************************************************************************************************/
/*                                               ASSESSMENT TEST 1                                                    */
/*1. Return the customer IDs of customers who have spent at least 110 dollars with staff member 2                     */
/*2. How many films begin with the letter 'J'?                                                                        */
/*3. What customer has the highest customer ID number whose first name starts with 'E' and address ID lower than 500? */
SELECT * FROM payment;
SELECT customer_id,SUM(amount) FROM payment
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount) > 110.00;

SELECT * FROM film;
SELECT COUNT(title) FROM film
WHERE title LIKE 'J%';

SELECT * FROM customer;
SELECT first_name,last_name FROM customer
WHERE first_name LIKE 'E%' AND address_id < 500
ORDER BY customer_id DESC
LIMIT 1;
/*END******************************************************************************************************************/

-- AS statement
SELECT amount AS rental_price FROM payment; -- View column with different name!
SELECT SUM(amount) AS net_revenue FROM payment;

SELECT COUNT(amount) FROM payment;
SELECT COUNT(amount) AS num_transactions FROM payment;

SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id;

SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 100; -- NOTICE the rename to total_spent happens at the very end!!!

SELECT customer_id, amount AS value_of_purchase
FROM payment
WHERE amount > 2.00;

-- INNER JOIN (common data between 2 tables - table order does NOT MATTER!)
SELECT * FROM payment
INNER JOIN customer
ON payment.customer_id = customer.customer_id; -- Shows all columns of both tables!

SELECT payment_id, payment.customer_id, first_name
FROM payment
INNER JOIN customer
ON payment.customer_id = customer.customer_id; -- payment.customer_id because column is in both tables!

-- FULL OUTER JOIN (data unique to both tables AND common to both, i.e., grabs everything)
SELECT * FROM customer
FULL OUTER JOIN payment
ON customer.customer_id = payment.customer_id;

-- (For only the data unique to both tables, specify 1 of the tables should be null!)
SELECT * FROM customer
FULL OUTER JOIN payment
ON customer.customer_id = payment.customer_id
WHERE customer.customer_id IS null OR payment.payment_id IS null; -- No result! All data with customer has payments!

-- LEFT OUTER JOIN (only data unique to left table or in both)
SELECT * FROM film;
SELECT * FROM inventory;

SELECT film.film_id, title, inventory_id, store_id
FROM film
LEFT OUTER JOIN inventory
ON film.film_id = inventory.film_id; -- 4623 rows

-- (For only the data unique to left table, specify right table should be null!)
SELECT film.film_id, title, inventory_id, store_id
FROM film
LEFT OUTER JOIN inventory
ON film.film_id = inventory.film_id
WHERE inventory.film_id IS null; -- 42 rows

-- RIGHT JOIN (only data unique to right table or in both - simply a reverse of the previous queries)
-- (For only the data unique to right table, specify left table should be null!)

-- UNION (combine 2 or more SELECT statements)

/*START****************************************************************************************************************/
/*CHALLENGE 7:
7.1. What are the emails of the customers who live in California?
7.2. List of all the movies Nick Wahlberg has been in?
*/
SELECT * FROM customer;
SELECT * FROM address; -- district should be California!

SELECT email, district
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
WHERE district = 'California';

SELECT * FROM film;
SELECT * FROM actor;
SELECT * FROM film_actor;

-- Notice for 7.2, there is NO COMMON COLUMN!!! 2 JOINS in 1 QUERY
SELECT title, first_name, last_name FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
INNER JOIN actor
ON actor.actor_id = film_actor.actor_id
WHERE first_name = 'Nick' AND last_name = 'Wahlberg';
/*END******************************************************************************************************************/

-- TIMESTAMPS and EXTRACT: Display current date/time information
SHOW ALL;            -- shows parameters/settings
SHOW TIMEZONE;       -- timezone
SELECT NOW();        -- current date and time
SELECT TIMEOFDAY();  -- current date and time as Text
SELECT CURRENT_DATE;
SELECT CURRENT_TIME;

-- TIMESTAMPS and EXTRACT: Format date/time information
      -- EXTRACT() lets you "extract" a sub-component of a date value
      -- AGE() returns current age, given a timestamp
      -- TO_CHAR() convert data types to text
SELECT * FROM payment;

SELECT EXTRACT(YEAR FROM payment_date) AS "Year"
FROM payment;
SELECT EXTRACT(MONTH FROM payment_date) AS "Month"
FROM payment;
SELECT EXTRACT(QUARTER FROM payment_date) AS "Quarter"
FROM payment;

SELECT AGE(payment_date)
FROM payment;

SELECT TO_CHAR(payment_date,'dd-mm-yyyy')
FROM payment;

/*START****************************************************************************************************************/
/*CHALLENGE 8:
8.1. During which months did payments occur? Format your answer to return the full month name!
8.2. How many payments occurred on a Monday?
*/
SELECT * FROM payment;
SELECT EXTRACT(MONTH FROM payment_date) AS "Month" FROM payment;
SELECT DISTINCT(EXTRACT(MONTH FROM payment_date)) AS "Month" FROM payment;

SELECT DISTINCT(TO_CHAR(payment_date,'MONTH')) AS "Month"
FROM payment;

SELECT * FROM payment;
SELECT EXTRACT(DOW FROM payment_date) FROM payment;

SELECT COUNT(*) FROM payment
WHERE EXTRACT(DOW FROM payment_date) = 1;
/*END******************************************************************************************************************/

-- MATH FUNCTIONS AND OPERATORS
SELECT * FROM film;

SELECT ROUND(rental_rate/replacement_cost,4)*100 AS percentage_cost
FROM film; -- What percentage of replacement_cost is the rental_rate?

SELECT 0.1*replacement_cost AS deposit
FROM film; -- Deposit of 10% for the replacement_cost

-- STRING FUNCTIONS AND OPERATORS
SELECT * FROM customer;

SELECT LENGTH(first_name) FROM customer;                                 -- Length
SELECT first_name || ' ' || last_name AS full_name FROM customer;        -- Concatenation
SELECT UPPER(first_name || ' ' || last_name) AS full_name FROM customer; -- UpperCase
SELECT LEFT(first_name,1) FROM customer;                                 -- Left

-- (building email column)
SELECT LOWER(first_name || '.' || last_name || '@sakilacustomer.org') AS email
FROM customer;

-- SUBQUERY and EXISTS
SELECT * FROM film;

-- (films with a rental_rate higher than the average rental_rate)
SELECT title, rental_rate FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film);

-- (if your subquery returns multiple values, use IN to check the list of values!)
-- (check film titles returned between two rental dates)
SELECT * FROM rental;
SELECT * FROM inventory;

SELECT * FROM rental
WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30';

SELECT inventory.film_id
FROM rental
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30' -- Only IDs, no titles
-- Take this query as a subquery, as shown below

SELECT film.title FROM film
WHERE film_id IN
(SELECT inventory.film_id
FROM rental
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30')
ORDER BY film_id; -- DONE!

-- EXISTS OPERATOR
-- (find customers with 1 payment greater than 11 dollars and return first and last name)
-- (you can also use NOT EXISTS to find the opposite!)
SELECT first_name, last_name
FROM customer AS "c"
WHERE EXISTS
(SELECT * FROM payment AS "p"
 WHERE p.customer_id = c.customer_id
 AND amount > 11);

-- SELF-JOIN (A join of 2 copies of the same table)
SELECT * FROM film;

-- (what PAIRS of films have the same length -> matching within the same table!)
-- (My Attempt at Self-Join without any pairs)
SELECT film_alias.title,film."length" FROM film AS film_alias
JOIN film
ON film_alias.film_id = film.film_id
ORDER BY "length";

-- (Correct Answer)
SELECT f1.title, f2.title, f1.length
FROM film AS f1
INNER JOIN film AS f2
ON f1.film_id = f2.film_id AND f1.length = f2.length; -- NO! This is getting the same film from the same table twice!

SELECT f1.title, f2.title, f1.length
FROM film AS f1
INNER JOIN film AS f2
ON f1.film_id != f2.film_id AND f1.length = f2.length; -- Ensure movie id is all but itself

/*START****************************************************************************************************************/
/*                                               ASSESSMENT TEST 2                                                    */
/*THIS EXERCISE REQUIRES A NEW DATABASE WITHIN exercises.tar                                                          */
/*Due to several schemas, use cd.TableName                                                                            */
/*                                                                                                                    */
/*1. Retrieve all the information from the Facilities table                                                           */
/*2. Retrieve a list of all facility names and member costs                                                           */
/*3. Retrieve a list of facilities that charge a fee to members                                                       */
/*4. Retrieve a list of facilities that charge a fee to members and fee is less than 1/50th of the maintenance cost   */
/*         Return the facility id, facility name, member cost and monthly maintenance                                 */
/*5. Retrieve a list of facilities with the word 'Tennis' in their names                                              */
/*6. Retrieve details of facilities with ID 1 and 5 using the OR operator                                             */
/*7. Retrieve a list of members who joined after the start of September 2012                                          */
/*         Return the member id, surname, first name and join date                                                    */
/*8. Retrieve an ordered list of the first 10 surnames in the members table, without duplicates                       */
/*9. Get the signup date of your last member                                                                          */
/*10. Count the number of facilities that have a cost to guests of 10 dollars or more                                 */
/*11. Retrieve a list of the total number of slots booked per facility in the month of September 2012                 */
/*         Return facility id and slots, sorted by number of slots ascending                                          */
/*12. Retrieve a list of facilities with more than 1000 slots booked.                                                 */
/*         Return facility id and slots, sorted by facility id                                                        */
/*13. Retrieve a list of the start times for bookings for tennis courts, for the date '2012-09-21'                    */
/*         Return start time and facility name pairings, ordered by the time ascending                                */
/*14. Retrieve a list of the start times for bookings by members named 'David Farrell'                                */

-- 1.
SELECT * FROM cd.facilities;

-- 2.
SELECT "name", membercost FROM cd.facilities;

-- 3.
SELECT * FROM cd.facilities
WHERE membercost > 0;

-- 4.
SELECT facid, "name", membercost, monthlymaintenance FROM cd.facilities
WHERE (membercost > 0) AND (membercost < monthlymaintenance/50.0);

-- 5.
SELECT * FROM cd.facilities
WHERE "name" ILIKE '%Tennis%';

-- 6.
SELECT * FROM cd.facilities
WHERE facid = 1 OR facid = 5; -- without OR, you could use -> WHERE facid IN (1,5)

-- 7.
SELECT memid, surname, firstname, joindate FROM cd.members
WHERE joindate >= '2012-09-01 00:00:00';

-- 8.
SELECT DISTINCT(surname) FROM cd.members
ORDER BY surname ASC
LIMIT 10;

-- 9.
SELECT joindate FROM cd.members -- you could also use -> SELECT MIN(joindate) FROM cd.members
ORDER BY joindate DESC
LIMIT 1;

-- 10.
SELECT COUNT("name") FROM cd.facilities
WHERE guestcost >= 10;

-- 11.
SELECT facid, SUM(slots) FROM cd.bookings
WHERE (EXTRACT(YEAR FROM starttime) = 2012) AND (EXTRACT(MONTH FROM starttime) = 9)
-- OR
-- WHERE starttime >= '2012-09-01' AND starttime <= '2012-10-01'
GROUP BY facid
ORDER BY SUM(slots) ASC;

-- 12.
SELECT facid, SUM(slots) FROM cd.bookings
GROUP BY facid
HAVING SUM(slots) > 1000
ORDER BY facid ASC;

-- 13.
SELECT starttime, "name" FROM cd.bookings
INNER JOIN cd.facilities
ON cd.bookings.facid = cd.facilities.facid
WHERE (DATE(starttime) = '2012-09-21') AND ("name" ILIKE '%Tennis Court%')
ORDER BY starttime ASC;

-- 14.
SELECT starttime FROM cd.bookings
INNER JOIN cd.members
ON cd.bookings.memid = cd.members.memid
WHERE (surname ILIKE '%Farrell%') AND (firstname ILIKE '%David%')
/*END******************************************************************************************************************/