import duckdb
con = duckdb.connect()
con.execute("ATTACH '../data/ecommerce.duckdb' AS src (READ_ONLY)")
con.execute("ATTACH '../data/ecommerce_v1.duckdb' AS dst (STORAGE_VERSION 'v1.0.0')")
con.execute("COPY FROM DATABASE src TO dst")
print("done")
