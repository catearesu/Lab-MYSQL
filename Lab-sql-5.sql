/*![logo_ironhack_blue 7](https://user-images.githubusercontent.com/23629340/40541063-a07a0a8a-601a-11e8-91b5-2f13e4e6b441.png)

# Lab | SQL Queries 7

In this lab, you will be using the [Sakila](https://dev.mysql.com/doc/sakila/en/) database of movie rentals. You have been using this database for a couple labs already, but if you need to get the data again, refer to the official [installation link](https://dev.mysql.com/doc/sakila/en/sakila-installation.html).

The database is structured as follows:
![DB schema](https://education-team-2020.s3-eu-west-1.amazonaws.com/data-analytics/database-sakila-schema.png)

### Instructions

1. In the table actor, which are the actors whose last names are not repeated? 
For example if you would sort the data in the table actor by last_name, 
you would see that there is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd. 
These three actors have the same last name. So we do not want to include this last name in our output. 
Last name "Astaire" is present only one time with actor "Angelina Astaire", 
hence we would want this in our output list. 
2. Which last names appear more than once? We would use the same logic as in the previous question but this time we want to include the last names of the actors where the last name was present more than once
3. Using the rental table, find out how many rentals were processed by each employee.
4. Using the film table, find out how many films were released each year.
5. Using the film table, find out for each rating how many films were there.
6. What is the mean length of the film for each rating type. Round off the average lengths to two decimal places 
7. Which kind of movies (rating) have a mean duration of more than two hours?
*/
-- 1. which are the actors whose last names are not repeated?
SELECT last_name -- me devuelve 66 rows
	FROM sakila.actor 
	GROUP BY last_name
    HAVING count(*)=1;

SELECT first_name, last_name -- me devuelve 168 rows, qué cambia con lo de arriba??
	FROM sakila.actor 
	GROUP BY first_name, last_name
    HAVING count(last_name)=1
	ORDER BY last_name; -- VEO QUE CUENTA LOS APELLIDOS REPETIDOS, POR QUÉ??
 
 -- 2. Which last names appear more than once? We would use the same logic as in the previous question but this time we want to include the last names of the actors where the last name was present more than once
SELECT last_name 
	FROM sakila.actor 
	GROUP BY last_name
    HAVING count(*)> 1; -- HAY 55 APELLIDOS QUE SE REPITEN MÁS DE UNA VEZ
    
-- 3. Using the rental table, find out how many rentals were processed by each employee.
SELECT count(*) 
	FROM sakila.rental
    GROUP BY staff_id
    HAVING staff_id = 1; -- el employee 1 processed 8040 rentals
SELECT count(*) 
	FROM sakila.rental
    GROUP BY staff_id
    HAVING staff_id = 2; -- el employee 2 processed 8004 rentals
    
SELECT count(rental_id) -- OTRA MANERA DE HACER LO MISMO CON EL WHERE
	FROM sakila.rental
    WHERE staff_id = 1;

SELECT count(rental_id)
	FROM sakila.rental
    WHERE staff_id = 2;

-- 4. Using the film table, find out how many films were released each year.
SELECT count(film_id) -- RESUELTO CON EL WHERE
	FROM sakila.film
    WHERE release_year = 2006; -- hay 1000 peliculas released en 2006
    
SELECT count(*) -- OTRA MANERA DE HACER LO MISMO CON EL GROUP BY Y HAVING
	FROM sakila.film
    GROUP BY release_year
    HAVING release_year = 2006;

-- 5. Using the film table, find out for each rating how many films were there.
SELECT DISTINCT rating -- hay 5 diferentes ratings
	FROM sakila.film;

SELECT count(*), rating
	FROM sakila.film
    GROUP BY rating; -- 194, 178, 210, 223 y 195 

-- 6. What is the mean length of the film for each rating type. 
-- Round off the average lengths to two decimal places 
SELECT rating, round(avg(length), 2) as average_length
	FROM sakila.film
    GROUP BY rating; -- 112.01, 111.05, 113.23, 120.44, 118.66
    
-- 7. Which kind of movies (rating) have a mean duration of more than two hours?
SELECT rating, round(avg(length), 2) as average_length
	FROM sakila.film
    GROUP BY rating
    HAVING average_length > 120; -- rating PG-13 with a mean duration of 120,44 min

