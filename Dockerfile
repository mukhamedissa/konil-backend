FROM python:3.10-slim

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       gcc \
       libpq-dev \
       postgresql-client-common \
       postgresql-client \
  && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
COPY entrypoint.sh .

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]
