-- LAB SQL 4
-- 1. Get film ratings.
SELECT distinct(rating) FROM sakila.film;

-- 2. Get release years.
SELECT distinct(release_year) FROM sakila.film; -- todos son del 2006

-- 3. Get all films with ARMAGEDDON in the title.
SELECT * 
FROM sakila.film 
WHERE UPPER(title) LIKE "%ARMAGEDDON%";

-- 4. Get all films with APOLLO in the title
SELECT * 
FROM sakila.film 
WHERE UPPER(title) LIKE "%APOLLO%";

-- 5. Get all films which title ends with APOLLO.
SELECT * 
FROM sakila.film 
WHERE UPPER(title) LIKE "%APOLLO";

-- 6. Get all films with word DATE in the title.
SELECT * 
FROM sakila.film 
WHERE UPPER(title) LIKE "%DATE%";

-- 7. Get 10 films with the longest title.
SELECT * 
FROM sakila.film 
ORDER BY length(title) DESC
LIMIT 10;

-- 8. Get 10 the longest films.
SELECT * 
FROM sakila.film 
ORDER BY length DESC
LIMIT 10;

-- 9. How many films include Behind the Scenes content?
SELECT count(*) 
FROM sakila.film 
WHERE special_features LIKE "%Behind the Scenes%"; -- 538 FILMS

SELECT * 
FROM sakila.film 
WHERE special_features LIKE '%Behind the Scenes%'; -- SE PUEDE COMBINAR CON LO DE ARRIBA??

-- 10. List films ordered by release year and title in alphabetical order.
SELECT * 
FROM sakila.film 
ORDER BY release_year and title;

