#!/usr/bin/env bash
set -e

: "${DB_HOST:=db}"
: "${DB_PORT:=5432}"
: "${DB_USER:=postgres}"
: "${DB_NAME:=konil}"
: "${RETRY_SECONDS:=1}"

export PGPASSWORD="${POSTGRES_PASSWORD:-password}"

echo "Waiting for Postgres at $DB_HOST:$DB_PORT…"
until pg_isready \
    -h "$DB_HOST" \
    -p "$DB_PORT" \
    -U "$DB_USER" \
    -d "$DB_NAME" \
    -q; do
  echo "Postgres is unavailable (still starting) — retrying in ${RETRY_SECONDS}s…"
  sleep "$RETRY_SECONDS"
done

echo "Postgres is up — running migrations"
alembic upgrade head

echo "Starting Uvicorn"
exec uvicorn main:app --host 0.0.0.0 --port 8080
