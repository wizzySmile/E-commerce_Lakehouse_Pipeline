WITH fact_totals AS
(
    SELECT
    COUNT(*) AS total_orders,
    SUM(total_items) AS total_items_sold,
    SUM(total_order_value) AS total_revenue,
    SUM(total_freight_value) AS total_freight
    FROM {{ ref('fact_orders') }}
),
mart_totals AS
(
    SELECT
    SUM(total_orders) AS total_orders,
    SUM(total_items_sold) AS total_items_sold,
    SUM(total_revenue) AS total_revenue,
    SUM(total_freight) AS total_freight
    FROM {{ ref('mart_monthly_revenue') }}
)

SELECT *
FROM mart_totals m
CROSS JOIN fact_totals f
WHERE m.total_orders != f.total_orders
    OR ABS(m.total_items_sold - f.total_items_sold) > 0.01
    OR ABS(m.total_revenue - f.total_revenue) > 0.01
    OR ABS(m.total_freight - f.total_freight) > 0.01