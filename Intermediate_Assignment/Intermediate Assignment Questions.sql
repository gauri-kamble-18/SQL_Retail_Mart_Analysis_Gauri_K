-- INTERMEDIATE ASSIGNMENTS
-- 1)Select the number of orders per campaign and order by the number of orders in descending order.

SELECT COUNT(order_id) AS order_count, campaign_id 
FROM tbl_orders 
GROUP BY campaign_id 
ORDER BY order_count DESC;

SELECT 
    c.campaign_id, c.campaign_name,
    COUNT(o.order_id) AS number_of_orders
FROM 
    tbl_campaign c
LEFT JOIN 
    tbl_orders o ON c.campaign_id = o.campaign_id
GROUP BY 
    c.campaign_id, c.campaign_name
ORDER BY 
    number_of_orders DESC;
    
-- 2)Find the average order amount for each campaign.
SELECT AVG(total_amount),campaign_id FROM tbl_orders GROUP BY campaign_id;

SELECT 
    c.campaign_id, 
    c.campaign_name, 
    AVG(o.total_amount) AS average_order_amount
FROM 
    tbl_campaign c
LEFT JOIN 
    tbl_orders o ON c.campaign_id = o.campaign_id
GROUP BY 
    c.campaign_id, c.campaign_name;
    
-- 3)Select the products that have been ordered more than 100 times in total.
SELECT 
	p.product_id,p.product_name,SUM(oi.quantity) 
FROM 
	tbl_order_items oi 
JOIN  
	tbl_products p 
ON 
	oi.product_id = p.product_id 
GROUP BY 
	p.product_id, p.product_name 
HAVING 
	SUM(oi.quantity)>100;

-- 4)Find the total sales for each region and order by sales in descending order.
SELECT 
    c.region,
    SUM(oi.quantity * oi.price) AS total_sales
FROM 
    tbl_orders o
JOIN 
    tbl_order_items oi ON o.order_id = oi.order_id
JOIN 
    tbl_campaign c ON o.campaign_id = c.campaign_id
GROUP BY 
    c.region
ORDER BY 
    total_sales DESC;
    
-- 5)Select the average amount spent per customer and order by this average in descending order.
SELECT 
	name,customer_id,AVG(total_spent) AS total_amount_spent 
FROM 
	tbl_customers 
GROUP BY 
	name,customer_id 
ORDER BY 
	total_amount_spent DESC;

-- 6)Select the most popular product in each category.
SELECT 
	p.category,p.product_id,p.product_name,SUM(oi.quantity) AS total_sold 
FROM 
	tbl_order_items oi  
JOIN 
	tbl_products p 
ON oi.product_id = p.product_id 
GROUP BY category,product_id,product_name 
ORDER BY total_sold DESC;


-- 7)Find the total budget of all campaigns that have ended.
SELECT 
	campaign_id,campaign_name,SUM(budget) AS total_budget 
FROM tbl_campaign 
WHERE end_date < NOW() 
GROUP BY campaign_id;

-- 8)Get order details along with campaign names.
SELECT o.order_id,o.order_date,o.customer_id,o.total_amount,c.campaign_name FROM tbl_orders o 
JOIN tbl_campaign c ON o.campaign_id = c.campaign_id;

-- 9)Get product details for each order item.
SELECT p.product_id, p.product_name, p.category, p.price,oi.order_item_id,oi.order_id 
FROM tbl_products p 
JOIN tbl_order_items oi 
ON p.product_id = oi.product_id;

-- 10)Aggregate the total revenue per campaign.
SELECT c.campaign_id,c.campaign_name, SUM(oi.quantity * oi.price) AS total_revenue 
FROM tbl_campaign c 
JOIN tbl_orders o ON c.campaign_id = o.campaign_id 
JOIN tbl_order_items oi ON o.order_id = oi.order_id 
GROUP BY c.campaign_id, c.campaign_name;

-- 11)Find the total number of orders placed per region.
SELECT COUNT(o.order_id) as total_orders_placed,c.region 
FROM tbl_orders o 
JOIN tbl_campaign c ON o.campaign_id=c.campaign_id 
GROUP BY c.region;

-- 12)Find the total amount spent by each customer on each campaign.
SELECT c.total_spent AS total_spent,c.name,ca.campaign_id,campaign_name 
FROM tbl_customers c 
JOIN tbl_orders o ON c.customer_id=o.customer_id 
JOIN tbl_campaign ca ON o.campaign_id=ca.campaign_id;

-- 13)Use Aggregate Functions to find the average budget of all campaigns and group by region.
SELECT 
    region, 
    AVG(budget) AS average_budget
FROM 
    tbl_campaign
GROUP BY 
    region;

-- 14)Filter campaigns with a total spending greater than their budget using a sub-query.
SELECT AVG(budget),region,GROUP_CONCAT(campaign_id) AS campaign_ids,
    GROUP_CONCAT(campaign_name) AS campaign_names FROM tbl_campaign GROUP BY region;
    

SELECT 
    c.campaign_id,
    c.campaign_name,
    c.budget
FROM 
    tbl_campaign c
WHERE 
    (SELECT SUM(oi.price * oi.quantity)
     FROM tbl_orders o
     JOIN tbl_order_items oi ON o.order_id = oi.order_id
     WHERE o.campaign_id = c.campaign_id) > c.budget;
     
-- 15)Calculate the total quantity sold and average price per product.

SELECT SUM(quantity),AVG(price) 
FROM tbl_order_items 
GROUP BY product_id;

SELECT SUM(oi.quantity),AVG(oi.price),p.product_id,p.product_name 
FROM tbl_order_items oi 
JOIN tbl_products p ON oi.product_id=p.product_id 
GROUP BY p.product_id,p.product_name;

-- 16)Aggregate the total quantity sold per product.
SELECT COUNT(oi.quantity) AS total_quantity,p.product_id,p.product_name 
FROM tbl_order_items oi 
JOIN tbl_products p ON oi.product_id=p.product_id 
GROUP BY p.product_id,p.product_name;

-- 17)Find campaigns with an average order amount greater than $200.
SELECT AVG(o.total_amount) AS AVG_ORDER_AMOUNT, c.campaign_id,c.campaign_name 
FROM tbl_orders o 
JOIN tbl_campaign c ON o.campaign_id=c.campaign_id 
GROUP BY c.campaign_id,c.campaign_name 
HAVING AVG(o.total_amount) > 200;

    
-- 18)Find the top 10 products with the highest total sales amount and order by sales in descending order.
SELECT p.product_name,p.product_id,SUM(oi.quantity*oi.price) as total_sales_amount 
FROM tbl_products p 
JOIN tbl_order_items oi ON p.product_id=oi.product_id 
GROUP BY p.product_name,p.product_id 
ORDER BY total_sales_amount DESC LIMIT 10;

-- 19)Find products with less than 20 units in stock and order it using stock quantity.
SELECT p.product_id,p.product_name, i.stock_quantity 
FROM tbl_products p 
JOIN tbl_inventory i ON p.product_id=i.product_id 
WHERE i.stock_quantity < 20;

-- 20)Find customers who spent more than the average amount spent per customer in the last 6 months.

SELECT 
    customer_id, 
    name 
FROM 
    tbl_customers 
WHERE 
    join_date > DATE_SUB(NOW(), INTERVAL 6 MONTH) 
    AND total_spent > (SELECT AVG(total_spent) 
                       FROM tbl_customers 
                       WHERE join_date > DATE_SUB(NOW(), INTERVAL 6 MONTH));
                       