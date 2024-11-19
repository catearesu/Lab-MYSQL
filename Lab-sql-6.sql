-- LAB 6 

-- 1. Rank films by length (filter out the rows with nulls or zeros in length column). 
-- Select only columns title, length and rank in your output.
SELECT title
	,length
    , RANK() OVER(ORDER BY length DESC) AS ranking
    , DENSE_RANK() OVER(ORDER BY length DESC) AS dense_ranking
    , ROW_NUMBER() OVER(ORDER BY length DESC) AS row_ranking
FROM sakila.film
WHERE length <> 0; -- y nulos??

-- 2. Rank films by length within the `rating` category (filter out the rows with nulls or zeros in length column). 
-- In your output, only select the columns title, length, rating and rank.  
SELECT title
	,length
    , rating
    , RANK() OVER(PARTITION BY rating ORDER BY length DESC) AS ranking
    , DENSE_RANK() OVER(PARTITION BY rating ORDER BY length DESC) AS dense_ranking
    , ROW_NUMBER() OVER(PARTITION BY rating ORDER BY length DESC) AS row_ranking
FROM sakila.film
WHERE length <> 0 ; -- y nulos??

-- 3. How many films are there for each of the categories in the category table? 
-- **Hint**: Use appropriate join between the tables "category" and "film_category".
SELECT name as category
	, count(*) as count_films
FROM sakila.category as c
LEFT JOIN sakila.film_category as fc
	ON c.category_id = fc.category_id
GROUP BY name -- no pongo c.name porque la columna name solo está en la tabla c, no hay ambiguedad/también puedo poner category
ORDER BY COUNT(*) DESC; 

-- 4. Which actor has appeared in the most films? 
-- **Hint**: You can create a join between the tables "actor" and "film actor" and count the number of times an actor appears.
SELECT actor_id
	, count(*) AS film_counts
FROM sakila.film_actor
GROUP BY actor_id
ORDER BY count(*) DESC; -- CON ESTO SE CUANTAS VECES APARECE CADA ACTOR_ID / me falta asignar a cada actor_id su nombre y apellido

SELECT actor.actor_id
	, first_name
    , last_name
    , count(*) AS film_counts
FROM sakila.actor as actor
LEFT JOIN sakila.film_actor as fa
	ON actor.actor_id = fa.actor_id
GROUP BY actor.actor_id
ORDER BY count(*) DESC; -- Y SI QUIERO VER EN LAS PELICULAS QUE HA SALIDO CADA ACTOR??
-- GINA DEGENERES HA APARECIDO EN 42 PELICULAS

-- 5. Which is the most active customer (the customer that has rented the most number of films)? 
-- **Hint**: Use appropriate join between the tables "customer" and "rental" and count the `rental_id` for each customer.
SELECT r.customer_id
	, first_name
    , last_name
    , count(*) AS rental_counts
FROM sakila.rental as r
LEFT JOIN sakila.customer as c
	ON r.customer_id = c.customer_id
GROUP BY r.customer_id
ORDER BY count(*) DESC; -- Eleanor Hunt con 46 rentals

SELECT *
FROM sakila.rental as r
LEFT JOIN sakila.customer as c
ON r.customer_id = c.customer_id;

-- 6. List the number of films per category. Es lo mismo que la pregunta 3???
SELECT c.name
    , count(*) as film_counts
FROM sakila.film_category as fc
LEFT JOIN sakila.category as c
	ON fc.category_id = c.category_id
GROUP BY c.category_id
ORDER BY count(*) DESC; -- sports con 74 films seguido por Foreign con 73

SELECT category_id, count(*)
FROM sakila.film_category
GROUP BY category_id
ORDER BY count(*) DESC; -- cuento los films dentro de cada category_id
    
-- 7. Display the first and the last names, as well as the address, of each staff member.
SELECT first_name
	, last_name
    , address
FROM sakila.staff s
JOIN sakila.address a
	ON s.address_id = a.address_id; -- Mike Workhaven Lane y Jon Lillydale Drive

-- 8. Display the total amount rung up by each staff member in August 2005. No entiendo la pregunta
SELECT s.staff_id
	  , sum(amount) as total_amount
FROM sakila.staff s
LEFT JOIN sakila.payment p
ON s.staff_id = p.staff_id
WHERE payment_date LIKE "2005-08%"
GROUP BY s.staff_id; -- staff 1 11853,65 -- staff 2 12216,49

SELECT *
FROM sakila.staff s
LEFT JOIN sakila.payment p
ON s.staff_id = p.staff_id
WHERE payment_date LIKE "2005-08%";

-- 9. List all films and the number of actors who are listed for each film.
SELECT title
	, count(actor_id) as num_actors
FROM film f
LEFT JOIN film_actor fa
	ON f.film_id = fa.film_id
GROUP BY title
ORDER BY num_actors DESC; -- Lambs Cincinnati tiene 15 actores

-- 10. Using the payment and the customer tables as well as the JOIN command, list the total amount paid by each customer. 
-- List the customers alphabetically by their last names.

-- total amount paid by each customer
SELECT customer_id
	, sum(amount) as total_amount_paid
FROM sakila.payment
GROUP BY customer_id;
-- List the customers alphabetically by their last names.
SELECT c.customer_id
	,first_name
    , last_name
    , sum(amount) as total_amount_paid 
FROM sakila.customer c
LEFT JOIN sakila.payment p
	ON c.customer_id = p.customer_id
GROUP BY c.customer_id, first_name, last_name
ORDER BY last_name;

-- 11. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id
	, c.city
    , co.country
FROM sakila.store s
LEFT JOIN sakila.address a
ON s.address_id = a.address_id
LEFT JOIN sakila.city c
ON a.city_id = c.city_id
LEFT JOIN sakila.country co
ON c.country_id = co.country_id; -- Store 1 Lethbridge Canada y Store 2 Woodridge Australia
    
-- ejercicio Arnau
SELECT store_id
	, city
    , country
FROM store
JOIN address
ON store.address_id = address.address_id
JOIN city
ON address.city_id = city.city_id
JOIN country
ON city.country_id = country.country_id
;
-- 1: Lethbridge, Canada
-- 2: Woodridge, Australia

-- 12. Write a query to display how much business, in dollars, each store brought in.
-- está en la view sales_by_store pero no me da el mismo resultado
SELECT store_id
	, sum(amount) AS total_sales
FROM sakila.payment p
LEFT JOIN sakila.staff s
	ON p.staff_id = s.staff_id
GROUP BY store_id
ORDER BY total_sales ; -- store 1 33482,50 -- store 2 33924,06

SELECT *
FROM sakila.payment p
LEFT JOIN sakila.staff s
ON p.staff_id = s.staff_id
;

-- 13. What is the average running time of films by category? entendiendo running time como length
SELECT c.name
	, AVG(f.length) AS avg_running_time
FROM sakila.film f
LEFT JOIN sakila.film_category fc
	ON f.film_id = fc.film_id
LEFT JOIN sakila.category c
	ON fc.category_id = c.category_id
GROUP BY c.name;

-- 14. Which film categories are longest? ¿¿meaning which have the longest length??
SELECT c.name AS category_name
	, MAX(length) AS longest_films
FROM sakila.film f
LEFT JOIN sakila.film_category fc
ON f.film_id = fc.film_id
LEFT JOIN sakila.category c
ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY longest_films DESC;

-- 15. Display the most frequently rented movies in descending order. 
SELECT title
	, count(rental_id) AS count_rentals
FROM sakila.rental r
LEFT JOIN sakila.inventory i
	ON r.inventory_id = i.inventory_id
LEFT JOIN sakila.film f
	ON i.film_id = f.film_id
GROUP BY title
ORDER BY count(rental_id) DESC; -- Bucket Brotherhood 34 veces

-- 16. List the top five genres in gross revenue in descending order.
-- está en la view sales_by_film_category
-- se puede sacar también de la view film_list -- NO ES CORRECTO
SELECT c.name
	, SUM(amount) AS revenue_por_categoria
FROM sakila.payment p
LEFT JOIN sakila.rental r
	ON p.rental_id = r.rental_id
LEFT JOIN sakila.inventory i
	ON r.inventory_id = i.inventory_id
LEFT JOIN sakila.film_category fc
	ON i.film_id = fc.film_id
LEFT JOIN sakila.category c
	ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY revenue_por_categoria DESC
LIMIT 5; -- Sport 5314,21 Sci-Fi 4756,98 Animation 4656,30 Drama 4587,39 Comedy 4383,58

-- 17. Is "Academy Dinosaur" available for rent from Store 1?
SELECT title
	, store_id
FROM sakila.film f
LEFT JOIN sakila.inventory i
	ON f.film_id = i.film_id
WHERE title = "Academy Dinosaur" and store_id = 1; -- sí