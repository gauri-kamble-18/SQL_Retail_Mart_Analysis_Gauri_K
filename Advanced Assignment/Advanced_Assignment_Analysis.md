# SQL Advanced Query Analysis

## 1) Top Restaurants by Customer Rating

**Techniques Used**:
- **JOIN**: Combines restaurant and review data.
- **AVG()**: Calculates the average customer rating.
- **GROUP BY** and **ORDER BY**: Groups restaurants and ranks them based on the average rating.

**Why**: Helps identify restaurants with the highest customer satisfaction.

**Actionable Insight**: Consider promoting top-rated restaurants or implementing loyalty programs for them.

---

## 2) Average Spending Per Customer

**Techniques Used**:
- **JOIN**: Merges customer and order data.
- **SUM()** and **GROUP BY**: Aggregates the total spending per customer.

**Why**: Understanding spending behavior assists in customer segmentation and personalized offers.

**Actionable Insight**: Use this data to target high-value customers with exclusive deals or rewards.

---

## 3) Top Cities by Restaurant Count

**Techniques Used**:
- **GROUP BY** and **COUNT()**: Groups restaurants by city and counts the number of restaurants in each.

**Why**: Identifies key geographical areas where restaurant density is high.

**Actionable Insight**: Expand operations in cities with fewer restaurants or high demand to capture untapped markets.

---

## 4) Restaurants with Low Customer Ratings

**Techniques Used**:
- **JOIN**: Links restaurants and reviews.
- **HAVING** with **AVG()**: Filters restaurants based on a low average rating threshold.

**Why**: Identifying underperforming restaurants enables improvement strategies.

**Actionable Insight**: Investigate common issues and offer restaurant owners support in improving service or food quality.

---

## 5) Top 5 Most Popular Cuisines

**Techniques Used**:
- **JOIN**: Combines cuisine and restaurant data.
- **GROUP BY** and **COUNT()**: Ranks cuisines by the number of restaurants offering them.

**Why**: Knowing popular cuisines helps design menus and attract a wider audience.

**Actionable Insight**: Restaurants could introduce trending cuisines to diversify offerings.

---

## 6) Monthly Sales Trends for a Restaurant

**Techniques Used**:
- **GROUP BY** with **EXTRACT()**: Groups sales data by month.
- **SUM()**: Calculates total sales per month.

**Why**: Understanding sales trends helps in financial planning.

**Actionable Insight**: Adjust inventory and staffing based on predicted seasonal fluctuations.

---

## 7) Customer Loyalty Points Analysis

**Techniques Used**:
- **JOIN**: Combines customer and loyalty point data.
- **ORDER BY** and **LIMIT**: Ranks customers with the highest loyalty points.

**Why**: Identifies loyal customers who deserve rewards or special treatment.

**Actionable Insight**: Create a tiered rewards program for high-loyalty customers.

---

## 8) Orders with High Total Amounts

**Techniques Used**:
- **JOIN**: Links order and customer data.
- **HAVING**: Filters orders with a total amount above a threshold.

**Why**: Helps track high-value orders and monitor premium customers.

**Actionable Insight**: Introduce exclusive perks for customers making frequent high-value purchases.

---

## 9) Repeat Customers vs New Customers

**Techniques Used**:
- **JOIN**: Links orders with customer data.
- **CASE WHEN**: Differentiates between new and repeat customers based on order history.

**Why**: Understanding customer retention helps design better loyalty strategies.

**Actionable Insight**: Use this to design personalized outreach campaigns for new and repeat customers.

---

## 10) Identifying Customers Who Haven't Ordered Recently

**Techniques Used**:
- **DATEDIFF()**: Calculates the difference between the current date and the last order date.
- **JOIN**: Links customer and order data to identify inactive customers.
- **WHERE**: Filters customers whose last order is older than a set timeframe.

**Why**: Helps target re-engagement campaigns for inactive customers.

**Actionable Insight**: Automate this query to regularly track inactive customers and design retention strategies like discounts.

---

## 11) Determining Campaigns with the Highest ROI

**Techniques Used**:
- **Subqueries**: Calculate total revenue and campaign costs separately.
- **DIVISION**: Calculates ROI as the ratio of revenue to campaign spending.

**Why**: Helps identify the most cost-effective marketing campaigns.

**Actionable Insight**: Reallocate more budget to high-ROI campaigns and optimize low-performing ones.

---

## 12) Calculating Average Order Fulfillment Time

**Techniques Used**:
- **TIMESTAMPDIFF()**: Calculates time between order placement and fulfillment.
- **AVG()**: Computes the average fulfillment time.

**Why**: Measures operational efficiency.

**Actionable Insight**: Set targets for reducing fulfillment time to improve customer experience.

---

## 13) Identifying Top 10 Best-Selling Products by Quantity

**Techniques Used**:
- **JOIN**: Combines product and order data.
- **SUM()** and **GROUP BY**: Aggregates quantities sold per product.
- **ORDER BY** and **LIMIT**: Ranks products and limits to the top 10.

**Why**: Focuses on high-demand products to optimize inventory.

**Actionable Insight**: Replenish stock for best-sellers and design marketing strategies around them.

---

## 14) Detecting Sales Trends by Day of the Week

**Techniques Used**:
- **DAYOFWEEK()**: Extracts the day of the week from order dates.
- **GROUP BY** and **COUNT()**: Groups sales data by day and counts orders.

**Why**: Identifies high and low sales days to optimize promotions and staffing.

**Actionable Insight**: Schedule promotions on slower days to boost sales.

---

## 15) Calculating Monthly Revenue Growth Over Time

**Techniques Used**:
- **JOIN**: Links sales data by month.
- **SUM()** and **GROUP BY**: Aggregates revenue data monthly.
- **LAG()**: Compares current and previous month revenues for growth rates.

**Why**: Tracks financial health and identifies periods of growth.

**Actionable Insight**: Expand analysis to yearly growth for long-term trend monitoring and use it for decision-making on investments.
