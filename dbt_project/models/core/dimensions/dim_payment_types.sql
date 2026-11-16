WITH pay_type AS
    (
    SELECT DISTINCT
    payment_type
    FROM {{ ref('stg_order_payments') }}
    WHERE payment_type IS NOT NULL
    )
SELECT 
    ROW_NUMBER() OVER(ORDER BY payment_type) AS payment_type_key,
    payment_type
FROM pay_type