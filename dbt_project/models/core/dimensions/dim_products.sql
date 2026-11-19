SELECT 
    {{ dbt_utils.generate_surrogate_key(['stg_prd.product_id', 'stg_prd.dbt_valid_from']) }} AS product_key,
    stg_prd.product_id,
    COALESCE(
        CASE 
            WHEN stg_prd.product_category_name = 'portateis_cozinha_e_preparadores_de_alimentos' 
                THEN 'portable_kitchen_and_food_preparers'
            ELSE stg_prd_cat.product_category_name_english 
        END, 
        stg_prd.product_category_name, 
        'unknown') AS product_category,
    stg_prd.product_name_lenght,
    stg_prd.product_description_lenght,
    stg_prd.product_photos_qty,
    stg_prd.product_weight_g,
    stg_prd.product_length_cm,
    stg_prd.product_height_cm,
    stg_prd.product_width_cm,
    stg_prd.dbt_valid_from AS valid_from,
    stg_prd.dbt_valid_to AS valid_to,
    CASE WHEN stg_prd.dbt_valid_to IS NULL 
        THEN true ELSE false 
    END AS is_current

FROM {{ ref('scd2_dim_products') }} stg_prd
    LEFT JOIN {{ ref('stg_product_category_translation') }} stg_prd_cat
        ON stg_prd.product_category_name = stg_prd_cat.product_category_name