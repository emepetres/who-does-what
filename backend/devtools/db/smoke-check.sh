#!/usr/bin/env bash
set -euo pipefail

DB_HOST="${MSSQL_HOST:-db}"
DB_PORT="${MSSQL_PORT:-1433}"
DB_NAME="${DB_NAME:-who_does_what}"
DB_APP_USER="${DB_APP_USER:-app}"
DB_APP_PASSWORD="${DB_APP_PASSWORD:-}"
SQLCMD_BIN="${SQLCMD_BIN:-sqlcmd}"

if [[ -z "$DB_APP_PASSWORD" ]]; then
    echo "DB_APP_PASSWORD is not set." >&2
    exit 1
fi

echo "Connecting to ${DB_HOST}:${DB_PORT} as ${DB_APP_USER}..."
"$SQLCMD_BIN" \
    -S "${DB_HOST},${DB_PORT}" \
    -U "$DB_APP_USER" \
    -P "$DB_APP_PASSWORD" \
    -C \
    -d "$DB_NAME" \
    -l 5 \
    -Q "SELECT 1 AS ok, DB_NAME() AS db_name, SUSER_SNAME() AS login_name;"

echo "Connection check succeeded."
