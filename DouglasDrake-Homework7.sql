-- Homework 09 - SQL Douglas Drake --

USE sakila;

-- 1a --
SELECT first_name, last_name FROM actor;
  
-- 1b --
SELECT UPPER(CONCAT(first_name,' ',last_name)) AS `Actor Name` FROM actor;

-- 2a --
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

-- 2b --
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';
    
-- 2c --
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name like '%LI%'
ORDER BY last_name, first_name;
    
-- 2d --
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
    
-- 3a --
ALTER TABLE actor
ADD COLUMN description BLOB AFTER last_name;

-- 3b --
ALTER TABLE actor
DROP COLUMN description;

-- 4a --
SELECT last_name, COUNT(*) AS frequency
FROM actor
GROUP BY last_name;

-- 4b --
SELECT last_name, COUNT(*) AS frequency
FROM actor
GROUP BY last_name
HAVING frequency >= 2;

-- Lookup GROUCHO WILLIAMS --
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4c --
UPDATE actor 
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
    
-- Lookup the change we just made --
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';
    
-- 4d --
UPDATE actor 
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 5a --
SHOW CREATE TABLE address;

-- 6a --
# Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address
SELECT 
    staff.first_name, staff.last_name, address.address
FROM
    address
        INNER JOIN
    staff ON staff.address_id = address.address_id;

SHOW CREATE TABLE payment;

-- 6b --
# Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment
SELECT 
    staff.staff_id,
    CONCAT(first_name, ' ', last_name) AS `Employee`,
    SUM(amount) AS `Total Amount`
FROM
    staff
        INNER JOIN
    payment ON staff.staff_id = payment.staff_id
WHERE MONTH(payment.payment_date) = 8 AND YEAR(payment.payment_date) = 2005 
GROUP BY staff.staff_id;

-- 6c --
# List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT 
    title AS `Film Title`, COUNT(actor_id) AS `Number of Actors`
FROM
    film
        INNER JOIN
    film_actor ON film.film_id = film_actor.film_id
GROUP BY film.film_id;

-- 6d --
# How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(film_id) FROM inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');

-- 6e --
# Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name
SELECT 
    first_name,
    last_name,
    SUM(amount) AS `Total Amount Paid`
FROM
    customer
        INNER JOIN
    payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY last_name;

-- 7a --
/* The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles 
of movies starting with the letters K and Q whose language is English. */

SELECT title
FROM film
WHERE film_id IN
(
	SELECT film_id
    FROM film
    WHERE title LIKE 'Q%' or title LIKE 'K%'
) AND film_id IN
(
	SELECT film_id 
    FROM film
    WHERE language_id IN
    (
		SELECT language_id
        FROM language
        WHERE name = 'English'
	)
);

-- 7b --
# Use subqueries to display all actors who appear in the film Alone Trip.

SELECT CONCAT(first_name, ' ', last_name) AS `Actor`
FROM actor
WHERE actor_id IN
(
	# Grab the actor_ids for actors in Alone Trip
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN
	(
		# Grab the film_id for Alone Trip
		SELECT film_id
		FROM film
		WHERE title = 'Alone Trip'
	)
);

-- 7c --
# This can be done with sub-queries.
SELECT
	CONCAT(first_name, ' ', last_name) AS `Customer Name`,
    email
FROM customer
WHERE address_id IN
(
	SELECT address_id
	FROM address
	WHERE city_id IN
	(
		SELECT city_id
		FROM city
		WHERE country_id IN
		(
			SELECT country_id
			FROM country
			WHERE country = 'Canada'
		)
	)
);

# Now do this with joins --
SELECT
	CONCAT(first_name, ' ', last_name) AS `Customer Name`,
    email
FROM customer JOIN (address JOIN (city JOIN country USING (country_id)) USING (city_id)) USING (address_id)
WHERE country = 'Canada';

-- 7d --
# Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title AS `Title`
FROM film
WHERE film_id IN
(
	SELECT film_id
    FROM film_category
    WHERE category_id IN
    (
		SELECT category_id
        FROM category
        WHERE name = 'Family'
	)
);

-- 7e --
# Display the most frequently rented movies in descending order.
SELECT title, COUNT(*) AS `Rental Frequency`
FROM
	film
		JOIN (inventory JOIN rental USING (inventory_id))
	USING (film_id)
GROUP BY title
ORDER BY `Rental Frequency` DESC;

-- 7f --
# Write a query to display how much business, in dollars, each store brought in
SELECT store_id, SUM(amount)
FROM store JOIN (customer JOIN (payment JOIN rental USING (rental_id)) ON customer.customer_id = payment.customer_id) USING (store_id) 
GROUP BY store_id;

-- 7g --
# Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country
FROM store JOIN (address JOIN (city JOIN country USING (country_id)) USING (city_id)) USING (address_id);

-- 7h --
# List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT name, category_id, SUM(amount) as `Gross Revenue` FROM
payment JOIN (rental JOIN (inventory JOIN (film_category JOIN category USING (category_id)) USING (film_id)) USING (inventory_id)) USING (rental_id)
GROUP BY category_id
ORDER BY `Gross Revenue` DESC
LIMIT 5;

-- 8a --
# Create a view of the last query.
CREATE VIEW `Top Five Genres` AS
SELECT name, category_id, SUM(amount) as `Gross Revenue` FROM
payment JOIN (rental JOIN (inventory JOIN (film_category JOIN category USING (category_id)) USING (film_id)) USING (inventory_id)) USING (rental_id)
GROUP BY category_id
ORDER BY `Gross Revenue` DESC
LIMIT 5;

-- 8b --
# Showing the view we just created:
SELECT * FROM `Top Five Genres`;

-- 8c --
# Dropping the view from the database
DROP VIEW `Top Five Genres`;
