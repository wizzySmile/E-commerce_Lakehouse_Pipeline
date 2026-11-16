SELECT 
    product_id,
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_key,
    COALESCE(
        CASE 
            WHEN stg_prd.product_category_name = 'portateis_cozinha_e_preparadores_de_alimentos' 
                THEN 'portable_kitchen_and_food_preparers'
            ELSE stg_prd_cat.product_category_name_english 
        END, 
        stg_prd.product_category_name, 
        'unknown') AS product_category,

FROM {{ ref('stg_products') }} stg_prd
    LEFT JOIN {{ ref('stg_product_category_translation') }} stg_prd_cat
        ON stg_prd.product_category_name = stg_prd_cat.product_category_name