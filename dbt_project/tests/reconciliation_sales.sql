WITH source_sales AS
(
    SELECT 
    SUM(price) AS price,
    SUM(freight_value) AS freight_value,
    SUM(COALESCE(price, 0) + COALESCE(freight_value, 0)) AS total_sales_amount
    FROM {{ ref('stg_order_items') }}
),
fact_sales AS
(
    SELECT 
    SUM(price) AS price,
    SUM(freight_value) AS freight_value,
    SUM(total_sales_amount) AS total_sales_amount
    FROM {{ ref('fact_sales') }}
)

SELECT *
FROM fact_sales fs
CROSS JOIN source_sales ss
WHERE ABS(fs.price - ss.price) > 0.01
    OR ABS(fs.freight_value - ss.freight_value) > 0.01
    OR ABS(fs.total_sales_amount - ss.total_sales_amount) > 0.01