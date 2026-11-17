SELECT 
    c.customer_key,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,

    -- activity
    COUNT(DISTINCT o.order_id) AS total_orders,
    MIN(d.full_date) AS first_order_date,
    MAX(d.full_date) AS last_order_date,
    DATEDIFF('day', MAX(d.full_date), CAST(NOW() AS DATE)) AS day_since_last_order,

    --money value
    COALESCE(SUM(o.total_order_value), 0) AS lifetime_value,
    COALESCE(AVG(o.total_order_value), 0) AS avg_order_value,
    COALESCE(SUM(o.total_freight_value), 0) AS lifetime_freight_payed,
    COALESCE(SUM(o.total_items), 0) AS total_items_purchased,

    -- customer delivery experience
    COALESCE(AVG(o.delivery_days_actual), 0) AS avg_delivery_days,
    SUM(CASE WHEN o.is_late_delivery 
            THEN 1 ELSE 0
        END) AS late_delivery_count,
    
    -- customer satisfaction score
    COALESCE(AVG(r.review_score), 0) AS avg_review_score,
    COUNT(r.review_id) AS total_review,
    
    -- customer payment
    COALESCE(AVG(p.payment_installments), 0) AS avg_installments,
    COUNT(DISTINCT p.payment_type_key) AS distinct_payment_methods_used

FROM {{ ref('dim_customers') }} c
LEFT JOIN {{ ref('fact_orders') }} o
    ON c.customer_key = o.customer_key

LEFT JOIN {{ ref('dim_dates') }} d
    ON o.order_date_key = d.date_key

LEFT JOIN {{ ref('fact_reviews') }} r
    ON c.customer_key = r.customer_key

LEFT JOIN {{ ref('fact_payments') }} p
    ON c.customer_key = p.customer_key

GROUP BY ALL
