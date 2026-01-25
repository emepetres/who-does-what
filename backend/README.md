# Who Does What API

## Local development

- Use the devcontainer `who-does-what-backend` to start the backend with an SQL Server.
- Run tests: `make test`
- Run linting: `make lint`
- Run the backend app: `make dev`
  - The app will be available at `http://localhost:8000`
  - OpenAPI docs: `http://localhost:8000/docs`
  - Database health check: `http://localhost:8000/health/db`

## Database configuration

The app reads `DATABASE_URL` first. If it is not set, it composes a URL from:
`MSSQL_HOST`, `MSSQL_PORT`, `DB_NAME`, `DB_APP_USER`, `DB_APP_PASSWORD`.

_Note that these environment variables are automatically set when using the devcontainer._

## Migrations (Alembic)

- Create a migration:
  - `make db-revision name="init_schema"`
- Apply migrations:
  - `make db-upgrade`

Both commands run through `uv` and use the same settings as the app.

## Terraform (Azure SQL + App Service)

Terraform configuration lives in `backend/infra`. See `backend/infra/README.md`
for a full walkthrough of local and CI usage.
