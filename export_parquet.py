import duckdb
con = duckdb.connect('data/ecommerce.duckdb', read_only=True)
con.execute("COPY (SELECT * FROM fact_sales) TO 'olist_dashboard/fact_sales.parquet' (FORMAT PARQUET)")
con.execute("COPY (SELECT * FROM mart_monthly_revenue) TO 'olist_dashboard/mart_monthly_revenue.parquet' (FORMAT PARQUET)")
con.execute("COPY (SELECT * FROM mart_customer_metrics) TO 'olist_dashboard/mart_customer_metrics.parquet' (FORMAT PARQUET)")
print('done')
