-- ADVANCE ASSIGNMENTS
-- Indexes
USE db_retail_mart;
SELECT * FROM tbl_campaign;
SELECT * FROM tbl_orders;
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
CREATE INDEX idx_campaign_budget ON tbl_campaign(budget);

SELECT campaign_id,campaign_name,budget FROM tbl_campaign ORDER BY budget DESC LIMIT 1;
SELECT campaign_id, campaign_name,budget FROM tbl_campaign ORDER BY budget ASC LIMIT 1;
(
    SELECT 
        campaign_id, 
        campaign_name, 
        budget, 
        'Highest Budget' AS budget_type
    FROM 
        tbl_campaign 
    ORDER BY 
        budget DESC 
    LIMIT 1
)

UNION ALL

(
    SELECT 
        campaign_id, 
        campaign_name, 
        budget, 
        'Lowest Budget' AS budget_type
    FROM 
        tbl_campaign 
    ORDER BY 
        budget ASC 
    LIMIT 1
);
SELECT 
    MAX(CASE WHEN budget = highest_budget THEN campaign_name END) AS highest_budget_campaign,
    MAX(CASE WHEN budget = lowest_budget THEN campaign_name END) AS lowest_budget_campaign,
    highest_budget,
    lowest_budget
FROM (
    SELECT 
        campaign_name,
        budget,
        (SELECT MAX(budget) FROM tbl_campaign) AS highest_budget,
        (SELECT MIN(budget) FROM tbl_campaign) AS lowest_budget
    FROM 
        tbl_campaign
) AS budget_info;

-- 2)Find the average price of products across all categories.
SELECT 
    category,
    AVG(price) AS average_price
FROM 
    tbl_products
GROUP BY 
    category;

-- 3)Rank products based on their total sales within each category.
SELECT 
	p.product_id,p.product_name, p.category,SUM(oi.quantity*oi.price) AS total_sales,
    RANK() OVER(PARTITION BY p.category ORDER BY SUM(oi.quantity*oi.price) DESC) AS productrank_over_the_total_sales_within_each_category
    FROM tbl_products p JOIN tbl_order_items oi ON p.product_id=oi.product_id 
    GROUP BY p.category,p.product_id,p.product_name 
    ORDER BY total_sales DESC;

-- 4)Create a CTE to calculate the total revenue and average order amount for each campaign.
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
SELECT * FROM tbl_inventory;
SELECT
	p.product_id,p.product_name,p.category,
    COALESCE(i.stock_quantity, 0) AS stock_quantity
FROM 
	tbl_products p 
JOIN 
	tbl_inventory i 
ON 
	p.product_id=i.product_id;


-- 6)Analyse the total quantity and revenue generated from each product by customer.
SELECT SUM(oi.quantity) AS total_quantity, SUM(oi.quantity*oi.price) AS revenue_generated,oi.product_id,c.customer_id
FROM 
	tbl_order_items oi
JOIN
	tbl_orders o
ON
	oi.order_id=o.order_id
JOIN
	tbl_customers c
ON o.customer_id=c.customer_id
GROUP BY c.customer_id,oi.product_id
ORDER BY c.customer_id, revenue_generated DESC;

-- 7)Find campaigns that have a higher average order amount than the overall average.
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
SELECT 
    campaign_id, 
    order_date, 
    AVG(total_amount) OVER (PARTITION BY campaign_id ORDER BY order_date) AS rolling_average_sales
FROM 
    tbl_orders
WHERE 
    order_date >= CURDATE() - INTERVAL 3 MONTH;
    

    
-- 9)Calculate the growth rate of sales for each campaign over time and rank them accordingly
SELECT 
    c.campaign_name,
    o.order_date,
    SUM(o.total_amount) AS total_sales,
    ((SUM(o.total_amount) - LAG(SUM(o.total_amount)) OVER (ORDER BY o.order_date)) /
     NULLIF(LAG(SUM(o.total_amount)) OVER (ORDER BY o.order_date), 0) * 100) AS growth_rate
FROM 
    tbl_campaign c
INNER JOIN 
    tbl_orders o ON c.campaign_id = o.campaign_id
GROUP BY 
    c.campaign_name, o.order_date
ORDER BY 
    o.order_date;
    
-- 10)Use CTEs and Window Functions to find the top 5 customers who have consistently spent above the 75th percentile of customer spending.
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
WITH TotalSalesByRegion AS (
    SELECT 
        c.region,
        SUM(o.total_amount) AS total_sales
    FROM 
        tbl_campaign c
    JOIN 
        tbl_orders o ON c.campaign_id = o.campaign_id
    GROUP BY 
        c.region
),
AverageSales AS (
    SELECT 
        AVG(total_sales) AS avg_sales
    FROM 
        TotalSalesByRegion
)

SELECT 
    ts.region,
    ts.total_sales,
    CASE 
        WHEN ts.total_sales < (SELECT avg_sales FROM AverageSales) * 0.8 THEN 'Anomaly: Low Sales'
        WHEN ts.total_sales > (SELECT avg_sales FROM AverageSales) * 1.2 THEN 'Anomaly: High Sales'
        ELSE 'Normal'
    END AS sales_status
FROM 
    TotalSalesByRegion ts
ORDER BY 
    ts.total_sales DESC;
    
-- 13)Analyse the impact of product categories on campaign success.
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
SELECT 	c.region,o.order_date,
	AVG(o.total_amount) OVER (PARTITION BY c.region ORDER BY o.order_date
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS moving_avg_sales
FROM tbl_campaign c
JOIN tbl_orders o ON c.campaign_id = o.campaign_id;
    
-- 15)Evaluate the effectiveness of campaigns by comparing the pre-campaign and post-campaign average sales.
WITH campaign_sales AS (
    SELECT 
        c.campaign_id,
        c.campaign_name,
        o.order_date,
        o.total_amount,
        CASE
            WHEN o.order_date < c.start_date THEN 'Pre-Campaign'
            WHEN o.order_date > c.end_date THEN 'Post-Campaign'
            ELSE 'During Campaign'
        END AS campaign_phase
    FROM 
        tbl_campaign c
    JOIN 
        tbl_orders o ON c.campaign_id = o.campaign_id
)

SELECT 
    campaign_id,
    campaign_name,
    AVG(CASE WHEN campaign_phase = 'Pre-Campaign' THEN total_amount END) AS avg_pre_campaign_sales,
    AVG(CASE WHEN campaign_phase = 'Post-Campaign' THEN total_amount END) AS avg_post_campaign_sales
FROM 
    campaign_sales
WHERE 
    campaign_phase IN ('Pre-Campaign', 'Post-Campaign')
GROUP BY 
    campaign_id, campaign_name
ORDER BY 
    campaign_id;
    
WITH sales_data AS (
	SELECT
		c.campaign_id,
        c.campaign_name,
        CASE
			WHEN o.order_date < c.start_date THEN 'Pre-Campaign'
            WHEN o.order_date > c.end_date THEN 'Post-Campaign'
		END AS duration,
        o.total_amount
	FROM
		tbl_campaign c
	INNER JOIN 
		tbl_orders o ON c.campaign_id = o.campaign_id
	WHERE
		(o.order_date < c.start_date OR o.order_date > c.end_date)
),
average_sales AS (
	SELECT
		campaign_id,
        campaign_name,
        AVG(CASE WHEN duration = 'Pre-Campaign' THEN total_amount END) AS avg_pre_sales,
        AVG(CASE WHEN duration = 'Post-Campaign' THEN total_amount END) AS avg_post_sales
	FROM
		sales_data
	GROUP BY 
		campaign_id,campaign_name
)
SELECT
	campaign_id,
    campaign_name,
    avg_pre_sales,
    avg_post_sales,
    (avg_post_sales - avg_pre_sales) AS sales_difference,
    CASE
		WHEN avg_pre_sales = 0 THEN NULL 
        ELSE (avg_post_sales - avg_pre_sales) / avg_pre_sales * 100
	END AS effectiveness_percentage
FROM 
	average_sales;
        
    
        



