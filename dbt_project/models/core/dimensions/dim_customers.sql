SELECT 
    customer_id,
    {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_key,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM {{ ref('stg_customers') }}