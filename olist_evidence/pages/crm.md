---
title: CRM
---

# CRM - Customer Retention

```sql total_customers
SELECT 
    COUNT(DISTINCT customer_key) AS customers 
FROM mart_customer_metrics
```

```sql avg_ltv
SELECT 
    AVG(lifetime_value) AS avg_ltv 
FROM mart_customer_metrics
```

```sql one_time_buyers
SELECT 
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM mart_customer_metrics) AS pct_one_time 
FROM mart_customer_metrics 
WHERE total_orders = 1
```

<BigValue data={total_customers} value=customers title="Total Customers" />

<BigValue data={avg_ltv} value=avg_ltv title="Avg Lifetime Value" fmt="usd" />

<BigValue data={one_time_buyers} value=pct_one_time title="% One-Time Buyers" fmt="pct1" />

## Lifetime Value by State

```sql ltv_by_state
SELECT 
    customer_state AS state, 
    COUNT(*) AS customers, 
    SUM(lifetime_value) AS total_ltv, 
    AVG(lifetime_value) AS avg_ltv 
    FROM mart_customer_metrics 
    GROUP BY customer_state 
ORDER BY total_ltv DESC LIMIT 10
```

<BarChart data={ltv_by_state} x=state y=total_ltv title="Total LTV by State" />

## Churn Risk

```sql churn_risk
SELECT 
    CASE 
        WHEN day_since_last_order > 180 THEN 'Churned (180d+)' 
        WHEN day_since_last_order > 90 THEN 'At Risk (90-180d)' 
        WHEN day_since_last_order > 30 THEN 'Cooling (30-90d)' 
        ELSE 'Active (<30d)' 
    END AS segment, 
    COUNT(*) AS customers, 
    AVG(lifetime_value) AS avg_ltv 
FROM mart_customer_metrics 
GROUP BY segment
```

<DataTable data={churn_risk} />

## Does Late Delivery Kill Reviews?

```sql delivery_vs_review
SELECT 
    CASE 
        WHEN late_delivery_count > 0 THEN 'Had Late Delivery' 
        ELSE 'Never Late' 
    END AS delivery_status, 
    AVG(avg_review_score) AS avg_review, 
    AVG(lifetime_value) AS avg_ltv, 
    COUNT(*) AS customers 
FROM mart_customer_metrics 
GROUP BY delivery_status
```

<BarChart data={delivery_vs_review} x=delivery_status y=avg_review title="Avg Review Score: Late vs On-Time" />