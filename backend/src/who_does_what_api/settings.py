from typing import ClassVar

from pydantic_settings import BaseSettings, SettingsConfigDict


class AppSettings(BaseSettings):
    model_config: ClassVar[SettingsConfigDict] = SettingsConfigDict(
        env_file="dev.env", env_file_encoding="utf-8"
    )
    MY_SAMPLE_VARIABLE: str = "DEFAULT_VALUE"
    ANOTHER_VARIABLE: int = 1


app_settings = AppSettings()
