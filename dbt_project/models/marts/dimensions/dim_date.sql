with date_spine as (
    select
        cast(d as date) as date_day
    from range(
        date '2016-01-01',
        date '2021-01-01',
        interval 1 day
    ) as tbl(d)
)

select
    cast(strftime(date_day, '%Y%m%d') as bigint) as date_key,
    date_day as full_date,
    year(date_day) as year,
    month(date_day) as month,
    day(date_day) as day,
    strftime(date_day, '%B') as month_name,
    strftime(date_day, '%A') as weekday_name,
    dayofweek(date_day) as day_of_week, -- 0 = Sunday, 6 = Saturday in DuckDB
    case when dayofweek(date_day) in (0, 6) then true else false end as is_weekend,
    quarter(date_day) as quarter
from date_spine