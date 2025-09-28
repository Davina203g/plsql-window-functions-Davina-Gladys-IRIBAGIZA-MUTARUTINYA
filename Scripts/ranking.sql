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
        -- ROW_NUMBER: Sequential ranking with no ties.
        ROW_NUMBER() OVER (PARTITION BY c.region ORDER BY SUM(t.total_amount) DESC) as row_number_rank,
         -- RANK: Ranking with gaps for ties if two products have same sales, they get same rank then skips next rank.
        RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.total_amount) DESC) as sales_rank,
        -- DENSE_RANK: Ranking with no gaps for ties if two products have same sales, they get same rank, next rank continues sequently wit no skipping
        DENSE_RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.total_amount) DESC) as dense_sales_rank,
        -- PERCENT_RANK: Percentage relative standing 0 = lowest sales, 1 = highest sales in a region.
        PERCENT_RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.total_amount) DESC) as percent_rank 
    FROM transactions t
    JOIN products p ON t.product_id = p.product_id
    JOIN customers c ON t.customer_id = c.customer_id
    WHERE t.sale_date >= DATE '2024-01-01'
    GROUP BY c.region, p.name
)
WHERE sales_rank <= 5
ORDER BY region, sales_rank;
-- INTERPRETATION:
-- 1. Shows which fruits sell best and where
-- 2. Helps optimize inventory allocation across regions.
-- 3. The ranking functions show many ways which can be used to compare performance.
-- 4. RANK() function is used for filtering. 
