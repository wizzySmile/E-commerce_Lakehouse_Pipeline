SELECT 
TRIM(product_id) AS product_id,
LOWER(TRIM(product_category_name)) AS product_category_name,
product_name_lenght,
product_description_lenght,
product_photos_qty,
product_weight_g,
product_length_cm,
product_height_cm,
product_width_cm
FROM {{source ('raw', 'products')}}