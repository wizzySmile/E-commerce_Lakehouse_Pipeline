SELECT 
    oi.order_id,
    oi.order_item_id,

    c.customer_key,
    p.product_key,
    s.seller_key,

    cast(strftime(
        cast (o.order_purchase_date  AS date), '%Y%m%d') AS bigint) AS order_date_key,

    cast(strftime(
        cast(oi.shipping_limit_date AS date), '%Y%m%d') AS bigint) AS shipping_limit_date_key,

    oi.price,
    oi.freight_value,
    COALESCE(oi.price, 0) + COALESCE(oi.freight_value, 0) AS total_sales_amount

FROM {{ ref('stg_order_items') }} oi

INNER JOIN {{ ref('stg_orders') }} o
    ON oi.order_id = o.order_id

-- Joining facts to dims to get surrogate keys
LEFT JOIN {{ ref('dim_customers') }} c
    ON c.customer_id = o.customer_id

LEFT JOIN {{ ref('dim_products') }} p
    ON p.product_id = oi.product_id

LEFT JOIN {{ ref('dim_sellers') }} s
    ON s.seller_id = oi.seller_id