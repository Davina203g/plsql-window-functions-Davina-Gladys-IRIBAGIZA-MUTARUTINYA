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
