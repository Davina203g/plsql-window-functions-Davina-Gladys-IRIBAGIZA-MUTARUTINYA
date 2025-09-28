SELECT
 name as customer_name,
 region,
 total_spent,
 transaction_count,
 avg_transaction_value,
 -- NTILE(4): Divide customers into 4 equal groups basing on the total spending
 NTILE(4) OVER (ORDER BY total_spent DESC) as customer_quartile,
 -- CUME_DIST(): Calculate percentage of cumulative distribution 
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
--INTERPRETATION:
--This query transforms raw transaction data into actionable customer intelligence 
--by segmenting customers into four value-based tiers(VIP,High Value, Medium Value, Basic Customers) 
--and assign targeted marketing strategies for each group respectively.
