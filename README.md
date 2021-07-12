# Overview

This project is to illustrate how to use SQL (PostgreSQL) for data analysis and use python to visualize the query results. 

# About the Dataset
The data used for this project is based on **Sakila DVD Rental Database**. The **Sakila Database** holds information about a company that rents movie DVDs. For this project, we will be querying the database to gain an understanding of the customer base, such as what the patterns in movie watching are across different customer groups, how they compare on payment earnings, and how the stores compare in their performance. 

*(NOTICE: One quirk when exploring this "fake" database is that the rental dates are all from 2005 and 2006, while the payment dates are all from 2007. But it won't affect our analysis.)*

For a quick view on the database, refer to its ERD [here](https://github.com/Alex-YuZ/Investigate-Sakila-Database-and-Visualization/blob/master/dvd-rental-erd-2.pdf).

# Insights to Explore
## Query 1. What is the rental behavior in family movies?
We want to understand more about the movies that families are watching. The following categories are considered family movies: **Animation, Children, Classics, Comedy, Family and Music**. Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.

## Query 2. What were the rental duration in quartile for family movies?
Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for. Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories? Make sure to also indicate the category that these family-friendly movies fall into.

## Query 3. 
Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category. The resulting table should have three columns:

- Category
- Rental length category
- Count

## Query 4. What were the rental orders by store?
We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for. Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.

## Query 5. 
We would like to know who were our top 10 paying customers, how many payments they made on a monthly basis during 2007, and what was the amount of the monthly payments. Can you write a query to capture the customer name, month and year of payment, and total payment amount for each month by these top 10 paying customers?

## Query 6. Payment Difference between months for Top 10 Payors
Finally, for each of these top 10 paying customers, I would like to find out the difference across their monthly payments during 2007. Please go ahead and write a query to compare the payment amounts in each successive month. Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful if you can identify the customer name who paid the most difference in terms of payments.

