# E-commerce Lakehouse Pipeline

An end-to-end data engineering project that transforms Brazilian e-commerce data from the Olist marketplace into tested, analysis-ready tables and dashboards.

The project demonstrates a practical medallion architecture:

- **Bronze / raw:** Source CSV data loaded into DuckDB
- **Silver / staging:** Renamed, typed, cleaned, and standardized dbt models
- **Gold / core:** Dimensions and fact tables in a star schema
- **Analytics marts:** Business-focused tables for customer, marketing, finance, and operations analysis

## Architecture

![E-commerce lakehouse architecture](docs/olist-etl-architecture.png)

**Data flow:** Source CSV files -> DuckDB raw tables -> dbt staging models -> dbt snapshots -> dbt core models -> dbt analytics marts -> Parquet exports -> Rill dashboards

The repository also includes a detailed [data model ERD](docs/ecommerce_data_model_erd.png) and the matching [DBML source](docs/ecommerce_data_model.dbml).

## Technology

- [Python](https://www.python.org/) for data setup and Parquet exports
- [DuckDB](https://duckdb.org/) for local storage and SQL analytics
- [dbt](https://www.getdbt.com/) for data transformation, snapshots, testing, and documentation
- [Rill](https://www.rilldata.com/) for interactive business dashboards
- SQL and CSV for the source and transformation layers

## Data Model

The dbt project is organized into four main layers.

### Staging

Staging models standardize the source data and expose one clean model for each source table:

- Customers
- Geolocation
- Orders
- Order items
- Payments
- Reviews
- Products
- Sellers
- Product category translations

### Snapshots

Slowly changing dimensions use dbt snapshots to retain historical versions of:

- Customers
- Products
- Sellers

### Core

The core layer contains the star schema:

**Dimensions**

- `dim_customers`
- `dim_dates`
- `dim_payment_types`
- `dim_products`
- `dim_sellers`

**Facts**

- `fact_orders`
- `fact_sales`
- `fact_payments`
- `fact_reviews`

### Analytics marts

The marts provide reusable outputs for dashboards and reporting:

- `mart_customer_metrics` - Customer lifetime value, order behavior, delivery performance, and review activity
- `mart_marketing_performance` - Monthly and geographic marketing performance
- `mart_monthly_revenue` - Monthly revenue, freight, order volume, and late-delivery trends
- `mart_operations_performance` - Delivery speed, shipping volume, freight cost, and late-order performance

## Project Structure

```text
.
|-- data/
|   |-- raw/                  # Olist source CSV files
|   |-- bronze/               # Bronze data artifacts
|   |-- silver/               # Silver data artifacts
|   |-- gold/                 # Gold data artifacts
|   `-- ecommerce.duckdb      # Main DuckDB database
|-- dbt_project/
|   |-- models/
|   |   |-- staging/          # Cleaned staging views
|   |   |-- core/             # Dimensions and facts
|   |   `-- marts/            # Business analytics models
|   |-- snapshots/            # Slowly changing dimension snapshots
|   |-- tests/                # Reconciliation and data quality tests
|   `-- sql/load_raw_tables.sql
|-- docs/                     # Architecture and data model images
|-- olist_dashboard/          # Rill dashboard project
|-- profiles/                 # Local dbt DuckDB profile
|-- export_marts.py           # Export selected marts to Parquet
|-- export_parquet.py         # Export the fact and finance models to Parquet
`-- convert_db.py             # Convert the database to DuckDB storage version v1
```

## Getting Started

### Prerequisites

- Python 3.10 or newer
- dbt DuckDB adapter
- DuckDB Python package
- Rill Developer, if you want to run the dashboard locally

### 1. Create a virtual environment

On Windows PowerShell:

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
```

Install the Python packages used by the project:

```powershell
python -m pip install --upgrade pip
python -m pip install duckdb dbt-duckdb
```

### 2. Load the source CSV files

Run the loader script from the repository root:

```powershell
python -c "import duckdb, pathlib; con=duckdb.connect('data/ecommerce.duckdb'); con.execute(pathlib.Path('dbt_project/sql/load_raw_tables.sql').read_text()); con.close()"
```

This creates or replaces the raw tables in DuckDB's `main` schema.

### 3. Install dbt packages

```powershell
cd dbt_project
dbt deps --profiles-dir ..\profiles
```

### 4. Run dbt transformations

Build snapshots, core models, and analytics marts:

```powershell
dbt snapshot --profiles-dir ..\profiles
dbt run --profiles-dir ..\profiles
dbt test --profiles-dir ..\profiles
```

To generate the dbt documentation:

```powershell
dbt docs generate --profiles-dir ..\profiles
dbt docs serve --profiles-dir ..\profiles
```

The dbt profile is configured in [profiles/profiles.yml](profiles/profiles.yml). It uses `data/ecommerce.duckdb` as the local database.

## Export Dashboards

Return to the repository root and export the approved models to Parquet:

```powershell
cd ..
python export_marts.py
python export_parquet.py
```

The exports are written to [olist_dashboard/](olist_dashboard/) and can be consumed by Rill.

## Run the Dashboard

From the repository root:

```powershell
cd olist_dashboard
rill start
```

Rill will open a local dashboard for exploring the exported metrics.

A deployed example is available at [Rill Dashboard](https://ui.rilldata.com/Wisdom/olist_dashboard).

## Validation

The project includes reconciliation tests for:

- Orders
- Payments
- Reviews
- Sales
- Monthly revenue
- Customer metrics
- Marketing performance
- Operations performance

Run all dbt tests with:

```powershell
dbt test --profiles-dir ..\profiles
```

## Data Source

The source data is the public Olist Brazilian e-commerce dataset. It contains marketplace orders, customers, sellers, products, items, payments, reviews, geolocation, and category information.

## License

No license is currently specified for this repository. Add a license file before using or distributing the project externally.
