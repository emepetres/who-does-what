from loguru import logger

from who_does_what_api.settings import app_settings


def hello_world(message: str) -> str:
    return message.upper()


if __name__ == "__main__":
    result = hello_world("Hello world!!")
    logger.info(result)

    logger.info("----Settings sample----")
    logger.info("MY_SAMPLE_VARIABLE", app_settings.MY_SAMPLE_VARIABLE)
    logger.info("ANOTHER_VARIABLE", app_settings.ANOTHER_VARIABLE)
