SELECT 
    {{ dbt_utils.generate_surrogate_key(['seller_id', 'dbt_valid_from']) }} AS seller_key,
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state,
    dbt_valid_from AS valid_from,
    dbt_valid_to AS valid_to,
    CASE WHEN dbt_valid_to IS NULL 
        THEN true ELSE false 
    END AS is_current
FROM {{ ref('scd2_dim_sellers') }}