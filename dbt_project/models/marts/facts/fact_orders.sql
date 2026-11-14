SELECT 
    ord.order_id,
    c.customer_key,
    CAST(strftime(
        CAST(ord.order_purchase_date AS date), '%Y%m%d') AS bigint) AS order_date_key,
    ord.order_status,
    DATE_DIFF('day', CAST(ord.order_purchase_date AS date), CAST(ord.order_delivered_customer_date AS date)) AS delivery_days_actual,
    DATE_DIFF('day', CAST(ord.order_purchase_date AS date), CAST(ord.order_estimated_delivery_date AS date)) AS delivery_days_estimated,
    CASE
        WHEN ord.order_delivered_customer_date > ord.order_estimated_delivery_date THEN TRUE
        ELSE FALSE
    END AS is_late_delivery,
    COUNT(DISTINCT oi.order_item_id) AS total_items,
    COUNT(DISTINCT oi.product_id) AS total_products,
    COALESCE(SUM(oi.price), 0)AS total_order_value,
    COALESCE(SUM(oi.freight_value), 0) AS total_freight_value
FROM {{ ref('stg_orders') }} ord

LEFT JOIN {{ ref('stg_order_items') }} oi
    ON ord.order_id = oi.order_id

LEFT JOIN {{ ref('dim_customers') }} c
    ON ord.customer_id = c.customer_id
GROUP BY ALL