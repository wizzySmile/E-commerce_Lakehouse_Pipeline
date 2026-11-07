SELECT 
TRIM(order_id) AS order_id,
TRIM(order_item_id) AS order_item_id,
TRIM(product_id) AS product_id,
TRIM(seller_id) AS seller_id,
shipping_limit_date,
price,
freight_value
FROM {{ source ('raw', 'order_items')}}