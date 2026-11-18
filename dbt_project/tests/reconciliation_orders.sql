WITH source_orders AS
(
    SELECT
    COUNT(*) AS order_count
    FROM {{ ref('stg_orders') }}
),
source_items AS
(
    SELECT
    COUNT(*) AS item_count,
    SUM(COALESCE(price, 0)) AS total_price,
    SUM(COALESCE(freight_value, 0)) AS total_freight
    FROM {{ ref('stg_order_items') }}
),
fact_orders AS
(
    SELECT
    COUNT(*) AS order_count,
    SUM(total_items) AS item_count,
    SUM(total_order_value) AS total_price,
    SUM(total_freight_value) AS total_freight
    FROM {{ ref('fact_orders') }}
)

SELECT *
FROM fact_orders f
CROSS JOIN source_orders so
CROSS JOIN source_items si
WHERE f.order_count != so.order_count
    OR f.item_count != si.item_count
    OR ABS(f.total_price - si.total_price) > 0.01
    OR ABS(f.total_freight - si.total_freight) > 0.01