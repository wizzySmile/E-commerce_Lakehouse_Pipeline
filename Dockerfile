FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY export_marts.py export_parquet.py ./
# Run both export scripts
CMD ["sh", "-c", "python export_marts.py && python export_parquet.py"]