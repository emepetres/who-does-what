from __future__ import annotations

import os

import pytest
from sqlalchemy import text

from who_does_what_api.db import get_engine


def test_database_connection_smoke() -> None:
    if not os.getenv("DATABASE_URL") and not os.getenv("DB_APP_PASSWORD"):
        pytest.skip("DATABASE_URL or DB_APP_PASSWORD must be set to run DB tests.")

    engine = get_engine()
    with engine.connect() as connection:
        result = connection.execute(text("SELECT 1")).scalar_one()

    assert result == 1
