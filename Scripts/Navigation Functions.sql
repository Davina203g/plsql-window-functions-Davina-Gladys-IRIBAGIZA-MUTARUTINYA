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
