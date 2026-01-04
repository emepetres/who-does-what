import logging
import sys

import structlog

# Configure structlog to use a processor chain that ends with JSONRenderer
structlog.configure(
    processors=[
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.processors.TimeStamper(fmt="iso", utc=True),
        structlog.processors.StackInfoRenderer(),
        structlog.dev.set_exc_info,  # Captures exc_info for exceptions
        structlog.processors.format_exc_info,  # Formats exception info
        structlog.processors.JSONRenderer(),  # Renders the event dict as JSON
    ],
    logger_factory=structlog.stdlib.LoggerFactory(),
    wrapper_class=structlog.stdlib.BoundLogger,
    cache_logger_on_first_use=True,
)

logging.basicConfig(
    format="%(message)s",
    stream=sys.stdout,
    level=logging.INFO,
)

logger = structlog.get_logger(__name__)
logger.info("Structlog is configured for structured logging.")
