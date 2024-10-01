/*
    Name: Estrella Arellano
    DTSC660: Data and Database Management with SQL
    Module 7
    Assignment 6


*/

--------------------------------------------------------------------------------
/*				                 Table Creation		  		          */
--------------------------------------------------------------------------------
CREATE TABLE customer_spending (
	date date,
	year integer,
	month varchar(20),
	customer_age smallint,
	customer_gender varchar(10),
	country varchar(100),
	state varchar(50),
	product_category varchar(50),
	sub_category varchar(100),
	quantity smallint,
	unit_cost numeric(10,2),
	unit_price numeric(10,6),
	cost numeric(10,2),
	revenue numeric(10,2)	
);
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
/*				                 Import Data           		  		          */
--------------------------------------------------------------------------------
COPY customer_spending
FROM 'C:\Users\Public\customer_spending.csv'
WITH (FORMAT CSV, HEADER);

SELECT *FROM customer_spending;
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
/*				                 Question 1: 		  		          */
/* 1. Write a query that returns each category and the corresponding total revenue for that
category for the sale_year 2016. The output should be arranged alphabetically. */

--------------------------------------------------------------------------------
SELECT DISTINCT product_category,total_revenue
FROM (SELECT product_category,SUM(revenue) AS total_revenue FROM customer_spending
	  WHERE year=2016
	  GROUP BY product_category) AS define_total
GROUP BY product_category,total_revenue HAVING MAX(total_revenue) IN (SELECT MAX(total_revenue)FROM customer_spending)
ORDER BY product_category;

--------------------------------------------------------------------------------
/*				                  Question 2           		  		          */
/* 2. Write a query that returns a list of sub_categories and their corresponding average
unit_price, average unit_cost, as well as the difference between these two values
-- (name this column margin) for the sale_year 2015. Organize the results alphabetically. */

--------------------------------------------------------------------------------
SELECT sub_category, AVG(unit_price) AS avg_unit_price,AVG(unit_cost) 
AS avg_unit_cost,AVG(unit_price)-AVG(unit_cost) AS margin FROM customer_spending
WHERE year=2015
GROUP BY sub_category
ORDER BY sub_category;
--------------------------------------------------------------------------------
/*				                  Question 3           		  		          */
/* 3. Write a query that returns the total number of female buyers (gender) who made
purchases in the Clothing category. */
--------------------------------------------------------------------------------
SELECT COUNT(customer_gender),customer_gender,product_category FROM customer_spending
WHERE customer_gender='F' AND product_category='Clothing'
GROUP BY customer_gender,product_category;  

--------------------------------------------------------------------------------
/*				                  Question 4           		  		          */
/* 4. Write a query that returns the age, sub_cateogry, average quantity (as a whole
number), and average cost of products purchased by each age and sub_category.
Output should show the columns in the same order they are listed. Organize the data by
age, oldest to youngest, and then by sub_category alphabetically. */

--------------------------------------------------------------------------------
SELECT customer_age,sub_category,AVG(quantity) AS avg_quantity,AVG(cost)
AS avg_cost FROM customer_spending
GROUP BY customer_age,sub_category
ORDER BY customer_age DESC,sub_category,avg_quantity,avg_cost;

--------------------------------------------------------------------------------
/*				                  Question 5           		  		          */
/* 5. Write a query that returns a list of countries where more than 30 transactions were
made by customers between the ages of 18-25 (inclusive). */

--------------------------------------------------------------------------------
SELECT country,COUNT(revenue) as transactions FROM customer_spending
WHERE customer_age BETWEEN 18 AND 25
GROUP BY country
HAVING COUNT(revenue)>30;    

--------------------------------------------------------------------------------
/*				                  Question 6           		  		          */
/*6. Write a query that returns a list of sub_categories along with their average quantity
and average cost, both rounded to 2 decimal places, and named as avg_quantity and
avg_cost respectively. Only include sub_categories that have at least 10 records in the
data set. Organize the data by sub_category alphabetically. */

--------------------------------------------------------------------------------
SELECT sub_category,ROUND(AVG(quantity),2) AS avg_quantity,
ROUND(AVG(cost),2) AS avg_cost FROM customer_spending
GROUP BY sub_category HAVING COUNT(sub_category)>=10
ORDER BY sub_category;