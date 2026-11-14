SELECT 
    pay.order_id,
    pay.payment_sequential,
    pt.payment_type_key,
    c.customer_key,
    CAST(strftime(
        CAST(order_purchase_date AS date),'%Y%m%d') AS bigint) AS order_date_key,

    pay.payment_installments,
    pay.payment_value

FROM {{ ref('stg_order_payments') }} pay

INNER JOIN {{ ref('stg_orders')}} ord
    ON pay.order_id = ord.order_id

LEFT JOIN {{ ref('dim_customers') }} c
    ON ord.customer_id = c.customer_id

LEFT JOIN {{ ref('dim_payment_types') }} pt
    ON  pay.payment_type = pt.payment_type
