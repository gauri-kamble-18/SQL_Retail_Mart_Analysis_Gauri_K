# Intermediate Assignments Query Analysis

## 1. Select the number of orders per campaign and order by the number of orders in descending order.
- **Techniques Used**: 
  - `COUNT()`, `GROUP BY`, `LEFT JOIN`: Aggregates order counts by campaign.
- **Why**: To evaluate the performance of each campaign based on order volume.
- **Actionable Insight**: Identify campaigns that are underperforming and consider adjustments in strategy or budget allocation.

---

## 2. Find the average order amount for each campaign.
- **Techniques Used**: 
  - `AVG()`, `GROUP BY`, `LEFT JOIN`: Calculates average order amounts per campaign.
- **Why**: Provides insight into campaign profitability.
- **Actionable Insight**: Focus on campaigns with higher average order amounts for future investments.

---

## 3. Select the products that have been ordered more than 100 times in total.
- **Techniques Used**: 
  - `SUM()`, `HAVING`: Filters products based on total order quantities.
- **Why**: Identifies best-selling products to optimize inventory.
- **Actionable Insight**: Increase stock of high-demand products to meet customer needs.

---

## 4. Find the total sales for each region and order by sales in descending order.
- **Techniques Used**: 
  - `SUM()`, `JOIN`, `GROUP BY`: Aggregates sales data by region.
- **Why**: Assesses regional performance to inform marketing and distribution strategies.
- **Actionable Insight**: Allocate resources to regions with the highest sales potential.

---

## 5. Select the average amount spent per customer and order by this average in descending order.
- **Techniques Used**: 
  - `AVG()`, `GROUP BY`, `ORDER BY`: Calculates average spending per customer.
- **Why**: Identifies high-value customers for targeted marketing.
- **Actionable Insight**: Design loyalty programs aimed at increasing average spend among lower-spending customers.

---

## 6. Select the most popular product in each category.
- **Techniques Used**: 
  - `SUM()`, `GROUP BY`, `ORDER BY`: Determines best-selling products by category.
- **Why**: Identifies popular products to enhance marketing and inventory focus.
- **Actionable Insight**: Promote top-selling products more aggressively to maximize sales.

---

## 7. Find the total budget of all campaigns that have ended.
- **Techniques Used**: 
  - `SUM()`, `WHERE`, `GROUP BY`: Aggregates budgets for concluded campaigns.
- **Why**: Provides insights into financial commitments and past spending.
- **Actionable Insight**: Reassess future budget allocations based on past campaign performance.

---

## 8. Get order details along with campaign names.
- **Techniques Used**: 
  - `JOIN`: Merges order and campaign data for comprehensive reporting.
- **Why**: Facilitates analysis of campaign effectiveness on sales.
- **Actionable Insight**: Use this data for targeted follow-up campaigns based on order performance.

---

## 9. Get product details for each order item.
- **Techniques Used**: 
  - `JOIN`: Combines product and order item data for detailed insights.
- **Why**: Helps in understanding what products are associated with sales.
- **Actionable Insight**: Analyze product performance to inform future product development.

---

## 10. Aggregate the total revenue per campaign.
- **Techniques Used**: 
  - `SUM()`, `JOIN`, `GROUP BY`: Calculates total revenue generated from each campaign.
- **Why**: Measures campaign profitability and impact on revenue.
- **Actionable Insight**: Optimize future campaigns based on revenue performance metrics.

---

## 11. Find the total number of orders placed per region.
- **Techniques Used**: 
  - `COUNT()`, `JOIN`, `GROUP BY`: Aggregates order counts by region.
- **Why**: Provides insights into regional order distribution.
- **Actionable Insight**: Adjust marketing efforts based on regional order trends.

---

## 12. Find the total amount spent by each customer on each campaign.
- **Techniques Used**: 
  - `JOIN`: Merges customer, order, and campaign data.
- **Why**: Identifies customer spending behavior across campaigns.
- **Actionable Insight**: Develop targeted campaigns to encourage repeat purchases from customers who have previously spent.

---

## 13. Use Aggregate Functions to find the average budget of all campaigns and group by region.
- **Techniques Used**: 
  - `AVG()`, `GROUP BY`: Calculates average campaign budgets by region.
- **Why**: Assesses financial commitments to campaigns across different regions.
- **Actionable Insight**: Identify regions where budgets may need to be increased to boost marketing effectiveness.

---

## 14. Filter campaigns with a total spending greater than their budget using a sub-query.
- **Techniques Used**: 
  - Sub-query with `SUM()` and `WHERE`: Compares actual spending against budget.
- **Why**: Identifies campaigns that exceed budget constraints.
- **Actionable Insight**: Reassess budget allocation for over-spending campaigns to ensure financial health.

---

## 15. Calculate the total quantity sold and average price per product.
- **Techniques Used**: 
  - `SUM()`, `AVG()`, `GROUP BY`: Aggregates sales and price data for products.
- **Why**: Provides insights into product sales performance and pricing strategies.
- **Actionable Insight**: Adjust pricing strategies based on average selling prices and total sales.

---

## 16. Aggregate the total quantity sold per product.
- **Techniques Used**: 
  - `COUNT()`, `GROUP BY`: Counts total sales quantities per product.
- **Why**: Measures product demand and sales volume.
- **Actionable Insight**: Focus inventory management on products with high sales volume to prevent stockouts.

---

## 17. Find campaigns with an average order amount greater than $200.
- **Techniques Used**: 
  - `AVG()`, `HAVING`, `JOIN`: Filters campaigns based on order amounts.
- **Why**: Identifies successful campaigns that generate high-value orders.
- **Actionable Insight**: Reinforce marketing efforts on campaigns that yield higher order values.

---

## 18. Find the top 10 products with the highest total sales amount and order by sales in descending order.
- **Techniques Used**: 
  - `SUM()`, `ORDER BY`, `LIMIT`: Identifies best-selling products.
- **Why**: Prioritizes focus on products driving the most revenue.
- **Actionable Insight**: Promote these top products to maximize sales and customer interest.

---

## 19. Find products with less than 20 units in stock and order it using stock quantity.
- **Techniques Used**: 
  - `WHERE`, `ORDER BY`: Filters low-stock products.
- **Why**: Monitors inventory levels to prevent stockouts.
- **Actionable Insight**: Initiate reordering processes for low-stock items to maintain sales continuity.

---

## 20. Find customers who spent more than the average amount spent per customer in the last 6 months.
- **Techniques Used**: 
  - Sub-query with `AVG()`, `WHERE`: Filters customers based on their spending against an average.
- **Why**: Identifies high-value customers who contribute above-average spending.
- **Actionable Insight**: Target these customers with exclusive offers to enhance loyalty and further spending.
