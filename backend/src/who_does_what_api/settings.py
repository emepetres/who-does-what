from __future__ import annotations

from typing import ClassVar

from pydantic_settings import BaseSettings, SettingsConfigDict
from sqlalchemy.engine import URL


class AppSettings(BaseSettings):
    model_config: ClassVar[SettingsConfigDict] = SettingsConfigDict(
        env_file=".env", env_file_encoding="utf-8"
    )
    MY_SAMPLE_VARIABLE: str = "DEFAULT_VALUE"
    ANOTHER_VARIABLE: int = 1

    DATABASE_URL: str | None = None
    MSSQL_HOST: str = "db"
    MSSQL_PORT: int = 1433
    DB_NAME: str = "who_does_what"
    DB_APP_USER: str = "app"
    DB_APP_PASSWORD: str | None = None
    MSSQL_DRIVER: str = "ODBC Driver 18 for SQL Server"
    MSSQL_ENCRYPT: bool = True
    MSSQL_TRUST_SERVER_CERTIFICATE: bool = True
    SQLALCHEMY_ECHO: bool = False

    @property
    def database_url(self) -> str:
        if self.DATABASE_URL:
            return self.DATABASE_URL
        if not self.DB_APP_PASSWORD:
            raise ValueError("DB_APP_PASSWORD is not set and DATABASE_URL is missing.")

        url = URL.create(
            "mssql+pyodbc",
            username=self.DB_APP_USER,
            password=self.DB_APP_PASSWORD,
            host=self.MSSQL_HOST,
            port=self.MSSQL_PORT,
            database=self.DB_NAME,
            query={
                "driver": self.MSSQL_DRIVER,
                "Encrypt": "yes" if self.MSSQL_ENCRYPT else "no",
                "TrustServerCertificate": "yes"
                if self.MSSQL_TRUST_SERVER_CERTIFICATE
                else "no",
            },
        )
        return url.render_as_string(hide_password=False)


app_settings = AppSettings()
