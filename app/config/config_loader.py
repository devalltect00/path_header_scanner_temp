# app/config/config_loader.py

import logging
import tomllib
from pathlib import Path
from typing import Any, Optional

from app.constants.path import PATH_HEADER_SCANNER_SETTINGS

logger = logging.getLogger("path_header_scanner.config")


class ConfigError(Exception):
    """Custom exception for configuration-related errors."""

    pass


class ConfigLoader:
    """
    Central configuration loader for Path_header_scanner.

    ---------------------------------------------------------
    🎯 PURPOSE
    ---------------------------------------------------------
    This class loads and manages configuration from `.config/path_header_scanner/config.toml`
    and provides a clean, safe, and flexible way to access values.

    It also supports resolving values between:
        - CLI arguments
        - Config file
        - Default values

    ---------------------------------------------------------
    📁 EXPECTED CONFIG STRUCTURE (.config/path_header_scanner/config.toml)
    ---------------------------------------------------------
    [tool.path_header_scanner.cli.templates]
    commit_message = "templates/commit.txt"

    [tool.path_header_scanner.git]
    auto_push = true

    ---------------------------------------------------------
    🚀 BASIC USAGE
    ---------------------------------------------------------
    config = ConfigLoader()

    # Get nested value
    value = config.get("cli", "templates", "commit_message")

    # Require value (raise error if missing)
    value = config.require("git", "auto_push")

    # Get full section
    section = config.get_section("cli", "templates")

    ---------------------------------------------------------
    🧠 RESOLVE PRIORITY (IMPORTANT)
    ---------------------------------------------------------
    config.resolve(cli_value, ["cli", "templates", "commit_message"], default)

    Priority:
        1. CLI argument
        2. Config file (.config/path_header_scanner/config.toml)
        3. Default value

    ---------------------------------------------------------
    """

    """
    Central configuration loader for Path_header_scanner.

    Responsibilities:
    - Load `.config/path_header_scanner/config.toml`
    - Provide safe nested access
    - Provide CLI fallback resolution
    - Normalize config structure (tool.path_header_scanner.*)

    Usage:
        config = ConfigLoader()
        config.get("cli", "templates", "commit_message")
    """
    """
    Loads configuration from a TOML file (e.g., .path_header_scanner.toml, .config/path_header_scanner/config.toml).
    """

    def __init__(self, filename: str = PATH_HEADER_SCANNER_SETTINGS) -> None:
        """
        Initialize loader.

        Args:
            filename (str): Path to config file.
        """
        self.filename: str = filename
        self.config: dict[str, Any] = self._load()

    # ---------------------------------------------------------
    # Core Loader
    # ---------------------------------------------------------
    def _load(self) -> dict[str, Any]:
        """
        Load TOML config file.

        Returns:
            dict: Parsed config.
        """
        path = Path(self.filename)

        if not path.exists():
            logger.warning(f"Config file not found: {self.filename}")
            return {}

        try:
            with path.open("rb") as f:
                raw = tomllib.load(f)

            # Normalize to tool.path_header_scanner root
            return raw.get("tool", {}).get("path_header_scanner", {})

        except tomllib.TOMLDecodeError as e:
            raise ConfigError(f"Invalid TOML format in '{self.filename}': {e}") from e
        except Exception as e:
            raise ConfigError(f"Failed to load config '{self.filename}': {e}") from e

    # ---------------------------------------------------------
    # Access Helpers
    # ---------------------------------------------------------
    def get(self, *keys: str, default: Optional[Any] = None) -> Any:
        """
        Safely retrieve nested config values.

        Example:
            config.get("cli", "templates", "commit_message")

        Args:
            *keys (str): Nested keys.
            default (Any): Default value if not found.

        Returns:
            Any: Config value or default.
        """
        value: Any = self.config

        for key in keys:
            if not isinstance(value, dict):
                return default
            value = value.get(key)

        return value if value is not None else default

    def require(self, *keys: str) -> Any:
        """
        Same as get(), but raises error if missing.

        Example:
            config.require("git", "auto_push")

        Raises:
            ConfigError
        """
        value = self.get(*keys, default=None)
        if value is None:
            raise ConfigError(f"Missing required config: {'.'.join(keys)}")
        return value

    def get_section(self, *keys: str) -> dict[str, Any]:
        """
        Return a full section as dict.

        Example:
            config.get_section("cli", "templates")
        """
        value = self.get(*keys, default={})
        return value if isinstance(value, dict) else {}

    # ---------------------------------------------------------
    # CLI Resolution (IMPORTANT)
    # ---------------------------------------------------------
    def resolve(
        self,
        cli_value: Any,
        config_keys: list[str],
        default: Any = None,
        *,
        treat_false_as_none: bool = False,
        required: bool = False,
    ) -> Any:
        """
        Resolve value with priority:

        1. CLI argument
        2. Config (.config/path_header_scanner/config.toml)
        3. Default fallback

        Parameters:
            treat_false_as_none:
                If True, False is treated as "not provided" (useful for some flags)

        ---------------------------------------------------------
        🧪 EXAMPLE USAGE
        ---------------------------------------------------------
        result = config.resolve(
            cli_value=message,
            config_keys=["cli", "templates", "commit_message"],
            default="default.txt"
        )

        ---------------------------------------------------------
        📊 EXAMPLE RESULTS
        ---------------------------------------------------------

        Case 1:
            CLI: "custom.txt"
            Config: "config.txt"
            → Result: "custom.txt"

        Case 2:
            CLI: None
            Config: "config.txt"
            → Result: "config.txt"

        Case 3:
            CLI: None
            Config: None
            Default: "default.txt"
            → Result: "default.txt"

        Case 4 (required=True):
            CLI: None
            Config: None
            → ❌ Raises ValueError

        ---------------------------------------------------------
        ⚙️ PARAMETERS
        ---------------------------------------------------------
        treat_false_as_none:
            Useful for flags like:
                --no-cache (False should fallback to config)

        required:
            If True → raise error when no value found
        """

        # Handle special case (optional)
        if treat_false_as_none and cli_value is False:
            cli_value = None

        # 1. CLI
        if cli_value is not None:
            return cli_value

        # 2. Config
        config_value = self.get(*config_keys, default=None)
        if config_value is not None:
            return config_value

        # Required check
        if required:
            raise ValueError(f"Missing required config: {'.'.join(config_keys)}")

        # 3. Default
        return default


# Singleton (optional but recommended)
_config_instance: Optional[ConfigLoader] = None


def get_config() -> ConfigLoader:
    """
    Get shared ConfigLoader instance.

    Example:
        config = get_config()
    """
    global _config_instance
    if _config_instance is None:
        _config_instance = ConfigLoader()
    return _config_instance
