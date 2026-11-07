SELECT 
TRIM(seller_id) AS seller_id,
seller_zip_code_prefix,
LOWER(TRIM(seller_city)) AS seller_city,
LOWER(TRIM(seller_state)) AS seller_state
FROM {{source ('raw', 'sellers')}}