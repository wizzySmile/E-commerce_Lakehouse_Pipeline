SELECT 
TRIM(order_id) AS order_id,
payment_sequential,
TRIM(payment_type) AS payment_type,
TRIM(payment_installments) AS payment_installments,
payment_value
FROM {{source ('raw', 'order_payments')}}