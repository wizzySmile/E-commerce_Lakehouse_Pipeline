---
title: Monthly Revenue
---

# Monthly Revenue

```sql total_revenue
SELECT 
    SUM(total_revenue) AS revenue 
FROM mart_monthly_revenue
```

```sql total_orders
SELECT 
    SUM(total_orders) AS orders 
FROM mart_monthly_revenue
```

```sql total_customers
SELECT 
    SUM(total_customers) AS customers 
FROM mart_monthly_revenue
```

```sql total_freight
SELECT 
    SUM(total_freight) AS freight 
FROM mart_monthly_revenue
```

<BigValue data={total_revenue} value=revenue title="Total Revenue" fmt="usd" />

<BigValue data={total_orders} value=orders title="Total Orders" />

<BigValue data={total_customers} value=customers title="Total Customers" />

<BigValue data={total_freight} value=freight title="Total Freight" fmt="usd" />

## Revenue Trend

```sql revenue_by_month
SELECT 
    year, 
    month, 
    month_name, 
    month_start_date, 
    total_orders, 
    total_customers, 
    total_items_sold, 
    total_revenue, 
    total_freight, 
    total_revenue_with_freight, 
    avg_order_value, 
    avg_delivery_days, 
    late_delivery_count, 
    late_delivery_rate 
FROM mart_monthly_revenue 
ORDER BY year, month
```

<LineChart data={revenue_by_month} x=month_name y=total_revenue title="Total Revenue by Month" />

<BarChart data={revenue_by_month} x=month_name y=total_orders title="Total Orders by Month" />

<LineChart data={revenue_by_month} x=month_name y=avg_order_value title="Avg Order Value by Month" />

## Revenue vs Freight

```sql revenue_vs_freight
SELECT 
    month_name, 
    total_revenue, 
    total_freight, 
    total_revenue_with_freight 
FROM mart_monthly_revenue 
ORDER BY year, month
```

<BarChart data={revenue_vs_freight} x=month_name y={["total_revenue", "total_freight"]} title="Revenue vs Freight by Month" />

## Delivery Quality

```sql delivery_by_month
SELECT 
    month_name, 
    avg_delivery_days, 
    late_delivery_count, 
    late_delivery_rate, 
    total_orders 
FROM mart_monthly_revenue 
ORDER BY year, month
```

<LineChart data={delivery_by_month} x=month_name y=late_delivery_rate title="Late Delivery Rate by Month" fmt="pct" />

<BarChart data={delivery_by_month} x=month_name y=avg_delivery_days title="Avg Delivery Days by Month" />

## Full Monthly Table

```sql monthly_table
SELECT 
    month_name, 
    total_orders, 
    total_customers, 
    total_items_sold, 
    total_revenue, 
    total_freight, 
    total_revenue_with_freight, 
    avg_order_value, 
    avg_delivery_days, 
    late_delivery_rate 
FROM mart_monthly_revenue 
ORDER BY year, month
```

<DataTable data={monthly_table} />