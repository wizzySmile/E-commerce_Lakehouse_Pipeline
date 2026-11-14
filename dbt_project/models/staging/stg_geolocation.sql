SELECT 
geolocation_zip_code_prefix,
geolocation_lat,
geolocation_lng,
TRANSLATE(LOWER(TRIM(geolocation_city)),
    'áàâãäéèêëíìîïóòôõöúùûüçñÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ',
    'aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN') AS geolocation_city,
TRIM(geolocation_state) AS geolocation_state
FROM {{source ('raw', 'geolocation')}}