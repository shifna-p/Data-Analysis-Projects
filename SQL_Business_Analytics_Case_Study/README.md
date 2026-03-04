# SQL Business Analytics Case Study – Food Delivery Platform

## 📌 Business Problem

A food delivery company wants to analyze its business performance by understanding:

- Revenue trends over time  
- Top customers by spending  
- Delivery efficiency  
- Customer retention  
- Revenue contributions of restaurants
  
These insights help the company make **data-driven decisions** and improve operational efficiency.
---
## 🗄️ Database Tables
| Table Name   | Columns                                                        | Description                                                        |
|--------------|----------------------------------------------------------------|--------------------------------------------------------------------|
| customers    | customer_id, name, email, signup_date                          | Stores customer information                                        |
| restaurants  | restaurant_id, name, location                                   | Stores restaurant information                                      |
| orders       | order_id, customer_id, restaurant_id, order_date, delivery_date, total_amount | Stores details of all orders, including total spent and timestamps |

---
## 🧮 SQL Queries and Logic

### 1️⃣ Monthly Revenue Growth
- **Purpose:** Calculates total revenue per month across all orders.  
- **Logic:** `SUM(total_amount)` grouped by `YEAR(order_date)` and `MONTH(order_date)`.

### 2️⃣ Top 10 Customers by Lifetime Value
- **Purpose:** Finds the customers who spent the most in total.  
- **Logic:** `SUM(total_amount)` per customer, ordered descending, limited to top 10.

### 3️⃣ Average Delivery Time (All Orders)
- **Purpose:** Calculates overall average delivery time in minutes.  
- **Logic:** Difference between `delivery_date` and `order_date` using `TIMESTAMPDIFF`.

### 4️⃣ Average Delivery Time per Restaurant
- **Purpose:** Calculates average delivery time for each restaurant to identify slow or fast performers.  
- **Logic:** Same as above, grouped by `restaurant_id` or `name`.

### 5️⃣ Customer Retention Rate
- **Purpose:** Measures the percentage of customers who returned the next month.  
- **Logic:** Compare unique customers month-over-month using a self-join of a monthly customer table.

### 6️⃣ Top Revenue-Generating Restaurants
- **Purpose:** Calculates total revenue per restaurant.  
- **Logic:** `SUM(total_amount)` grouped by `restaurant_id` and `name`, ordered descending.

---
## 📂 Data Source

Dataset used for this project is **publicly available from Kaggle**
