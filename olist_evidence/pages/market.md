---
title: Marketing Performance
---

# Marketing Performance

```sql total_revenue
SELECT 
    SUM(total_revenue) AS revenue 
FROM mart_marketing_performance
```

```sql total_orders
SELECT 
    SUM(total_orders) AS orders 
FROM mart_marketing_performance
```

```sql total_customers
SELECT
    SUM(total_customers) AS customers 
FROM mart_marketing_performance
```

```sql avg_aov
SELECT 
    AVG(avg_order_value) AS aov 
FROM mart_marketing_performance
```

<BigValue data={total_revenue} value=revenue title="Total Revenue" fmt="usd" />

<BigValue data={total_orders} value=orders title="Total Orders" />

<BigValue data={total_customers} value=customers title="Total Customers" />

<BigValue data={avg_aov} value=aov title="Avg Order Value" fmt="usd" />

## Revenue Over Time

```sql revenue_by_month
SELECT 
    year, 
    month, 
    month_name, 
    SUM(total_revenue) AS revenue, 
    SUM(total_orders) AS orders, 
    SUM(total_customers) AS customers 
FROM mart_marketing_performance 
GROUP BY year, month, month_name 
ORDER BY year, month
```

<LineChart data={revenue_by_month} x=month_name y=revenue title="Revenue by Month" />

<BarChart data={revenue_by_month} x=month_name y=orders title="Orders by Month" />

## Revenue by State

```sql revenue_by_state
SELECT 
    customer_state AS state, 
    SUM(total_revenue) AS revenue, 
    SUM(total_orders) AS orders, 
    SUM(total_customers) AS customers, 
    AVG(avg_order_value) AS aov 
FROM mart_marketing_performance 
GROUP BY customer_state 
ORDER BY revenue DESC LIMIT 10
```

<BarChart data={revenue_by_state} x=state y=revenue title="Revenue by State" />

<DataTable data={revenue_by_state} />

## Top Cities

```sql revenue_by_city
SELECT 
    customer_city AS city, 
    customer_state AS state, 
    SUM(total_revenue) AS revenue, 
    SUM(total_orders) AS orders 
FROM mart_marketing_performance 
GROUP BY customer_city, customer_state 
ORDER BY revenue DESC LIMIT 15
```

<DataTable data={revenue_by_city} />

## Delivery Performance

```sql delivery_perf
SELECT 
    month_name, 
    AVG(avg_delivery_days) AS avg_delivery_days, 
    SUM(late_delivery_count) AS late_deliveries, 
    SUM(total_orders) AS orders 
FROM mart_marketing_performance 
GROUP BY month_name 
ORDER BY orders DESC
```

<BarChart data={delivery_perf} x=month_name y=avg_delivery_days title="Avg Delivery Days by Month" />

<DataTable data={delivery_perf} />