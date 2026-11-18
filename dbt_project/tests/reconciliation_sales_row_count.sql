WITH source_count AS 
(
    SELECT COUNT(*) AS cnt 
    FROM {{ ref('stg_order_items') }}
),
fact_count AS 
(
    SELECT COUNT(*) as cnt 
    FROM {{ ref('fact_sales') }}
)
SELECT * FROM source_count s 
CROSS JOIN fact_count f 
WHERE s.cnt != f.cnt