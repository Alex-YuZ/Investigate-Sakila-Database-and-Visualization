/* QUERY 1 - query used for 1st insight */ 
-- We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music. Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.

WITH sub1 AS (
    SELECT f.title,
           c.name,
           r.rental_id
      FROM film f
      JOIN film_category fc ON f.film_id=fc.film_id
      JOIN category c ON c.category_id=fc.category_id
      JOIN inventory i ON i.film_id=f.film_id
      JOIN rental r ON r.inventory_id=i.inventory_id
     WHERE name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
)

SELECT title AS film_title,
       name AS category_name,
       COUNT(rental_id) rental_count
  FROM sub1
 GROUP BY 1, 2
 ORDER BY 2, 1

 /* QUERY 2 - query used for 2nd insight */ 
-- Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for. Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories? Make sure to also indicate the category that these family-friendly movies fall into.

WITH sub AS (
  SELECT title,
         name,
         rental_duration
    FROM film f
    JOIN film_category fc ON f.film_id=fc.film_id
    JOIN category c ON c.category_id=fc.category_id
   WHERE name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
)

SELECT title film_title,
       name category_name,
       rental_duration,
       NTILE(4) OVER (ORDER BY rental_duration) AS quartile_level
  FROM sub
 ORDER BY quartile_level;