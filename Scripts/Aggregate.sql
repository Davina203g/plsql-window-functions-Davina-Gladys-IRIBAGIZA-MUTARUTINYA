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
--The running totals show how sales accumulate in the year, which is useful for checking overall growth. 
--The moving averages help smoothen seasonal ups and downs. 
--For example, if sales fall in June but rise again in July, the 3-month moving average shows the general trend not just the fall. 
--This makes it easier to plan ahead.
