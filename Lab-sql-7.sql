-- LAB 7 

-- 1 . 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?

-- con JOIN
SELECT title, count(inventory_id) as num_copies
FROM sakila.inventory i 
LEFT JOIN sakila.film f
ON i.film_id = f.film_id
GROUP BY title
HAVING title = "Hunchback Impossible"
ORDER BY title DESC; -- hay 6 copias

-- con subquery
SELECT film_id, count(inventory_id) as num_copies
FROM sakila.inventory
GROUP BY film_id
HAVING film_id IN (SELECT film_id FROM sakila.film
					WHERE title = "Hunchback Impossible");-- esto me da ID 439 

-- Y SI QUIERO QUE APAREZCA TAMBIÉN EL TITULO DEL FILM??
SELECT title 
FROM sakila.film 
WHERE film_id IN(SELECT film_id FROM(SELECT film_id, count(inventory_id) as num_copies
				FROM sakila.inventory
				GROUP BY film_id
				HAVING film_id IN (SELECT film_id FROM sakila.film
				WHERE title = "Hunchback Impossible"))sub1); 

-- 2. List all films whose length is longer than the average of all the films.
SELECT *
FROM sakila.film
WHERE length > (SELECT AVG(length) FROM sakila.film)
ORDER BY length; -- tengo el listado a partir de una length de 116 minutos // hay 489 films

SELECT avg(length) -- el average length es de 115,2720 minutos
FROM sakila.film;

-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.
SELECT first_name, last_name
FROM sakila.actor a
WHERE a.actor_id IN(SELECT fa.actor_id
					FROM sakila.film_actor fa
					JOIN sakila.film f 
						ON fa.film_id = f.film_id
					WHERE f.title = 'Alone Trip');

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT title
FROM sakila.film f
WHERE f.film_id IN(SELECT fc.film_id
				FROM sakila.film_category fc
				LEFT JOIN sakila.category c
				ON fc.category_id = c.category_id
                WHERE c.name = "Family"); -- hay 69 films de categoria Family (category_id 8)

-- 5. Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.

SELECT first_name -- son Derrick, Darrel, Loretta, Curtis, Troy
	   ,email 
FROM sakila.customer
WHERE address_id IN (SELECT address_id FROM sakila.address -- address_id 179 196 300 313 383 430 565
					WHERE city_id IN (SELECT city_id -- hay 7 city_id en el country Canada
											FROM sakila.city
											WHERE country_id IN (SELECT country_id 
																FROM sakila.country
																WHERE country = "Canada"))); -- country_id 20


-- 6. Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT film_id -- me da error porque el result set son 2 columnas y solo hay pasarle una, que la columna del actor_id
FROM sakila.film_actor
WHERE actor_id IN (SELECT actor_id, count(film_id)
					FROM sakila.film_actor
					GROUP BY actor_id
					ORDER BY count(film_id) DESC); -- the most prolific actor is 107 con 42 films

SELECT title -- hay 42 films donde aparece el actor 107 que es el más prolifico 
FROM sakila.film 
WHERE film_id IN(SELECT film_id 
				FROM sakila.film_actor
				WHERE actor_id IN (SELECT actor_id FROM ( -- este select es clave
					SELECT actor_id, count(film_id)
					FROM sakila.film_actor
					GROUP BY actor_id
					ORDER BY count(film_id) DESC
					LIMIT 1) sub1)); -- este limit 1 es fundamental para que te de solo un actor_id

-- esto me da solo el actor_id del que más films ha hecho (107)
SELECT actor_id FROM (
SELECT actor_id, count(film_id)
FROM sakila.film_actor
GROUP BY actor_id
ORDER BY count(film_id) DESC
LIMIT 1) sub1;

-- esto me da el actor_id con el número más alto de films (actor 107 con 42 films)
SELECT actor_id, count(film_id)
FROM sakila.film_actor
GROUP BY actor_id
ORDER BY count(film_id) DESC limit 1;

-- 7. Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer 
-- ie the customer that has made the largest sum of payments

-- esto me dice el customer_id con el amount total más alto
SELECT customer_id, sum(amount) as total_payments
FROM sakila.payment
GROUP BY customer_id 
ORDER BY total_payments DESC
LIMIT 1; -- el customer más profitable es el 526 con 221, 55 euros

SELECT 
	r.customer_id
    , f.title
FROM sakila.rental r
LEFT JOIN sakila.inventory i
ON r.inventory_id = i.inventory_id
LEFT JOIN sakila.film f
ON i.film_id = f.film_id
WHERE customer_id = 
	(SELECT 
		customer_id 
	FROM (
		SELECT 
			customer_id
			, sum(amount) AS total_payments 
		FROM sakila.payment
		group by customer_id
		ORDER BY sum(amount) desc
		LIMIT 1) 
	sub);

-- 8. Get the `client_id` and the `total_amount_spent` of those clients 
-- who spent more than the average of the `total_amount` spent by each client.
SELECT customer_id
		, SUM(amount) as amount_spent_per_customer
FROM sakila.payment
GROUP BY customer_id
HAVING sum(amount) > (SELECT sum(amount)/count(distinct customer_id) 
						as average_total_amount_per_customer -- El average total amount son 112,53
						FROM sakila.payment)
ORDER BY sum(amount) DESC; -- hay 285 customer che hanno speso più della media
                
                
                
                
                
                