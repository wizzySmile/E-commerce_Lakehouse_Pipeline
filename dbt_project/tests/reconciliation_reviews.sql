WITH source_reviews AS
(
    SELECT
    COUNT(*) AS row_count,
    SUM(review_score) AS total_score
    FROM {{ ref('stg_order_reviews') }}
),
fact_reviews AS
(
    SELECT
    COUNT(*) AS row_count,
    SUM(review_score) AS total_score
    FROM {{ ref('fact_reviews') }}
)

SELECT *
FROM fact_reviews f
CROSS JOIN source_reviews s
WHERE f.row_count != s.row_count
    OR f.total_score != s.total_score