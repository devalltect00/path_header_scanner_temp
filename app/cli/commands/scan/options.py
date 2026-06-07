# app/cli/commands/scan/options.py

from pathlib import Path
from typing import Annotated, List, Optional

import typer

from app.cli.constants.completions import (
    completion_target_directory,
)

# ---------------------------
# EXECUTION OPTIONS
# ---------------------------

targetDirectoryOption = Annotated[
    str,
    typer.Argument(
        ...,
        help="Directory to scan.",
        autocompletion=completion_target_directory,
    ),
]
workDirOption = Annotated[
    str | None,
    typer.Option(
        "--workdir",
        help=("Base working directory used to resolve relative paths."),
    ),
]
applyOption = Annotated[
    bool,
    typer.Option(
        "--apply",
        help="Write changes to files.",
    ),
]
includeTargetDirectoryOption = Annotated[
    bool,
    typer.Option(
        "--include-target-directory/--exclude-target-directory",
        help=("Include the target directory in generated headers."),
    ),
]
debugOption = Annotated[
    bool,
    typer.Option(
        "--debug",
        help="Enable debug logging.",
    ),
]
