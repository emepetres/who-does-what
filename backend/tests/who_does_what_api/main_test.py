import pytest
from fastapi.testclient import TestClient
from loguru import logger

from who_does_what_api.main import app, hello_world, main

client = TestClient(app)


def test_root_endpoint():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Hello World"}


@pytest.mark.parametrize("input_string", ["hello world", "hello1, world2"])
def test_hello_world(input_string: str) -> None:
    upper_string = hello_world(input_string)
    assert upper_string == input_string.upper()


def test_main() -> None:
    # Intercept loguru logs
    log_messages: list[str] = []
    logger.remove()
    logger.add(lambda msg: log_messages.append(msg))

    # Run the main function
    main()

    # Verify expected log messages appeared
    log_output = " ".join(log_messages)
    assert "HELLO WORLD!!" in log_output
    assert "----Settings sample----" in log_output
    assert "MY_SAMPLE_VARIABLE" in log_output
    assert "ANOTHER_VARIABLE" in log_output
