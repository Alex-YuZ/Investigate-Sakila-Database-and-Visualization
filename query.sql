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

 /* QUERY 3 */ 
-- Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category. The resulting table should have three columns:

    -- Category
    -- Rental length category
    -- Count

WITH sub AS (
  SELECT title,
         name,
         rental_duration
    FROM film f
    JOIN film_category fc ON f.film_id=fc.film_id
    JOIN category c ON c.category_id=fc.category_id
   WHERE name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')),

  sub2 AS (
       SELECT title,
              name,
              rental_duration,
              NTILE(4) OVER (ORDER BY rental_duration) AS quartile_rental_duration
         FROM sub)

SELECT name category_name,
       quartile_rental_duration quartile_level,
       COUNT(*)
  FROM sub2
 GROUP BY 1, 2
 ORDER BY 1, 2

 /*QUERY 4 - query used for 3rd insight*/ 
 -- We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for. Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.

WITH sub1 AS (
  SELECT rental_id,
         DATE_TRUNC('month', rental_date) month_trunc,
         st.store_id
    FROM rental r
    JOIN staff sf ON r.staff_id=sf.staff_id
    JOIN store st ON st.store_id=sf.store_id
)

SELECT DATE_PART('month', month_trunc) AS rental_month,
       DATE_PART('year', month_trunc) AS rental_year,
       store_id,
       COUNT(rental_id) count_rentals
  FROM sub1
  GROUP BY 1, 2, 3
  ORDER BY  4 DESC;

  /* QUERY 5 */ 
-- We would like to know who were our top 10 paying customers, how many payments they made on a monthly basis during 2007, and what was the amount of the monthly payments. Can you write a query to capture the customer name, month and year of payment, and total payment amount for each month by these top 10 paying customers?

-- Get the full_name of the top 10 customer in terms of total payments
WITH sub AS (
  SELECT first_name || ' ' || last_name AS full_name,
       sum(amount) total_payment
    FROM payment p
    JOIN customer c ON c.customer_id=p.customer_id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10),

-- Get the framework of final result without any condition
  sub2 AS (
    SELECT DATE_TRUNC('month', payment_date) month_trunc,
           first_name || ' ' || last_name AS customer_full_name,
           COUNT(*) pay_count_per_mon,
           SUM(amount) pay_amount
      FROM payment p
      JOIN customer c ON c.customer_id=p.customer_id
      GROUP BY 1, 2)

-- Filtered the result of `sub2` by the `sub` result (top 10 customer in payment)
SELECT month_trunc pay_month,
       customer_full_name full_name,
       pay_count_per_mon,
       pay_amount
  FROM sub2
 WHERE customer_full_name IN (SELECT full_name
                                FROM sub)
 ORDER BY customer_full_name, month_trunc;

 /* QUERY 6 - query used for 4th insight */ 
-- Finally, for each of these top 10 paying customers, I would like to find out the difference across their monthly payments during 2007. Please go ahead and write a query to compare the payment amounts in each successive month. Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful if you can identify the customer name who paid the most difference in terms of payments.

-- Get the full_name of the top 10 customer in terms of total payments
WITH sub AS (
  SELECT first_name || ' ' || last_name AS full_name,
       sum(amount) total_payment
    FROM payment p
    JOIN customer c ON c.customer_id=p.customer_id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10),

-- Get the framework of final result without any condition
  sub2 AS (
    SELECT DATE_TRUNC('month', payment_date) month_trunc,
           first_name || ' ' || last_name AS customer_full_name,
           COUNT(*) pay_count_per_mon,
           SUM(amount) pay_amount
      FROM payment p
      JOIN customer c ON c.customer_id=p.customer_id
      GROUP BY 1, 2),

-- Filtered the result of `sub2` by the `sub` result (top 10 customer in payment)
  sub3 AS (
    SELECT *
      FROM sub2
     WHERE customer_full_name IN (SELECT full_name
                                    FROM sub)
  )

-- Calculate the difference between lead() and current
SELECT month_trunc,
       customer_full_name,
       pay_amount,
       LEAD(pay_amount) OVER (PARTITION BY customer_full_name ORDER BY month_trunc),
       (LEAD(pay_amount) OVER (PARTITION BY customer_full_name ORDER BY month_trunc) 
         - pay_amount) AS difference
  FROM sub3
 ORDER BY difference DESC;