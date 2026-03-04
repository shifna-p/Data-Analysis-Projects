-- create database
CREATE DATABASE food_delivery;
USE food_delivery;

-- create tables
CREATE TABLE customers ( 
customer_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
signup_date DATE NOT NULL
);
CREATE TABLE restaurants (
restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
location VARCHAR(255) NOT NULL
);
CREATE TABLE orders (
order_id  INT PRIMARY KEY AUTO_INCREMENT,
customer_id INT NOT NULL,
restaurant_id INT NOT NULL,
order_date DATETIME NOT NULL,
delivery_date DATETIME NOT NULL,
total_amount DECIMAL (10,2),

FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id)
);

/** Monthly Revenue Growth
Calculates total revenue per month
**/
SELECT 
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,
SUM(total_amount) AS revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

/** Top 10 customers by life time values
Calculates total money spent per customer and rank top 10
**/
SELECT 
c.customer_id,
c.name,
c.email,
SUM(o.total_amount) AS lifetime_value
FROM customers c
JOIN orders o
on c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.email
ORDER BY lifetime_value DESC
LIMIT 10;

/**  Average delivery time(across all orders) 
Calculates average ddelivery time across all orders in minutes
**/
SELECT 
AVG(TIMESTAMPDIFF(MINUTE,order_date, delivery_date)) AS avg_delivery_time_minutes
FROM orders;

/** Average delivery time per restaurant 
Calculates average delivery time per restaurant and sorts ascending
**/
SELECT 
r.name,
AVG(TIMESTAMPDIFF(MINUTE,order_date,delivery_date)) AS avg_delivery_time_minutes
FROM orders o
JOIN restaurants r
ON o.restaurant_id = r.restaurant_id
GROUP BY r.name
ORDER BY avg_delivery_time_minutes ASC;

/** customer retention rate 
Calculates % of customers who returned the next month
**/
WITH monthly_customers AS (
SELECT 
YEAR(order_date) AS yr,
MONTH(order_date) AS mn,
customer_id
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date), customer_id
)
SELECT 
a.yr AS year,
a.mn AS month,
COUNT(DISTINCT a.customer_id) AS customers_this_month,
COUNT(DISTINCT b.customer_id) AS retained_next_month,
ROUND(COUNT(DISTINCT b.customer_id) / COUNT(DISTINCT a.customer_id) * 100 , 2) AS retention_rate_percent
FROM monthly_customers a
LEFT JOIN monthly_customers b
ON a.customer_id = b.customer_id
AND ((b.yr = a.yr AND b.mn = a.mn + 1) OR (b.yr = a.yr + 1 AND a.mn = 12 AND b.mn = 1 ))
GROUP BY a.yr, a.mn
ORDER BY a.yr, a.mn;

/** Top revenue generating restaurents 
Calculates total revenue per restaurant and ranks descending
**/
SELECT
r.restaurant_id,
r.name,
SUM(o.total_amount) AS total_revenue
FROM restaurants r
JOIN orders o
on r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.name
ORDER BY total_revenue DESC;
