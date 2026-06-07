# app/core/initialize/registry.py

from app.constants.path import (
    PATH_HEADER_SCANNER_SETTINGS,
    TARGET_PROJECT_SOURCE,
)
from app.core.initialize.loader import load_template
from app.core.initialize.template import TemplateFile


def detect_version_file():
    import os

    if os.path.exists(TARGET_PROJECT_SOURCE):
        return f"{TARGET_PROJECT_SOURCE}/__version__.py"
    return "src/__version__.py"


class DirRegistry:
    @staticmethod
    def get_config_directories() -> list[str]:
        return [".config/path_header_scanner"]

    def get_all_directories(self) -> list[str]:
        return [
            *self.get_config_directories,
        ]


class FileRegistry:
    def __init__(self):
        # =========================
        # CONFIG
        # =========================
        self.config = TemplateFile(
            target_path=PATH_HEADER_SCANNER_SETTINGS,
            content=lambda: load_template("config.toml"),
        )

        # =========================
        # VERSION FILE
        # =========================
        self.version = TemplateFile(
            target_path=detect_version_file(),
            content=lambda: load_template("__version__.py"),
        )

    @staticmethod
    def get_config() -> list[TemplateFile]:
        # =========================
        # CONFIG
        # =========================
        return [
            TemplateFile(
                target_path=PATH_HEADER_SCANNER_SETTINGS,
                content=lambda: load_template("config.toml"),
            )
        ]

    @staticmethod
    def get_version() -> list[TemplateFile]:
        # =========================
        # VERSION FILE
        # =========================
        return [
            TemplateFile(
                target_path=detect_version_file(),
                content=lambda: load_template("__version__.py"),
            )
        ]

    def get_all_files(self) -> list[TemplateFile]:
        return [
            *self.get_config(),
            *self.get_version(),
        ]
