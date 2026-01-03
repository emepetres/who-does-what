# AGENTS.md

This document provides essential information for AI coding agents working on this project.

## Project Overview

This is a Python-based backend API project called `who_does_what_api`. The project follows modern Python development practices with a focus on:

- **Dependency Management**: Uses `uv` for fast and reliable dependency management
- **Code Quality**: Enforces code style with `ruff` for both linting and formatting
- **Testing**: Implements Test-Driven Development (TDD) using `pytest`
- **Architecture**: Emphasizes modularization and separation of concerns

### Project Structure

```
backend/
├── src/
│   └── who_does_what_api/    # Main application package
│       ├── __init__.py
│       ├── main.py
│       └── settings.py
├── tests/
│   └── who_does_what_api/    # Test package (mirrors src structure)
│       └── main_tests.py
├── pyproject.toml            # Project configuration and dependencies
├── dev.env                   # Development environment variables
└── README.md                 # Project documentation
```

## Build and Test Commands

### Dependency Management

```bash
# Install all dependencies
uv sync

# Add a new dependency
uv add <package-name>

# Add a development dependency
uv add --dev <package-name>

# Update dependencies
uv lock --upgrade

# Remove a dependency
uv remove <package-name>
```

### Running Tests

```bash
# Run all tests
uv run pytest

# Run tests with coverage
uv run coverage run -m pytest tests
```

### Code Quality

```bash
# Format code with ruff
uv run ruff format .

# Lint code with ruff
uv run ruff check .

# Lint and auto-fix issues
uv run ruff check --fix .

# Run both format and lint
uv run ruff format . && uv run ruff check --fix .
```

### Running the Application

```bash
# Run the application (adjust based on your main.py implementation)
uv run python -m who_does_what_api.main

# Or if using a web framework like FastAPI/Flask
uv run uvicorn who_does_what_api.main:app --reload
```

## Code Style Guidelines

### Ruff Configuration

The project uses `ruff` for both linting and formatting. Configuration is defined in `pyproject.toml`.

**Key principles:**

- Follow PEP 8 style guidelines
- Use consistent formatting (handled automatically by ruff)
- Maximum line length should follow project configuration
- Use type hints where appropriate
- Write clear, self-documenting code with descriptive names

### Code Organization

1. **Modularization**: Break code into small, focused modules

   - Each module should have a single, well-defined responsibility
   - Keep functions and classes small and focused
   - Extract reusable logic into separate modules

2. **Separation of Concerns**:

   - Separate business logic from API/presentation layer
   - Keep configuration separate from application code
   - Use dependency injection where appropriate
   - Avoid tight coupling between components

3. **Naming Conventions**:

   - Use `snake_case` for functions and variables
   - Use `PascalCase` for classes
   - Use `UPPER_CASE` for constants
   - Choose descriptive, meaningful names

4. **Documentation**:

   - Write docstrings for modules, classes, and functions
   - Use clear comments for complex logic
   - Keep README.md updated with project changes

5. **Logging Best Practices**:

   - **Use the `logging` module, not `print()`**: The built-in `logging` module offers log levels, configurability, and contextual information like timestamps and module names. Avoid using `print()` for debugging or tracking events in production code.

   - **Avoid the root logger (use `__name__`)**: Create a logger for each module using `logger = logging.getLogger(__name__)` instead of using the root logger. This prevents configuration conflicts with third-party libraries and provides better context.

   - **Use the correct log levels**:

     - `DEBUG`: Detailed diagnostic information for developers
     - `INFO`: Confirmation that things are working as expected
     - `WARNING`: Unexpected events that don't prevent functionality
     - `ERROR`: Serious problems preventing specific functions
     - `CRITICAL`: Severe errors that might cause application termination

   - **Centralize logging configuration**: Configure logging once at the application's entry point using `logging.config.dictConfig`. Don't sprinkle logging configuration throughout the codebase.

   - **Write meaningful log messages**: Include context and relevant identifiers (user IDs, request IDs, etc.). Use argument-based formatting (e.g., `logger.info("User %s", username)`) to defer formatting unless the message will be emitted.

   - **Embrace structured logging with JSON**: For production systems, use structured logging (e.g., with `structlog`) to produce machine-readable JSON logs. This enables easier filtering, searching, and analysis in observability tools.

## Testing Instructions

### Test-Driven Development (TDD)

This project follows TDD principles:

1. **Write the test first** - Before implementing a feature, write a failing test
2. **Make it pass** - Write the minimal code to make the test pass
3. **Refactor** - Improve the code while keeping tests green

### Testing Guidelines

1. **Test Organization**:

   - All tests are stored under `tests/who_does_what_api/` folder
   - Test file structure mirrors the source code structure
   - Test files are named with `_tests.py` suffix (e.g., `main_tests.py`)

2. **No Mocking by Default**:

   - Mocks will be built as simple as possible if needed, without the use of mock libraries unless instructed otherwise
   - Use test databases or in-memory alternatives when needed
   - Only mock external services (APIs, third-party services) when necessary

3. **Test Quality**:

   - Each test should be independent and isolated
   - Use descriptive test names that explain what is being tested
   - Follow the Arrange-Act-Assert (AAA) pattern
   - Aim for high code coverage, but prioritize meaningful tests

4. **Test Types**:
   - **Unit Tests**: Test individual functions and methods
   - **Integration Tests**: Test interactions between components
   - **End-to-End Tests**: Test complete user workflows (when applicable)

### Example Test Structure

```python
def test_feature_description():
    # Arrange - Set up test data and conditions
    input_data = {...}

    # Act - Execute the code under test
    result = function_under_test(input_data)

    # Assert - Verify the expected outcome
    assert result == expected_value
```

## Security Considerations

### General Security Practices

1. **Dependency Security**:

   - Regularly update dependencies using `uv lock --upgrade`
   - Review security advisories for dependencies
   - Use `pip-audit` or similar tools to scan for vulnerabilities

2. **Secrets Management**:

   - **NEVER commit secrets, API keys, or credentials to version control**
   - Use environment variables for configuration (see `dev.env`)
   - Use `.gitignore` to exclude sensitive files
   - Consider using secret management tools (e.g., Azure Key Vault, AWS Secrets Manager)

3. **Input Validation**:

   - Validate and sanitize all user inputs
   - Use Pydantic models for data validation when applicable
   - Protect against injection attacks (SQL, command, etc.)

4. **Authentication & Authorization**:

   - Implement proper authentication mechanisms
   - Use principle of least privilege
   - Validate user permissions for all operations
   - Use secure session management

5. **API Security**:

   - Implement rate limiting to prevent abuse
   - Use HTTPS in production
   - Implement proper CORS policies
   - Validate and sanitize all API inputs
   - Return appropriate error messages (avoid leaking sensitive information)

6. **Data Protection**:

   - Encrypt sensitive data at rest and in transit
   - Use secure hashing algorithms for passwords (e.g., bcrypt, argon2)
   - Implement proper logging (avoid logging sensitive data)
   - Follow data privacy regulations (GDPR, CCPA, etc.)

7. **Code Security**:
   - Avoid using `eval()` or `exec()` with untrusted input
   - Be cautious with deserialization of untrusted data
   - Keep error messages generic to external users
   - Implement proper exception handling

### Security Checklist for Code Reviews

- [ ] No hardcoded secrets or credentials
- [ ] All user inputs are validated and sanitized
- [ ] Proper error handling without exposing sensitive information
- [ ] Dependencies are up to date and free of known vulnerabilities
- [ ] Authentication and authorization checks are in place
- [ ] Sensitive data is properly encrypted
- [ ] Security best practices are followed for the specific framework/libraries used

---

**Note**: This document should be regularly reviewed and updated as the project evolves and new best practices emerge.
