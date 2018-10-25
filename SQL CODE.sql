use sakila; 
 
-- * 1a. Display the first and last names of all actors from the table `actor`.
SELECT 
	first_name 
    , last_name 
FROM 
	actor
; 
-- * 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT 
	CONCAT(actor.first_name, ' ', actor.last_name) as "Actor Name"
FROM 
	actor
;
-- * 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT
	actor_id
    , first_name
    , last_name
FROM 
	actor 
where 
	first_name = "Joe"
;    
-- * 2b. Find all actors whose last name contain the letters `GEN`:
SELECT
	first_name 
    , last_name
FROM 
	actor 
WHERE 
	last_name LIKE '%GEN%'
;
-- ASK QUESTION ABOUT ORDER * 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT
	first_name
    , last_name 
FROM
	actor
WHERE 
	last_name LIKE '%LI%'
ORDER BY
	last_name, first_name 
;
-- * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT
	country_id
    , country
FROM 
	country 
WHERE
	country IN ("Afghanistan", "Bangladesh", "China")
;
-- * 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor ADD COLUMN decription VARBINARY(3000); 
-- * 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor DROP description; 
-- * 4a. List the last names of actors, as well as how many actors have that last name.
SELECT
	last_name
    , count(last_name)
FROM 
	actor
GROUP BY 
	last_name
    ;

-- * 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
SELECT
	last_name 
    , count(last_name)
FROM
	actor
GROUP BY
	last_name
HAVING 
	count(last_name) > 1
;
-- * 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
SET SQL_SAFE_UPDATES = 0;

UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS"
;
-- * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor 
SET first_name = "GROUCHO"
WHERE first_name = "HARPO" AND last_name = "WILLIAMS" 
; 

-- * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SELECT * FROM address
;
SELECT * FROM staff
; 
-- * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT
	staff.first_name 
    , staff.last_name 
	, address.address
FROM 
	staff
INNER JOIN address on staff.address_id = address.address_id
; 
-- * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT * from payment
;
SELECT * FROM staff
;

SELECT
	staff.first_name
    ,staff.last_name
    ,sum(payment.amount) as "Total Amount August 2005"
FROM staff 
INNER JOIN payment on staff.staff_id = payment.staff_id
WHERE payment_date LIKE "%2005-08%" 
GROUP BY first_name
;
-- * 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select * from film_actor
; 
select * from film 
;

SELECT
    COUNT(film_actor.actor_id) as "Number of Actors"
    ,film.title
FROM film_actor 
INNER JOIN film ON film.film_id = film_actor.film_id
GROUP BY 
	title 
;
-- * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT * from inventory 
;

SELECT
	COUNT(inventory.film_id) as "Number of Copies in inventory"
    , film.title 
FROM film
INNER JOIN inventory on inventory.film_id = film.film_id
WHERE film.title = "Hunchback Impossible"
;
-- * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT
	sum(payment.amount)
    , customer.first_name
    , customer.last_name
FROM payment
INNER JOIN customer on payment.customer_id = customer.customer_id
GROUP BY
	customer.last_name
ORDER BY
	last_name 
;
-- * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT 
	title 
FROM 
	film
WHERE 
	title LIKE "K%" OR title LIKE "Q%"
    AND language_id = 1
;
-- * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
	
SELECT 
	first_name,
    last_name
FROM
	actor 
WHERE
	actor_id IN (select actor_id FROM film_actor WHERE film_id = (select film_id FROM film WHERE title = "Alone Trip"));

-- * 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT
	first_name,
    last_name,
    email
FROM
	customer
INNER JOIN address on customer.address_id=address.address_id 
INNER JOIN city on address.city_id=city.city_id 
INNER JOIN country on city.country_id=country.country_id
WHERE
	country = "Canada" 
;
-- * 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT
	title
FROM
	film
WHERE
	film_id IN (SELECT film_id FROM film_category WHERE category_id = (SELECT category_id FROM category WHERE name = "Family")
);
-- * 7e. Display the most frequently rented movies in descending order.
SELECT
	title,
    count(title) as "How Many Times Rented"
FROM
	film
INNER JOIN inventory on film.film_id = inventory.film_id
INNER JOIN rental on inventory.inventory_id=rental.inventory_id
GROUP BY title
ORDER BY COUNT(title) DESC
;

-- * 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT
    store.store_id,
    sum(amount) as "Amount Store Brought In"
FROM 
	payment
INNER JOIN staff ON payment.staff_id = staff.staff_id
INNER JOIN store ON staff.store_id = store.store_id
GROUP BY store.store_id 
;    

-- * 7g. Write a query to display for each store its store ID, city, and country.
SELECT
	store.store_id as "Store ID", 
	city.city as "City", 
    country.country as "Country"
FROM 
	store
INNER JOIN address on store.address_id = address.address_id
INNER JOIN city on address.city_id=city.city_id
INNER JOIN country on city.country_id=country.country_id
;
-- * 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the
-- following tables: category, film_category, inventory, payment, and rental.)
SELECT
	category.name as "Name",
    sum(payment.amount)
FROM 
	category 
INNER JOIN film_category on category.category_id=film_category.category_id
INNER JOIN inventory on film_category.film_id=inventory.film_id
INNER JOIN rental on inventory.inventory_id= rental.inventory_id
INNER JOIN payment on rental.staff_id= payment.staff_id  
Group By category.name 
ORDER BY
	Gross_Revenue DESC
LIMIT 5
;
-- * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW `five_genre_view` AS SELECT (SELECT
	category.name as "Name",
    sum(payment.amount)
FROM 
	category 
INNER JOIN film_category on category.category_id=film_category.category_id
INNER JOIN inventory on film_category.film_id=inventory.film_id
INNER JOIN rental on inventory.inventory_id= rental.inventory_id
INNER JOIN payment on rental.staff_id= payment.staff_id  
Group By category.name 
ORDER BY
	Gross_Revenue DESC
LIMIT 5);


-- * 8b. How would you display the view that you created in 8a?
SELECT * FROM `five_genre_view`;

-- * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW `five_genre_view`;