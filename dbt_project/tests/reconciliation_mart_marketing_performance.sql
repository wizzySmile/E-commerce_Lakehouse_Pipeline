WITH fact_totals AS
(
    SELECT
    COUNT(*) AS total_orders,
    SUM(total_order_value) AS total_revenue,
    SUM(CASE WHEN is_late_delivery THEN 1 ELSE 0 END) AS late_delivery_count
    FROM {{ ref('fact_orders') }}
),
mart_totals AS
(
    SELECT
    SUM(total_orders) AS total_orders,
    SUM(total_revenue) AS total_revenue,
    SUM(late_delivery_count) AS late_delivery_count
    FROM {{ ref('mart_marketing_performance') }}
)

SELECT *
FROM mart_totals m
CROSS JOIN fact_totals f
WHERE m.total_orders != f.total_orders
    OR ABS(m.total_revenue - f.total_revenue) > 0.01
    OR m.late_delivery_count != f.late_delivery_count