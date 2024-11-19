-- LAB SQL 1+2
-- 2. Get all the data from tables actor, film and customer.
SELECT * FROM sakila.actor;
SELECT * FROM sakila.film;
SELECT * FROM sakila.customer;

-- 3. Get film titles.
SELECT title FROM sakila.film;

-- 4. Get unique list of film languages under the alias language. 
SELECT DISTINCT(name) as Language FROM sakila.language;

-- 5.1 Find out how many stores does the company have?
SELECT count(store_id) FROM sakila.store; 

-- 5.2 Find out how many employees staff does the company have?
SELECT count(staff_id) FROM sakila.staff;

-- 5.3 Return a list of employee first names only?
SELECT first_name FROM sakila.staff;

-- 6. Select all the actors with the first name ‘Scarlett’.
SELECT * FROM sakila.actor WHERE first_name = "Scarlett";

-- 7. Select all the actors with the last name ‘Johansson’.
SELECT * FROM sakila.actor WHERE last_name = "Johansson";

-- 8. How many films (movies) are available for rent? 1000
SELECT * FROM sakila.film;
SELECT count(film_id) FROM sakila.film; -- how many films based on the id
SELECT distinct(title) FROM sakila.film; -- list of unique values but not the quantity
-- 9. What are the shortest and longest movie duration? Name the values max_duration and min_duration.
SELECT min(length) as min_duration,
	   max(length) as max_duration
FROM sakila.film; -- y si quiero ver toda la información de esa fila??
-- min duration 46 min
-- max duration 185 min

-- muestro todas las peliculas cuya duración es 46 min
SELECT * 
FROM sakila.film 
WHERE length = (SELECT min(length) FROM sakila.film);

-- muestro todas las peliculas cuya duración es 185 min
SELECT * 
FROM sakila.film 
WHERE length = (SELECT max(length) FROM sakila.film);

-- 10. What's the average movie duration?
SELECT avg(length) FROM sakila.film; -- 115 min

-- 11. How many movies are longer than 3 hours?
-- muestro todas las peliculas cuya duración es mayor a 3 horas
SELECT * 
FROM sakila.film 
WHERE length > 180;
-- cuantas peliculas duran mas de 3 horas
SELECT count(title) FROM sakila.film WHERE length > 180; -- 39

-- 12. What's the length of the longest film title?
SELECT max(length(title)) as max_title_length FROM sakila.film; -- The longest film title is 27 

-- quiero saber cual es el film con el titulo más largo
SELECT * 
FROM sakila.film 
WHERE length(title) = (SELECT max(length(title)) FROM sakila.film);