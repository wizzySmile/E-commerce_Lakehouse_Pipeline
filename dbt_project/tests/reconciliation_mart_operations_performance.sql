WITH fact_totals AS
(
    SELECT
    COUNT(*) AS total_orders,
    SUM(total_items) AS total_items_shipped,
    SUM(total_freight_value) AS total_freight_cost,
    SUM(CASE WHEN is_late_delivery THEN 1 ELSE 0 END) AS late_delivery_count
    FROM {{ ref('fact_orders') }}
),
mart_totals AS
(
    SELECT
    SUM(total_orders) AS total_orders,
    SUM(total_items_shipped) AS total_items_shipped,
    SUM(total_freight_cost) AS total_freight_cost,
    SUM(late_delivery_count) AS late_delivery_count
    FROM {{ ref('mart_operations_performance') }}
)

SELECT *
FROM mart_totals m
CROSS JOIN fact_totals f
WHERE m.total_orders != f.total_orders
    OR ABS(m.total_items_shipped - f.total_items_shipped) > 0.01
    OR ABS(m.total_freight_cost - f.total_freight_cost) > 0.01
    OR m.late_delivery_count != f.late_delivery_count