# app/utils/logging.py

"""
Application logging configuration.

This module provides Rich-based console logging
for the application.

Features:
- colored console output
- clean message formatting
- optional debug mode
"""

import logging
from typing import Optional

from rich.logging import RichHandler


def setup_logging(
    level: Optional[str] = None,
    debug: bool = False,
) -> None:
    """
    Configure application-wide logging.

    Args:
        level (Optional[str]):
            Optional logging level override.

        debug (bool):
            Enable debug logging.

    Returns:
        None

    Examples:
        >>> setup_logging()
    """

    if debug:
        logging_level = logging.DEBUG

    elif level:
        logging_level = getattr(
            logging,
            level.upper(),
            logging.INFO,
        )

    else:
        logging_level = logging.INFO

    logging.basicConfig(
        level=logging_level,
        format="%(message)s",
        handlers=[
            RichHandler(
                markup=True,
                rich_tracebacks=True,
                show_time=False,
                show_level=False,
            )
        ],
    )
