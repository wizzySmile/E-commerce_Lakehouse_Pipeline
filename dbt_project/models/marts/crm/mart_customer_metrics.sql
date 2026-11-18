WITH orders_agg AS
(
    SELECT
    o.customer_key,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MIN(d.full_date) AS first_order_date,
    MAX(d.full_date) AS last_order_date,
    COALESCE(SUM(o.total_order_value), 0) AS lifetime_value,
    COALESCE(AVG(o.total_order_value), 0) AS avg_order_value,
    COALESCE(SUM(o.total_freight_value), 0) AS lifetime_freight_payed,
    COALESCE(SUM(o.total_items), 0) AS total_items_purchased,
    COALESCE(AVG(o.delivery_days_actual), 0) AS avg_delivery_days,
    SUM(CASE WHEN o.is_late_delivery THEN 1 ELSE 0 END) AS late_delivery_count
    FROM {{ ref('fact_orders') }} o
    LEFT JOIN {{ ref('dim_dates') }} d
        ON o.order_date_key = d.date_key
    GROUP BY o.customer_key
),
reviews_agg AS
(
    SELECT
    customer_key,
    COALESCE(AVG(review_score), 0) AS avg_review_score,
    COUNT(review_id) AS total_review
    FROM {{ ref('fact_reviews') }}
    GROUP BY customer_key
),
payments_agg AS
(
    SELECT
    customer_key,
    COALESCE(AVG(payment_installments), 0) AS avg_installments,
    COUNT(DISTINCT payment_type_key) AS distinct_payment_methods_used
    FROM {{ ref('fact_payments') }}
    GROUP BY customer_key
)

SELECT
    c.customer_key,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,

    COALESCE(o.total_orders, 0) AS total_orders,
    o.first_order_date,
    o.last_order_date,
    DATEDIFF('day', o.last_order_date, CAST(NOW() AS DATE)) AS day_since_last_order,

    COALESCE(o.lifetime_value, 0) AS lifetime_value,
    COALESCE(o.avg_order_value, 0) AS avg_order_value,
    COALESCE(o.lifetime_freight_payed, 0) AS lifetime_freight_payed,
    COALESCE(o.total_items_purchased, 0) AS total_items_purchased,

    COALESCE(o.avg_delivery_days, 0) AS avg_delivery_days,
    COALESCE(o.late_delivery_count, 0) AS late_delivery_count,

    COALESCE(r.avg_review_score, 0) AS avg_review_score,
    COALESCE(r.total_review, 0) AS total_review,

    COALESCE(p.avg_installments, 0) AS avg_installments,
    COALESCE(p.distinct_payment_methods_used, 0) AS distinct_payment_methods_used

FROM {{ ref('dim_customers') }} c
LEFT JOIN orders_agg o
    ON c.customer_key = o.customer_key
LEFT JOIN reviews_agg r
    ON c.customer_key = r.customer_key
LEFT JOIN payments_agg p
    ON c.customer_key = p.customer_key