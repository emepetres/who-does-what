# Makefile for easy development workflows.
# See development.md for docs.
# Note GitHub Actions call uv directly, not this Makefile.

ifeq ($(OS),Windows_NT)
SHELL := powershell.exe
.SHELLFLAGS := -NoProfile -Command
endif
.DEFAULT_GOAL := default

.PHONY: default install lint test upgrade build clean agent-rules db-revision db-upgrade

default: agent-rules install lint test

install:
	uv sync --all-extras

lint:
	uv run python devtools/lint.py

test:
	uv run coverage run -m pytest
	uv run coverage report --fail-under=80

upgrade:
	uv sync --upgrade --all-extras --dev

build:
	uv build

dev:
	uv run uvicorn who_does_what_api.main:app --host 0.0.0.0 --port 8000 --reload

db-revision:
	uv run alembic revision --autogenerate -m "$(name)"

db-upgrade:
	uv run alembic upgrade head

agent-rules: CLAUDE.md AGENTS.md

# Use .cursor/rules for sources of rules.
# Create Claude and Codex rules from these.
ifeq ($(OS),Windows_NT)
CLAUDE.md: .cursor/rules/general.mdc .cursor/rules/python.mdc
	cat .cursor/rules/general.mdc, .cursor/rules/python.mdc > CLAUDE.md

AGENTS.md: .cursor/rules/general.mdc .cursor/rules/python.mdc
	cat .cursor/rules/general.mdc, .cursor/rules/python.mdc > AGENTS.md
else
CLAUDE.md: .cursor/rules/general.mdc .cursor/rules/python.mdc
	cat .cursor/rules/general.mdc .cursor/rules/python.mdc > CLAUDE.md

AGENTS.md: .cursor/rules/general.mdc .cursor/rules/python.mdc
	cat .cursor/rules/general.mdc .cursor/rules/python.mdc > AGENTS.md
endif

clean:
	-rm -rf dist/
	-rm -rf *.egg-info/
	-rm -rf .*_cache/
	-rm -rf .venv/
	-rm -rf CLAUDE.md AGENTS.md
	-find . -type d -name "__pycache__" -exec rm -rf {} +
