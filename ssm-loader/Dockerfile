FROM python:3.11-slim

WORKDIR /app

RUN pip install --no-cache-dir boto3

COPY ssm_loader.py /app/ssm_loader.py

ENTRYPOINT ["python", "/app/ssm_loader.py"]