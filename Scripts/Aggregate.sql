SELECT
    sale_year,
    sale_month,
    monthly_sales,
    -- RUNNING TOTAL: Tracks performance and overall growth path for each year
    SUM(monthly_sales) OVER (
        PARTITION BY sale_year ORDER BY sale_month ROWS UNBOUNDED PRECEDING
    ) as running_total,
    --3-MONTH MOVING AVERAGE: Provides trend direction
    AVG(monthly_sales) OVER (
        ORDER BY sale_year, sale_month ROWS 2 PRECEDING
    ) as moving_avg_3month,
    -- 3-MONTH MAXIMUM: Shows the highest sales in the recent 3 months
    MAX(monthly_sales) OVER (ORDER BY sale_year, sale_month ROWS 2 PRECEDING) as max_3month,
    -- 3-MONTH MINIMUM: Shows the lowest sales in the recent 3 months
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
--INTERPRETATION:
--The functions help to create an understandable view of sales performance through multiple time-based perspectives,
--which influences decison making 
