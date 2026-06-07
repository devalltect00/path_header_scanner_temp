# app/cli/commands/scan/models.py

from dataclasses import dataclass
from pathlib import Path
from typing import Optional


@dataclass
class ScanArgs:
    target_directory: str
    workdir: str | None
    apply: bool
    include_target_directory: bool
    debug: bool
