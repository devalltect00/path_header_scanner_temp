# app/cli/commands/main/options.py

from pathlib import Path
from typing import Annotated, List, Optional

import typer

from app.cli.utils import version_callback

# ---------------------------
# EXECUTION OPTIONS
# ---------------------------
NoBannerOption = Annotated[
    bool,
    typer.Option(
        "--no-banner",
        help="""
        Disable banner

        [dim blue]Default:[/dim blue] [red]False[/red]
        """,
    ),
]
HelpOption = Annotated[
    bool,
    typer.Option(
        "--help",
        "-h",
        help="Show help",
    ),
]
VersionOption = Annotated[
    bool | None,
    typer.Option(
        "--version",
        "-v",
        help="Get app version",
        callback=version_callback,
    ),
]
