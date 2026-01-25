from __future__ import annotations

from fastapi import Depends, FastAPI
from loguru import logger
from sqlalchemy import text
from sqlalchemy.orm import Session

from who_does_what_api.db import get_db
from who_does_what_api.settings import app_settings

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/db/health")
def db_health(db: Session = Depends(get_db)) -> dict[str, bool]:
    result = db.execute(text("SELECT 1 AS ok")).scalar_one()
    return {"ok": result == 1}


def hello_world(message: str) -> str:
    return message.upper()


def main() -> None:
    result = hello_world("Hello world!!")
    logger.info(result)

    logger.info("----Settings sample----")
    logger.info("MY_SAMPLE_VARIABLE", app_settings.MY_SAMPLE_VARIABLE)
    logger.info("ANOTHER_VARIABLE", app_settings.ANOTHER_VARIABLE)


if __name__ == "__main__":
    main()
