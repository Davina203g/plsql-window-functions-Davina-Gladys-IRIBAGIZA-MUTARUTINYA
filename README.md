# plsql-window-functions-Davina-Gladys-IRIBAGIZA-MUTARUTINYA

Business context: Fresh Fruit Market is small fruit retail business operating through it's sales and operations department across 3 Regions of Rwanda (Kigali, Muhanga, Huye) serving customers through market stalls and retail shops, mobile vendors.

Data Challenge: The sales and operations department lacks insight into which fruits perform best by district and season, identifying valuable customers, and can not plan inventory allocation leading to waste and missed opportunities.

Expected Outcome: The analysis will help department identify top-performing fruits by region, segment customers for targeted market, optmise inventory aallocation and make data_driven decisions about expansion and product lines.

Success Criteria:

1.Top 5 products per region -> RANK():
Identify highest selling fruit in each region for each quarter to optmise inventory allocation.

2. Running monthly sales total -> SUM() Over():
   Track cumulative sales performance through out the month to monitor cashflow and seasonal trends.

3. Month-Over-Month growth -> LAG(), LEAD():
   Calculate percentage change in monthly sales compared to previous month to identify growth with patterns and declining performance.
   
4. Customer quartiles -> NTILE(4): segment customer into 4 value-based groups (high, medium-high, medium-low, low spenders) for targeted marketing strategies.

5. 3-month moving averages -> AVG(), OVER():
   Calculating rolling 3-month average sales by region to smoothen Seasonal fluctuation and identify underlying trends for inventory planning.

Databse schema:



Functions' queries:
1. Ranking functions:
   SELECT
    region,
    product_name,
    total_sales,
    total_quantity,
    row_number_rank,
    sales_rank,
    dense_sales_rank,
    percent_rank
FROM (
    SELECT
        c.region,
        p.name as product_name,
        SUM(t.total_amount) as total_sales,
        SUM(t.quantity) as total_quantity,
        ROW_NUMBER() OVER (PARTITION BY c.region ORDER BY SUM(t.total_amount) DESC) as row_number_rank,
        RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.total_amount) DESC) as sales_rank,
        DENSE_RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.total_amount) DESC) as dense_sales_rank,
        PERCENT_RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.total_amount) DESC) as percent_rank
    FROM transactions t
    JOIN products p ON t.product_id = p.product_id
    JOIN customers c ON t.customer_id = c.customer_id
    WHERE t.sale_date >= DATE '2024-01-01'
    GROUP BY c.region, p.name
)
WHERE sales_rank <= 5
ORDER BY region, sales_rank;

2. Aggregate Functions:
   SELECT
    sale_year,
    sale_month,
    monthly_sales,
    SUM(monthly_sales) OVER (
        PARTITION BY sale_year ORDER BY sale_month ROWS UNBOUNDED PRECEDING
    ) as running_total,
    AVG(monthly_sales) OVER (
        ORDER BY sale_year, sale_month ROWS 2 PRECEDING
    ) as moving_avg_3month,
    MAX(monthly_sales) OVER (ORDER BY sale_year, sale_month ROWS 2 PRECEDING) as max_3month,
    MIN(monthly_sales) OVER (ORDER BY sale_year, sale_month ROWS 2 PRECEDING) as min_3month
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) as sale_year,
        EXTRACT(MONTH FROM sale_date) as sale_month,
        SUM(total_amount) as monthly_sales
    FROM transactions
    WHERE sale_date >= DATE '2024-01-01'
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date))
ORDER BY sale_year, sale_month;

3. Navigation functions:
   SELECT
 region,
 sale_month,
 monthly_sales,
 LAG(monthly_sales, 1) OVER (
 PARTITION BY region
 ORDER BY sale_month
 ) as prev_month_sales,
 LEAD(monthly_sales, 1) OVER (
 PARTITION BY region
 ORDER BY sale_month
 ) as next_month_sales,
 ROUND(
 ((monthly_sales - LAG(monthly_sales, 1) OVER (
 PARTITION BY region
 ORDER BY sale_month
 )) * 100.0) /
 NULLIF(LAG(monthly_sales, 1) OVER (
 PARTITION BY region
 ORDER BY sale_month
 ), 0), 2
 ) as mom_growth_percent,
 CASE
 WHEN monthly_sales > LAG(monthly_sales, 1) OVER (
 PARTITION BY region ORDER BY sale_month
 ) THEN 'Growing'
 WHEN monthly_sales < LAG(monthly_sales, 1) OVER (
 PARTITION BY region ORDER BY sale_month
 ) THEN 'Declining'
 ELSE 'Stable'
 END as growth_trend
FROM (
 SELECT
 c.region,
 EXTRACT(MONTH FROM sale_date) as sale_month,
 SUM(t.total_amount) as monthly_sales
 FROM transactions t
 JOIN customers c ON t.customer_id = c.customer_id
 WHERE t.sale_date >= DATE '2024-01-01'
 GROUP BY c.region, EXTRACT(MONTH FROM sale_date)
) region_monthly_sales
ORDER BY region, sale_month;

4. Distribution functions:
   SELECT
 name as customer_name,
 region,
 total_spent,
 transaction_count,
 avg_transaction_value,
 NTILE(4) OVER (ORDER BY total_spent DESC) as customer_quartile,
 ROUND(CUME_DIST() OVER (ORDER BY total_spent DESC) * 100, 2) as cumulative_percentile,
 CASE 
 WHEN NTILE(4) OVER (ORDER BY total_spent DESC) = 1 THEN 'VIP Customers (Top 25%)'
 WHEN NTILE(4) OVER (ORDER BY total_spent DESC) = 2 THEN 'High Value (26-50%)'
 WHEN NTILE(4) OVER (ORDER BY total_spent DESC) = 3 THEN 'Medium Value (51-75%)'
 ELSE 'Basic Customers (Bottom 25%)'
 END as customer_segment,
 CASE
 WHEN NTILE(4) OVER (ORDER BY total_spent DESC) = 1 THEN 'Premium offers, exclusive events'
 WHEN NTILE(4) OVER (ORDER BY total_spent DESC) = 2 THEN 'Loyalty rewards, bulk discounts'
 WHEN NTILE(4) OVER (ORDER BY total_spent DESC) = 3 THEN 'Regular promotions, seasonal offers'
 ELSE 'Basic promotions, retention campaigns'
 END as marketing_strategy
FROM (
 SELECT
 c.name,
 c.region,
 SUM(t.total_amount) as total_spent,
 COUNT(t.transaction_id) as transaction_count,
 ROUND(AVG(t.total_amount), 2) as avg_transaction_value
 FROM customers c
 JOIN transactions t ON c.customer_id = t.customer_id
 WHERE t.sale_date >= DATE '2024-01-01'
 GROUP BY c.customer_id, c.name, c.region
 HAVING COUNT(t.transaction_id) >= 2 
) customer_summary
ORDER BY total_spent DESC;


Results Analysis:




References:




All sources were properly cited. Implementations and analysis represent original work. No AI-
generated content was copied without attribution or adaptation.

Integrity Statement: 
I hereby declare that this assignment contains my original work with. No AI tools were used to generate content. All references were properly cited.
   
