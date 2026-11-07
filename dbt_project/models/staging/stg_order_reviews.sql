SELECT 
TRIM(review_id) AS review_id,
TRIM(order_id) AS order_id,
review_score,
CASE
    WHEN TRIM(review_comment_title) IS NULL THEN NULL
    WHEN LENGTH(TRIM(review_comment_title)) < 3 THEN NULL
    WHEN regexp_matches(TRIM(review_comment_title), '^[0-9]+$') THEN NULL
    WHEN regexp_matches(TRIM(review_comment_title), '^[^a-zA-Z0-9À-ÿ]+$') THEN NULL
    ELSE TRIM(review_comment_title)
END AS review_comment_title,

CASE
    WHEN TRIM(review_comment_message) IS NULL THEN NULL
    WHEN LENGTH(TRIM(review_comment_message)) < 3 THEN NULL
    WHEN regexp_matches(TRIM(review_comment_message), '^[0-9]+$') THEN NULL
    WHEN regexp_matches(TRIM(review_comment_message), '^[^a-zA-Z0-9À-ÿ]+$') THEN NULL
    WHEN LOWER(TRIM(review_comment_message)) IN ('ok','ok!', 'okay') THEN 'ok'
    WHEN review_comment_message = '👍' THEN 'ok'
    WHEN LOWER(TRIM(review_comment_message)) = '10' THEN 'perfect'
    WHEN LOWER(TRIM(review_comment_message)) IN ('9', '8') THEN 'very good'
    WHEN title_stripped IN ('7', '6', '5') THEN 'average'
    WHEN title_stripped IN ('4', '3', '2') THEN 'bad'
    WHEN title_stripped IN ('1', '0') THEN 'very bad'
    ELSE TRIM(review_comment_message)
    END AS review_comment_message,
review_creation_date,
review_answer_timestamp
FROM {{source ('raw', 'order_reviews')}}