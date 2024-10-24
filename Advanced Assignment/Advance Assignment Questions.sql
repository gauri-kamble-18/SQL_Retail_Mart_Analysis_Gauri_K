-- ADVANCE ASSIGNMENTS
-- Indexes
USE db_retail_mart;

CREATE INDEX idx_campaign_budget ON tbl_campaign(budget);
-- Reason:This index will speed up queries that involve filtering or sorting campaigns based on their budget, such as selecting campaigns with the highest and lowest budgets.

CREATE INDEX idx_products_category ON tbl_products(category);
-- Reason:This index will enhance performance when calculating the average price of products across categories and ranking products based on total sales within each category.

CREATE INDEX idx_orders_campaign ON tbl_orders(campaign_id);
-- Reason:This index will help in efficiently retrieving orders associated with each campaign, which is useful for calculating total revenue and average order amounts per campaign.

CREATE INDEX idx_inventory_product ON tbl_inventory(product_id);
-- Reason:This index will facilitate quick lookups of stock quantities for products, especially when handling missing stock quantities and providing default values.

CREATE INDEX idx_order_items_order ON tbl_order_items(order_id);
-- Reason:This index allows for quick access to order items associated with each order, which is important for analyzing total quantity and revenue generated from each product by customer.

CREATE INDEX idx_orders_date_customer ON tbl_orders(order_date, customer_id);
-- Reason:This composite index will help optimize queries that analyze sales trends over time, such as evaluating growth rates of sales for each campaign.

CREATE INDEX idx_customers_total_spent ON tbl_customers(total_spent);
-- Reason:This index supports the query to find the top  customers who consistently spend.

CREATE INDEX idx_campaign_region ON tbl_campaign(region);
-- Reason:This index can help with partitioning the sales data to compare the performance of different regions.


-- 1)Select the campaigns with the highest and lowest budgets.
--    - Find the highest and lowest budgets.
--    - Use RANK() to assign rankings.
WITH ranked_campaigns AS (
    SELECT 
        campaign_id,
        campaign_name,
        budget,
        RANK() OVER (ORDER BY budget DESC) AS budget_rank_high,
        RANK() OVER (ORDER BY budget ASC) AS budget_rank_low
    FROM 
        tbl_campaign
)
SELECT 
    campaign_id,
    campaign_name,
    budget,
    CASE 
        WHEN budget_rank_high = 1 THEN 'Highest'
        WHEN budget_rank_low = 1 THEN 'Lowest'
    END AS budget_type
FROM 
    ranked_campaigns
WHERE 
    budget_rank_high = 1 OR budget_rank_low = 1;

-- 2)Find the average price of products across all categories.
--    - Group products by category.
--    - Use AVG() to calculate the average price for each category.
SELECT 
    category,
    AVG(price) AS average_price
FROM 
    tbl_products
GROUP BY 
    category;

-- 3)Rank products based on their total sales within each category.
--    - Join products with order items to calculate total sales per product.
--    - Use DENSE_RANK() to assign rankings within each category.

WITH product_sales AS (
    -- Step 1: Calculate total sales for each product in each category
    SELECT 
        p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity * oi.price) AS total_sales
    FROM 
        tbl_products p
    JOIN 
        tbl_order_items oi ON p.product_id = oi.product_id
    GROUP BY 
        p.product_id, p.product_name, p.category
),
ranked_products AS (
    -- Step 2: Rank products within each category based on total sales
    SELECT 
        product_id,
        product_name,
        category,
        total_sales,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY total_sales DESC) AS sales_rank
    FROM 
        product_sales
)

-- Step 3: Select the final output
SELECT 
    product_id,
    product_name,
    category,
    total_sales,
    sales_rank
FROM 
    ranked_products
ORDER BY 
    category, sales_rank;

-- 4)Create a CTE to calculate the total revenue and average order amount for each campaign.
--    - Use SUM() to calculate total revenue for each campaign.
--    - Use AVG() to calculate the average order amount per campaign.
WITH CampaignRevenue AS (
    SELECT 
        o.campaign_id,
        SUM(o.total_amount) AS total_revenue,
        AVG(o.total_amount) AS average_order_amount
    FROM 
        tbl_orders o
    GROUP BY 
        o.campaign_id
)

SELECT 
    c.campaign_id,
    c.campaign_name,
    cr.total_revenue,
    cr.average_order_amount
FROM 
    tbl_campaign c
JOIN 
    CampaignRevenue cr ON c.campaign_id = cr.campaign_id;

-- 5)Handle any missing stock quantities and provide a default value of 0 for products with no recorded inventory.
--    - Join products with inventory data.
--    - Use COALESCE() to replace missing stock quantities with 0.
    
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    COALESCE(i.stock_quantity, 0) AS stock_quantity
FROM 
    tbl_products p
LEFT JOIN 
    tbl_inventory i ON p.product_id = i.product_id
ORDER BY 
    p.product_id;


-- 6)Analyse the total quantity and revenue generated from each product by customer.
--    - Join customers, orders, order items, and products.
--    - Use SUM() to calculate total quantity and total revenue for each product per customer.
SELECT c.name AS customer_name, p.product_name,
       SUM(oi.quantity) AS total_quantity,
       SUM(oi.quantity * oi.price) AS total_revenue
FROM 
    tbl_customers c
JOIN 
    tbl_orders o ON c.customer_id = o.customer_id
JOIN 
    tbl_order_items oi ON o.order_id = oi.order_id
JOIN 
    tbl_products p ON oi.product_id = p.product_id
GROUP BY 
    c.name, p.product_name;

-- 7)Find campaigns that have a higher average order amount than the overall average.
--    - Group orders by campaign and calculate the average order amount.
--    - Use HAVING to filter campaigns where the average order amount exceeds the overall average.
SELECT c.campaign_id, c.campaign_name, AVG(o.total_amount) AS avg_order_amount
FROM
	tbl_campaign c
JOIN
	tbl_orders o
ON c.campaign_id=o.campaign_id
GROUP BY
	c.campaign_id,c.campaign_name
HAVING
	AVG(o.total_amount) > (SELECT AVG(total_amount) FROM tbl_orders);
    

-- 8)Analyse the rolling average of sales per campaign over the last 3 months.
--    - Use SUM() to calculate total sales per month for each campaign.
--    - Use a window function to calculate the rolling average sales over the last 3 months.
WITH monthly_sales AS (
    SELECT 
        campaign_id,
        DATE_FORMAT(order_date, '%Y-%m-01') AS sales_month,  -- Truncate to month
        SUM(total_amount) AS total_sales
    FROM 
        tbl_orders
    WHERE 
        order_date >= CURRENT_DATE - INTERVAL 3 MONTH
    GROUP BY 
        campaign_id, sales_month
),
rolling_avg_sales AS (
    SELECT 
        campaign_id,
        sales_month,
        AVG(total_sales) OVER (PARTITION BY campaign_id ORDER BY sales_month 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_average_sales
    FROM 
        monthly_sales
)
SELECT 
    campaign_id,
    sales_month,
    rolling_average_sales,
    DATE_FORMAT(sales_month, '%M') AS month_name  -- Format month name
FROM 
    rolling_avg_sales
ORDER BY 
    campaign_id, sales_month;

    
-- 9)Calculate the growth rate of sales for each campaign over time and rank them accordingly
--    - Use LAG() to calculate the previous month's sales for each campaign.
--    - Use RANK() to rank campaigns based on sales growth.
USE db_retail_mart;
WITH sales_per_month AS (
    SELECT 
        c.campaign_name,
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(o.total_amount) AS total_sales
    FROM tbl_orders o
    JOIN tbl_campaign c ON o.campaign_id = c.campaign_id
    GROUP BY c.campaign_name, DATE_FORMAT(o.order_date, '%Y-%m')
),
sales_growth AS (
    SELECT 
        campaign_name,
        month,
        total_sales,
        LAG(total_sales) OVER (PARTITION BY campaign_name ORDER BY month) AS previous_sales,
        (total_sales - LAG(total_sales) OVER (PARTITION BY campaign_name ORDER BY month)) / 
        LAG(total_sales) OVER (PARTITION BY campaign_name ORDER BY month) * 100 AS growth_rate
    FROM sales_per_month
)
SELECT 
    campaign_name,
    month,
    total_sales,
    growth_rate,
    RANK() OVER (ORDER BY growth_rate DESC) AS growth_rank
FROM sales_growth
WHERE growth_rate IS NOT NULL
ORDER BY growth_rank;

    
-- 10)Use CTEs and Window Functions to find the top 5 customers who have consistently spent above the 75th percentile of customer spending.
--    - Calculate the 75th percentile of total spending using a window function.
--    - Filter customers whose total spending is above the 75th percentile.
WITH Percentile AS (
    SELECT 
        total_spent,
        @row_num := @row_num + 1 AS rn,
        @total_count AS total_count
    FROM tbl_customers, (SELECT @row_num := 0, @total_count := COUNT(*) FROM tbl_customers) AS init
    ORDER BY total_spent
),
Percentile_Value AS (
    SELECT 
        total_spent
    FROM Percentile
    WHERE rn = FLOOR(total_count * 0.75) + 1  -- Get the 75th percentile value
),
Consistent_Customers AS (
    SELECT 
        customer_id,
        SUM(total_spent) AS total_spent,
        COUNT(CASE WHEN total_spent > (SELECT total_spent FROM Percentile_Value) THEN 1 END) AS above_percentile_count
    FROM tbl_customers
    GROUP BY customer_id
)
SELECT customer_id, total_spent
FROM Consistent_Customers
WHERE above_percentile_count > 0
ORDER BY total_spent DESC
LIMIT 5;


-- 11)Use Advanced Sub-Queries to find the correlation between campaign budgets and total revenue generated.
--    - Join campaigns with orders to aggregate total sales per region.
--    - Group results by region.
WITH campaign_revenue AS (
    -- Step 1: Calculate total revenue for each campaign
    SELECT 
        c.campaign_id,
        c.campaign_name,
        c.budget,
        SUM(o.total_amount) AS total_revenue
    FROM 
        tbl_campaign c
    JOIN 
        tbl_orders o ON c.campaign_id = o.campaign_id
    GROUP BY 
        c.campaign_id, c.campaign_name, c.budget
),
budget_ranges AS (
    -- Step 2: Define budget ranges
    SELECT 
        campaign_id,
        campaign_name,
        budget,
        total_revenue,
        CASE
            WHEN budget BETWEEN 0 AND 10000 THEN '0-10K'
            WHEN budget BETWEEN 10001 AND 20000 THEN '10K-20K'
            WHEN budget BETWEEN 20001 AND 30000 THEN '20K-30K'
            WHEN budget BETWEEN 30001 AND 50000 THEN '30K-50K'
            ELSE '50K+'
        END AS budget_range
    FROM 
        campaign_revenue
)
-- Step 3: Select data grouped by budget range
SELECT 
    budget_range,
    JSON_OBJECTAGG(campaign_name, total_revenue) AS campaigns_revenue_dict
FROM 
    budget_ranges
GROUP BY 
    budget_range;
-- option 2
SELECT 
    c.campaign_id,
    c.campaign_name,
    c.budget,
    COALESCE(SUM(o.total_amount), 0) AS total_revenue
FROM 
    tbl_campaign c
LEFT JOIN 
    tbl_orders o ON c.campaign_id = o.campaign_id
GROUP BY 
    c.campaign_id, c.campaign_name, c.budget;
    
-- 12)Partition the sales data to compare the performance of different regions and identify any anomalies.
--    - Use DENSE_RANK() to rank the regions based on average sales.
--    - Partition the data by region to compare performance across regions.
SELECT region, AVG(total_amount) AS avg_sales,
      DENSE_RANK() OVER (ORDER BY AVG(total_amount) DESC) AS sales_rank
FROM 
    tbl_campaign c
JOIN 
    tbl_orders o ON c.campaign_id = o.campaign_id
GROUP BY 
    region;
    
-- 13)Analyse the impact of product categories on campaign success.
--    - Summarize the total revenue and total orders for each product category.
--    - Join products, order items, orders, and campaigns to link categories with campaign success metrics.
SELECT p.category, SUM(o.total_amount) AS total_revenue,
       COUNT(o.order_id) AS total_orders
FROM 
    tbl_products p
JOIN 
    tbl_order_items oi ON p.product_id = oi.product_id
JOIN 
    tbl_orders o ON oi.order_id = o.order_id
JOIN 
    tbl_campaign c ON o.campaign_id = c.campaign_id
GROUP BY 
    p.category;
    
-- option 2
    
WITH CampaignRevenue AS (
    SELECT 
        c.campaign_id,
        c.campaign_name,
        p.category,
        SUM(o.total_amount) AS total_revenue
    FROM 
        tbl_campaign c
    JOIN 
        tbl_orders o ON c.campaign_id = o.campaign_id
    JOIN 
        tbl_order_items oi ON o.order_id = oi.order_id
    JOIN 
        tbl_products p ON oi.product_id = p.product_id
    GROUP BY 
        c.campaign_id, c.campaign_name, p.category
)

SELECT 
    category,
    COUNT(DISTINCT campaign_id) AS campaign_count,
    SUM(total_revenue) AS total_revenue,
    AVG(total_revenue) AS avg_revenue_per_campaign
FROM 
    CampaignRevenue
GROUP BY 
    category
ORDER BY 
    total_revenue DESC;
    
-- 14)Compute the moving average of sales per region and analyze trends.
--    - Calculate a moving average of sales for each region over time using a window function.
--    - Partition by region to observe trends in sales over time.
SELECT 	c.region,o.order_date,
	AVG(o.total_amount) OVER (PARTITION BY c.region ORDER BY o.order_date
ROWS BETWEEN UNBOUNDED PRECEDING AND current row) AS moving_avg_sales
FROM tbl_campaign c
JOIN tbl_orders o ON c.campaign_id = o.campaign_id;
    
-- 15)Evaluate the effectiveness of campaigns by comparing the pre-campaign and post-campaign average sales.
--    - Use CASE to distinguish between pre-campaign and post-campaign sales.
--    - Calculate average sales for both pre and post-campaign periods.
--    - Compute the difference in average sales and the percentage change to assess campaign effectiveness.
WITH sales_data AS (
    SELECT 
        c.campaign_id,
        c.campaign_name,
        CASE 
            WHEN o.order_date < c.start_date THEN 'Pre Campaign'
            WHEN o.order_date > c.end_date THEN 'Post Campaign'
        END AS duration,
        o.total_amount
    FROM 
        tbl_campaign c
    INNER JOIN 
        tbl_orders o ON c.campaign_id = o.campaign_id
    WHERE 
        o.order_date < c.start_date OR o.order_date > c.end_date
),
average_sales AS (
    SELECT 
        campaign_id,
        campaign_name,
        AVG(CASE WHEN duration = 'Pre Campaign' THEN total_amount END) AS avg_pre_sales,
        AVG(CASE WHEN duration = 'Post Campaign' THEN total_amount END) AS avg_post_sales
    FROM 
        sales_data
    GROUP BY 
        campaign_id, campaign_name
)
SELECT 
    campaign_id,
    campaign_name,
    COALESCE(avg_pre_sales, 0) AS avg_pre_sales,  -
    COALESCE(avg_post_sales, 0) AS avg_post_sales,  
    (COALESCE(avg_post_sales, 0) - COALESCE(avg_pre_sales, 0)) AS sales_difference,
    CASE 
        WHEN COALESCE(avg_pre_sales, 0) = 0 THEN NULL  
        ELSE (COALESCE(avg_post_sales, 0) - COALESCE(avg_pre_sales, 0)) / COALESCE(avg_pre_sales, 0) * 100 
    END AS effectiveness_percentage
FROM 
    average_sales;
        
    
        
