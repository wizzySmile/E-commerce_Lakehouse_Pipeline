SELECT
    rev.review_id,
    ord.order_id,
    c.customer_key,
    CAST(strftime(
        CAST(rev.review_creation_date AS date), '%Y%m%d') AS bigint) AS review_date_key,
    CAST(strftime(
        CAST(rev.review_answer_timestamp AS date), '%Y%m%d') AS bigint) AS review_answer_date_key,

    -- days between review created and seller answered
    date_diff('day', CAST(rev.review_creation_date AS date), CAST(rev.review_answer_timestamp AS date)) AS days_to_answer,
    rev.review_score,
    rev.review_comment_title,
    rev.review_comment_message

FROM {{ ref('stg_order_reviews') }} rev

INNER JOIN {{ ref('stg_orders') }} ord
    ON rev.order_id = ord.order_id

LEFT JOIN {{ ref('dim_customers') }} c
    ON ord.customer_id = c.customer_id

