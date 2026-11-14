SELECT 
TRIM(seller_id) AS seller_id,
seller_zip_code_prefix,
TRANSLATE(LOWER(TRIM(seller_city)),
    'áàâãäéèêëíìîïóòôõöúùûüçñÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ',
    'aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN') AS seller_city,
LOWER(TRIM(seller_state)) AS seller_state
FROM {{source ('raw', 'sellers')}}