import duckdb
con = duckdb.connect('data/ecommerce.duckdb', read_only=True)
con.execute("COPY (SELECT * FROM mart_marketing_performance) TO 'olist_dashboard/mart_marketing_performance.parquet' (FORMAT PARQUET)")
con.execute("COPY (SELECT * FROM mart_operations_performance) TO 'olist_dashboard/mart_operations_performance.parquet' (FORMAT PARQUET)")
print('done - 4 marts ready')
