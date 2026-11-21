CREATE OR REPLACE TABLE main.customers AS
SELECT *
FROM read_csv_auto('data/raw/olist_customers_dataset.csv');


CREATE OR REPLACE TABLE main.geolocation AS
SELECT *
FROM read_csv_auto('data/raw/olist_geolocation_dataset.csv');

CREATE OR REPLACE TABLE main.order_items AS
SELECT *
FROM read_csv_auto('data/raw/olist_order_items_dataset.csv');

CREATE OR REPLACE TABLE main.order_payments AS
SELECT *
FROM read_csv_auto('data/raw/olist_order_payments_dataset.csv');

CREATE OR REPLACE TABLE main.order_reviews AS
SELECT *
FROM read_csv_auto('data/raw/olist_order_reviews_dataset.csv');

CREATE OR REPLACE TABLE main.orders AS
SELECT *
FROM read_csv_auto('data/raw/olist_orders_dataset.csv');

CREATE OR REPLACE TABLE main.products AS
SELECT *
FROM read_csv_auto('data/raw/olist_products_dataset.csv');

CREATE OR REPLACE TABLE main.sellers AS
SELECT *
FROM read_csv_auto('data/raw/olist_sellers_dataset.csv');

CREATE OR REPLACE TABLE main.product_category_translation AS
SELECT *
FROM read_csv_auto('data/raw/product_category_name_translation.csv');