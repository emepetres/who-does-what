# DB Plan

## Goals

- Local dev Azure SQL that can be created on demand and reset.
- Alembic migrations for schema control.
- Same engine family in dev and prod (Azure SQL), with Azure SQL in cloud.

## Decisions (recommended defaults)

- Driver: Azure SQL (MS SQL Server) + SQLAlchemy 2.x + Alembic.
- FastAPI style: sync endpoints with SQLAlchemy sync sessions (simple and reliable).
- DB name: `who_does_what`.
- DB user: `app` (least privilege; separate from admin).
- Local env: devcontainer + `backend/docker-compose.yml` to spin a local Azure SQL container and initialize db/user.
- IaC: Terraform for Azure App Service + Azure SQL (server + database) with a CI pipeline, and runnable locally for testing.

## Step plan

### Stage 1 (devcontainer + local DB access check)

1. Repo config: add `.devcontainer/backend/devcontainer.json` and `backend/docker-compose.yml` with Azure SQL container, volume, env, and init script.
2. Local DB access script: add a script runnable inside the devcontainer to verify connectivity to the local Azure SQL instance (smoke check).

### Stage 2 (app wiring, migrations, IaC, tests)

3. App config: add settings to read `DATABASE_URL`; wire SQLAlchemy engine/session and FastAPI dependencies.
4. Alembic: add `alembic.ini` and `alembic/env.py` to use app settings and `Base.metadata`.
5. Migrations workflow: add uv/make commands for `alembic revision --autogenerate` and `alembic upgrade head`; document in backend README.
6. Azure SQL + App Service: define Terraform for Azure SQL server + database + App Service; ensure it can run via CI pipeline and locally from terminal for testing; document in backend README.
7. Validation: run lint/tests and a local migration smoke test.
8. Add a basic unit test that verifies database access.
