# Basic Assignments Query Analysis

## 1. Select all campaigns that are currently active.
- **Techniques Used**: 
  - `CURDATE()`: Retrieves the current date to check if it falls within the campaign's start and end dates.
- **Why**: Identifies which marketing campaigns are currently running.
- **Actionable Insight**: Allocate resources to promote active campaigns, potentially increasing customer engagement and sales.

---

## 2. Select all customers who joined after January 1, 2023.
- **Techniques Used**: 
  - `ORDER BY`: Sorts customers by their join date.
- **Why**: Targets newly joined customers for engagement strategies.
- **Actionable Insight**: Design welcome campaigns tailored for recent joiners to foster loyalty early on.

---

## 3. Select the total amount spent by each customer, ordered by amount in descending order.
- **Techniques Used**: 
  - `ORDER BY`: Ranks customers based on their total spending.
- **Why**: Identifies high-value customers for targeted promotions.
- **Actionable Insight**: Create personalized offers for top spenders to increase retention.

---

## 4. Select the products with a price greater than $50.
- **Techniques Used**: 
  - `ORDER BY`: Sorts products by price in ascending order.
- **Why**: Helps identify premium products for potential marketing.
- **Actionable Insight**: Consider bundling high-priced products with discounts to stimulate sales.

---

## 5. Select the number of orders placed in the last 30 days.
- **Techniques Used**: 
  - `COUNT(*)`: Counts orders based on a date range.
- **Why**: Tracks recent sales activity to assess performance.
- **Actionable Insight**: Use this metric for sales forecasting and inventory management.

---

## 6. Order the products by price in ascending order and limit the results to the top 5 most affordable products.
- **Techniques Used**: 
  - `LIMIT`: Restricts results to the top 5 products.
- **Why**: Identifies affordable options for price-sensitive customers.
- **Actionable Insight**: Promote these low-cost products in marketing campaigns to attract budget-conscious shoppers.

---

## 7. Select the campaign names and their budgets.
- **Techniques Used**: 
  - Basic `SELECT` statement to retrieve specific fields.
- **Why**: Provides an overview of campaign budgets for financial planning.
- **Actionable Insight**: Adjust budget allocations based on campaign performance metrics.

---

## 8. Select the total quantity sold for each product, ordered by quantity sold in descending order.
- **Techniques Used**: 
  - `JOIN`: Combines order items and orders to aggregate data.
  - `SUM()`: Calculates the total quantity sold for each product.
  - `GROUP BY`: Groups results by product ID.
- **Why**: Identifies best-selling products to optimize inventory and marketing.
- **Actionable Insight**: Increase stock for high-selling products to meet demand and improve sales.

---

## 9. Select the details of orders that have a total amount greater than $100.
- **Techniques Used**: 
  - Basic `SELECT` with `WHERE` clause to filter results.
- **Why**: Identifies high-value orders for financial analysis.
- **Actionable Insight**: Analyze high-value orders to understand customer purchasing behavior and tailor marketing strategies.

---

## 10. Find the total number of customers who have made at least one purchase.
- **Techniques Used**: 
  - `JOIN`: Links customers and orders to find those who have made purchases.
  - `COUNT(DISTINCT)`: Counts unique customers.
- **Why**: Helps measure customer engagement and retention.
- **Actionable Insight**: Focus retention efforts on converting more customers into active buyers.

---

## 11. Select the top 3 campaigns with the highest budgets.
- **Techniques Used**: 
  - `ORDER BY`: Sorts campaigns by budget.
  - `LIMIT`: Restricts results to the top 3.
- **Why**: Identifies the most significant marketing investments.
- **Actionable Insight**: Reallocate resources to campaigns showing the most promise for returns.

---

## 12. Select the top 5 customers with the highest total amount spent.
- **Techniques Used**: 
  - `ORDER BY`: Ranks customers based on their total spending.
  - `LIMIT`: Restricts results to the top 5 customers.
- **Why**: Helps identify key customers who contribute significantly to revenue.
- **Actionable Insight**: Implement exclusive loyalty programs or rewards for top customers to encourage further spending.
