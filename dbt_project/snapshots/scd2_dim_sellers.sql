{% snapshot scd2_dim_sellers %}

{{
    config(
      target_schema='snapshots',
      unique_key='seller_id',
      strategy='check',
      check_cols=['seller_zip_code_prefix', 'seller_city', 'seller_state'],
    )
}}

SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM {{ ref('stg_sellers') }}

{% endsnapshot %}