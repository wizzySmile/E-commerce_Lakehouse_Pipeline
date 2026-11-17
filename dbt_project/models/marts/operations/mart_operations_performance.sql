SELECT
    d.year,
    d.month,
    d.month_name,
    c.customer_state,

    -- volume
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(SUM(o.total_items), 0) AS total_items_shipped,

    -- delivery speed
    COALESCE(AVG(o.delivery_days_actual), 0) AS avg_delivery_days,
    COALESCE(AVG(o.delivery_days_estimated), 0) AS avg_estimated_days,
    COALESCE(SUM(o.total_freight_value), 0) AS total_freight_cost,

    -- late delivery
    SUM(CASE WHEN o.is_late_delivery THEN 1 ELSE 0 END) AS late_delivery_count,
    COUNT(DISTINCT o.order_id) AS orders_for_rate

FROM {{ ref('fact_orders') }} o
LEFT JOIN {{ ref('dim_dates') }} d
    ON o.order_date_key = d.date_key
LEFT JOIN {{ ref('dim_customers') }} c
    ON o.customer_key = c.customer_key

GROUP BY ALL
ORDER BY d.year, d.month, c.customer_state