SELECT
TRIM(customer_id) AS customer_id,
customer_unique_id,
customer_zip_code_prefix,
TRANSLATE(TRIM(customer_city), 
    'áàâãäéèêëíìîïóòôõöúùûüçñÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ',
    'aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN') AS customer_city,
TRIM(customer_state) AS customer_state
FROM {{source ('raw', 'customers')}}