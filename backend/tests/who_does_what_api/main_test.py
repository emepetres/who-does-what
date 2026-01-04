import pytest

from who_does_what_api.main import hello_world


@pytest.mark.parametrize("input_string", ["hello world", "hello1, world2"])
def test_hello_world(input_string: str) -> None:
    upper_string = hello_world(input_string)
    assert upper_string == input_string.upper()
