WITH fact_totals AS
(
    SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(total_order_value) AS total_revenue,
    SUM(total_freight_value) AS total_freight,
    SUM(total_items) AS total_items
    FROM {{ ref('fact_orders') }}
),
mart_totals AS
(
    SELECT
    SUM(total_orders) AS total_orders,
    SUM(lifetime_value) AS total_revenue,
    SUM(lifetime_freight_payed) AS total_freight,
    SUM(total_items_purchased) AS total_items
    FROM {{ ref('mart_customer_metrics') }}
)

SELECT *
FROM mart_totals m
CROSS JOIN fact_totals f
WHERE m.total_orders != f.total_orders
    OR ABS(m.total_revenue - f.total_revenue) > 0.01
    OR ABS(m.total_freight - f.total_freight) > 0.01
    OR ABS(m.total_items - f.total_items) > 0.01