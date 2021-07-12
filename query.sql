-- QUERY 1
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