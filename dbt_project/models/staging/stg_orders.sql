SELECT 
TRIM(order_id) AS order_id,
TRIM(customer_id) AS customer_id,
TRIM(order_status) AS order_status,
order_purchase_timestamp AS order_purchase_date,
order_approved_at,
order_delivered_carrier_date,
order_delivered_customer_date,
order_estimated_delivery_date
FROM {{source ('raw', 'orders')}}