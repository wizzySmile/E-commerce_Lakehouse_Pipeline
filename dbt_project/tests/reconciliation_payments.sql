WITH source_payments AS
(
    SELECT 
    COUNT(*) AS row_count,
    SUM(payment_value) AS total_payment_value,
    SUM(payment_installments) AS total_installments
    FROM {{ ref('stg_order_payments') }}
),
fact_payments AS
(
    SELECT 
    COUNT(*) AS row_count,
    SUM(payment_value) AS total_payment_value,
    SUM(payment_installments) AS total_installments
    FROM {{ ref('fact_payments') }}
)

SELECT *
FROM fact_payments f
CROSS JOIN source_payments s
WHERE f.row_count != s.row_count
    OR ABS(f.total_payment_value - s.total_payment_value) > 0.01
    OR ABS(f.total_installments - s.total_installments) > 0.01