---
title: Olist Dashboard
---

# Olist Dashboard

Welcome to the Olist Brazil E-Commerce Dashboard. Pick a section below.

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

```sql avg_delivery
SELECT 
    AVG(avg_delivery_days) AS avg_days 
FROM mart_operations_performance
```

<BigValue data={total_revenue} value=revenue title="Total Revenue" fmt="usd" />

<BigValue data={total_orders} value=orders title="Total Orders" />

<BigValue data={total_customers} value=customers title="Total Customers" />

<BigValue data={avg_delivery} value=avg_days title="Avg Delivery Days" fmt="num1" />

## Explore

### [CRM - Customer Retention](/crm)
Total customers, lifetime value, churn risk, and does late delivery kill reviews?

### [Marketing Performance](/marketing_performance)
Revenue by state and city, orders over time, delivery performance.

### [Monthly Revenue](/monthly_revenue)
Revenue trend, revenue vs freight, late delivery rate by month.

### [Operations Performance](/operations_performance)
Actual vs estimated delivery days, late rate by state, freight cost by state.

## Revenue at a Glance

```sql revenue_by_month
SELECT 
    month_name, 
    total_revenue, 
    total_orders 
FROM mart_monthly_revenue 
ORDER BY year, month
```

<LineChart data={revenue_by_month} x=month_name y=total_revenue title="Revenue by Month" />

<BarChart data={revenue_by_month} x=month_name y=total_orders title="Orders by Month" />