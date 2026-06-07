# app/cli/commands/main/models.py

from dataclasses import dataclass
from pathlib import Path
from typing import Optional


@dataclass
class MainArgs:
    no_banner: bool
    help: bool
    version: bool | None
