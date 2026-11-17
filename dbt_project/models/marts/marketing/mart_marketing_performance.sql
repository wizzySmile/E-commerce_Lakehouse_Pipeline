SELECT
    d.year,
    d.month,
    d.month_name,
    c.customer_state,
    c.customer_city,

    -- how many people
    COUNT(DISTINCT o.customer_key) AS total_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,

    -- how much money
    COALESCE(SUM(o.total_order_value), 0) AS total_revenue,
    COALESCE(AVG(o.total_order_value), 0) AS avg_order_value,

    -- how happy
    COALESCE(AVG(o.delivery_days_actual), 0) AS avg_delivery_days,
    SUM(CASE WHEN o.is_late_delivery THEN 1 ELSE 0 END) AS late_delivery_count

FROM {{ ref('fact_orders') }} o
LEFT JOIN {{ ref('dim_dates') }} d
    ON o.order_date_key = d.date_key
    
LEFT JOIN {{ ref('dim_customers') }} c
    ON o.customer_key = c.customer_key

GROUP BY ALL
ORDER BY d.year, d.month, c.customer_state