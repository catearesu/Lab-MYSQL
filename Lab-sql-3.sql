-- LAB SQL 3
-- 1. How many distinct (different) actors' last names are there?
SELECT count(distinct(last_name)) FROM sakila.actor; -- hay 121 diferentes last names
SELECT distinct(last_name) FROM sakila.actor; -- para ver el listado de unique last names

-- 2. In how many different languages where the films originally produced? 
-- (Use the column language_id from the film table)
SELECT distinct(language_id) FROM sakila.film; -- 1

-- 3. How many movies were released with "PG-13" rating?
SELECT count(*) as PG13_count FROM sakila.film WHERE rating = "PG-13"; -- 223 movies

-- 4. Get 10 the longest movies from 2006.
SELECT * 
FROM sakila.film 
WHERE release_year = 2006 
ORDER BY length DESC
LIMIT 10;

-- 5. How many days have been the company operating (check DATEDIFF() function)?
SELECT DATEDIFF(CURDATE(), (SELECT min(create_date) FROM sakila.customer)) AS days_operating 
FROM sakila.customer;
-- OTRA MANERA
SELECT 
	datediff(now(), last_update)
FROM sakila.store;

-- 6. Show rental info with additional columns month and weekday. Get 20.
SELECT substring(rental_date, 6, 2) as Month FROM sakila.rental;
SELECT MONTH(rental_date) as Month FROM sakila.rental; -- es lo mismo (hay una función MONTH)

SELECT DAYOFWEEK(rental_date) as Weekday FROM sakila.rental; -- 0 es Sunday

SELECT *,
    SUBSTRING(rental_date, 6, 2) as Month,
    DAYOFWEEK(rental_date) as Weekday
FROM sakila.rental
LIMIT 20;
-- lo mismo pero usando la función MONTH
SELECT *,
    MONTH(rental_date) as Month,
    DAYOFWEEK(rental_date) as Weekday
FROM sakila.rental
LIMIT 20;

-- 7. Add an additional column day_type with values 'weekend' and 'workday' 
-- depending on the rental day of the week.

-- CON WEEKDAY
SELECT 
	*,
	weekday(rental_date) as weekday_nr   -- 0 es Monday para la función weekday
    FROM sakila.rental;
SELECT *, 
	CASE 
		WHEN weekday(rental_date) IN(5,6) 
			THEN "WEEKEND" 
		ELSE "WORKDAY" 
	END AS flg_workday 

FROM sakila.rental;

-- CON DAYOFWEEK
SELECT *,
	MONTH(rental_date) as Month,
	DAYOFWEEK(rental_date) as Weekday,
    CASE
		WHEN DAYOFWEEK(rental_date) IN (1, 7) 
			THEN "weekend"
		ELSE "workday"
	END as day_type
FROM sakila.rental;

-- 8. How many rentals were in the last month of activity?
SELECT * 
FROM sakila.rental
ORDER BY rental_date DESC;

SELECT COUNT(*) 
FROM sakila.rental 
WHERE rental_date LIKE "2006-02%"; -- ???

SELECT EXTRACT(YEAR_MONTH from rental_date) , COUNT(*) FROM sakila.rental -- YYYYMM
GROUP BY EXTRACT(YEAR_MONTH FROM rental_date)
ORDER BY EXTRACT(YEAR_MONTH FROM rental_date) DESC LIMIT 1; -- ES LO MISMO



