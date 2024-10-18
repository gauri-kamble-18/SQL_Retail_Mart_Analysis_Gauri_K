USE db_retail_mart;
CREATE TABLE tbl_campaign (
    campaign_id INT PRIMARY KEY,
    campaign_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(10, 2),
    region VARCHAR(100)
);
CREATE TABLE tbl_customers (
	customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    join_date DATE,
    total_spent DECIMAL(10,2)
);
DROP TABLE tbl_orders;


CREATE TABLE tbl_orders (
	order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    campaign_id INT,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES tbl_customers(customer_id),
    FOREIGN KEY (campaign_id) REFERENCES tbl_campaign(campaign_id)
);

CREATE TABLE tbl_Order_Items (
	order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES tbl_orders(order_id)
);
CREATE TABLE tbl_products (
	product_id INT ,
    product_name VARCHAR(100),
    category VARCHAR(100),
    price DECIMAL(10,2)
);
ALTER TABLE tbl_products ADD PRIMARY KEY (product_id);
CREATE TABLE tbl_inventory (
    inventory_id INT PRIMARY KEY,
    product_id INT,
    stock_quantity INT,
    FOREIGN KEY (product_id) REFERENCES tbl_products(product_id)
);
SELECT COUNT(*) FROM tbl_campaign;
SELECT COUNT(*) FROM tbl_customers;
SELECT COUNT(*) FROM tbl_orders;
SELECT COUNT(*) FROM tbl_order_items;
SELECT COUNT(*) FROM tbl_products;
SELECT COUNT(*) FROM tbl_inventory;
SELECT * FROM tbl_campaign;

-- BASIC ASSIGNENTS
-- 1)Select all campaigns that are currently active.
SELECT *
FROM tbl_campaign
WHERE CURDATE() BETWEEN start_date AND end_date;

-- 2)Select all customers who joined after January 1, 2023.
SELECT *
FROM tbl_customers
WHERE join_date > '2023-01-01' ORDER BY join_date ASC;

-- 3)Select the total amount spent by each customer, ordered by amount in descending order.
SELECT customer_id,name,total_spent FROM tbl_customers ORDER BY total_spent DESC;

-- 4)Select the products with a price greater than $50.
SELECT product_id,product_name,price FROM tbl_products WHERE price > 50 ORDER BY price ASC;

-- 5)Select the number of orders placed in the last 30 days.
SELECT COUNT(*) FROM tbl_orders WHERE order_date >= CURDATE() - INTERVAL 30 DAY;
SELECT COUNT(*) AS number_of_orders
FROM tbl_orders
WHERE order_date >= CURDATE() + INTERVAL 30 DAY;

-- 6)Order the products by price in ascending order and limit the results to the top 5 most affordable products.
SELECT product_id,product_name,category,price FROM tbl_products ORDER BY price ASC LIMIT 5;

-- 7)Select the campaign names and their budgets
SELECT campaign_name,budget FROM tbl_campaign;

-- 8)Select the total quantity sold for each product, ordered by quantity sold in descending order.
SELECT oi.product_id, SUM(oi.quantity) AS total_quantity_sold
FROM tbl_order_items oi
JOIN tbl_orders o ON oi.order_id = o.order_id
GROUP BY oi.product_id
ORDER BY total_quantity_sold DESC;

-- 9)Select the details of orders that have a total amount greater than $100.
SELECT * FROM tbl_orders WHERE total_amount > 100;

-- 10)Find the total number of customers who have made at least one purchase.
SELECT COUNT(DISTINCT c.customer_id) AS total_customers_with_atleast_one_purchases
FROM tbl_customers c
JOIN tbl_orders o ON c.customer_id = o.customer_id;

-- 11)Select the top 3 campaigns with the highest budgets.
SELECT campaign_id, campaign_name FROM tbl_campaign ORDER BY budget DESC LIMIT 3;

-- 12)Select the top 5 customers with the highest total amount spent.
SELECT customer_id, name,total_spent FROM tbl_customers ORDER BY total_spent DESC LIMIT 5;
