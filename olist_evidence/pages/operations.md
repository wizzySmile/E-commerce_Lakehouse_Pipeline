---
title: Operations Performance
---

# Operations Performance

```sql total_orders
SELECT 
    SUM(total_orders) AS orders 
FROM mart_operations_performance
```

```sql total_items
SELECT 
    SUM(total_items_shipped) AS items 
FROM mart_operations_performance
```

```sql avg_delivery
SELECT 
    AVG(avg_delivery_days) AS avg_days 
FROM mart_operations_performance
```

```sql total_late
SELECT 
    SUM(late_delivery_count) AS late_orders 
FROM mart_operations_performance
```

<BigValue data={total_orders} value=orders title="Total Orders" />

<BigValue data={total_items} value=items title="Total Items Shipped" />

<BigValue data={avg_delivery} value=avg_days title="Avg Delivery Days" fmt="num1" />

<BigValue data={total_late} value=late_orders title="Late Deliveries" />

## Delivery Speed Over Time

```sql delivery_by_month
SELECT 
    year, 
    month, 
    month_name, 
    SUM(total_orders) AS orders, 
    SUM(total_items_shipped) AS items, 
    AVG(avg_delivery_days) AS avg_delivery_days, 
    AVG(avg_estimated_days) AS avg_estimated_days, 
    SUM(late_delivery_count) AS late_count 
FROM mart_operations_performance 
GROUP BY year, month, month_name 
ORDER BY year, month
```

<LineChart data={delivery_by_month} x=month_name y={["avg_delivery_days", "avg_estimated_days"]} title="Actual vs Estimated Delivery Days" />

<BarChart data={delivery_by_month} x=month_name y=late_count title="Late Deliveries by Month" />

## Late Delivery Rate by State

```sql late_by_state
SELECT 
    customer_state AS state, 
    SUM(total_orders) AS orders, 
    SUM(late_delivery_count) AS late_count, 
    SUM(late_delivery_count) * 100.0 / NULLIF(SUM(total_orders), 0) AS late_rate, 
    AVG(avg_delivery_days) AS avg_delivery_days 
FROM mart_operations_performance 
GROUP BY customer_state 
ORDER BY late_rate DESC LIMIT 15
```

<BarChart data={late_by_state} x=state y=late_rate title="Late Delivery Rate by State" fmt="pct1" />

<DataTable data={late_by_state} />

## Freight Cost by State

```sql freight_by_state
SELECT 
    customer_state AS state, 
    SUM(total_freight_cost) AS freight_cost, 
    SUM(total_orders) AS orders, 
    SUM(total_freight_cost) / NULLIF(SUM(total_orders), 0) AS freight_per_order 
FROM mart_operations_performance 
GROUP BY customer_state 
ORDER BY freight_cost DESC LIMIT 10
```

<BarChart data={freight_by_state} x=state y=freight_cost title="Total Freight Cost by State" />

<DataTable data={freight_by_state} />

## Full Operations Table

```sql ops_table
SELECT 
    month_name, 
    customer_state AS state, 
    total_orders, 
    total_items_shipped, 
    avg_delivery_days, 
    avg_estimated_days, 
    total_freight_cost, 
    late_delivery_count 
FROM mart_operations_performance 
ORDER BY year, month, customer_state
```

<DataTable data={ops_table} />