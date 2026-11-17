SELECT
    d.year,
    d.month,
    d.month_name,
    MIN(d.full_date) AS month_start_date,
    MAX(d.full_date) AS month_end_date,

    -- volume
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_key) AS total_customers,
    COALESCE(SUM(o.total_items), 0) AS total_items_sold,

    -- money
    COALESCE(SUM(o.total_order_value), 0) AS total_revenue,
    COALESCE(SUM(o.total_freight_value), 0) AS total_freight,
    COALESCE(SUM(o.total_order_value + o.total_freight_value), 0) AS total_revenue_with_freight,
    COALESCE(AVG(o.total_order_value), 0) AS avg_order_value,

    -- delivery quality
    COALESCE(AVG(o.delivery_days_actual), 0) AS avg_delivery_days,
    SUM(CASE WHEN o.is_late_delivery THEN 1 ELSE 0 END) AS late_delivery_count,
    -- late rate = late / total
    CASE
        WHEN COUNT(o.order_id) = 0 THEN 0
        ELSE SUM(CASE WHEN o.is_late_delivery THEN 1 ELSE 0 END) * 1.0 / COUNT(o.order_id)
    END AS late_delivery_rate,

    -- satisfaction
    COALESCE(AVG(o.total_order_value), 0) AS avg_order_value_check

FROM {{ ref('fact_orders') }} o
LEFT JOIN {{ ref('dim_dates') }} d
    ON o.order_date_key = d.date_key

GROUP BY ALL
ORDER BY d.year, d.month