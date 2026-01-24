#!/usr/bin/env bash
set -euo pipefail

DB_HOST="${MSSQL_HOST:-db}"
DB_PORT="${MSSQL_PORT:-1433}"
SA_PASSWORD="${MSSQL_SA_PASSWORD:-}"
DB_NAME="${DB_NAME:-who_does_what}"
DB_APP_USER="${DB_APP_USER:-app}"
DB_APP_PASSWORD="${DB_APP_PASSWORD:-}"
SQLCMD_BIN="${SQLCMD_BIN:-sqlcmd}"

if [[ -z "$SA_PASSWORD" ]]; then
    echo "MSSQL_SA_PASSWORD is not set." >&2
    exit 1
fi

if [[ -z "$DB_APP_PASSWORD" ]]; then
    echo "DB_APP_PASSWORD is not set." >&2
    exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
init_sql="${script_dir}/init.sql"

if [[ ! -f "$init_sql" ]]; then
    echo "Init SQL script not found at ${init_sql}." >&2
    exit 1
fi

echo "Waiting for SQL Server at ${DB_HOST}:${DB_PORT}..."
for attempt in {1..30}; do
    if "$SQLCMD_BIN" -S "${DB_HOST},${DB_PORT}" -U sa -P "$SA_PASSWORD" -C -l 2 -Q "SELECT 1" >/dev/null 2>&1; then
        echo "SQL Server is available."
        break
    fi
    if [[ "$attempt" -eq 30 ]]; then
        echo "SQL Server did not become available in time." >&2
        exit 1
    fi
    sleep 2
done

echo "Ensuring database and user exist..."
"$SQLCMD_BIN" \
    -S "${DB_HOST},${DB_PORT}" \
    -U sa \
    -P "$SA_PASSWORD" \
    -C \
    -b \
    -v DB_NAME="$DB_NAME" DB_APP_USER="$DB_APP_USER" DB_APP_PASSWORD="$DB_APP_PASSWORD" \
    -i "$init_sql"

echo "Verifying app user connectivity..."
"$SQLCMD_BIN" \
    -S "${DB_HOST},${DB_PORT}" \
    -U "$DB_APP_USER" \
    -P "$DB_APP_PASSWORD" \
    -C \
    -d "$DB_NAME" \
    -l 5 \
    -Q "SELECT DB_NAME() AS db_name, SUSER_SNAME() AS login_name;"

echo "DB initialization complete."
