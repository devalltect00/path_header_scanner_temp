# app/cli/main.py

"""
CLI entrypoint for the path header utility.

This module provides commands for:
- scanning source files
- validating headers
- inserting missing headers
- updating invalid headers
"""

import logging

import typer

from app.core.processor import FileProcessor
from app.core.scanner import FileScanner
from app.languages.html import HtmlLanguageStrategy
from app.languages.javascript import (
    JavaScriptLanguageStrategy,
)
from app.languages.markdown import (
    MarkdownLanguageStrategy,
)
from app.languages.php import PhpLanguageStrategy
from app.languages.python import (
    PythonLanguageStrategy,
)
from app.languages.shell import ShellLanguageStrategy
from app.utils.logging import setup_logging
from app.utils.resolver import resolve_target_path

app = typer.Typer(
    help="Source file path header utility.",
    add_completion=False,
)

logger = logging.getLogger(__name__)


@app.callback(invoke_without_command=True)
def main():
    pass


@app.command()
def scan(
    target_directory: str = typer.Argument(
        ...,
        help="Directory to scan.",
    ),
    workdir: str | None = typer.Option(
        None,
        "--workdir",
        help=("Base working directory used " "to resolve relative paths."),
    ),
    apply: bool = typer.Option(
        False,
        "--apply",
        help="Write changes to files.",
    ),
    include_target_directory: bool = typer.Option(
        True,
        "--include-target-directory/--exclude-target-directory",
        help=("Include the target directory " "in generated headers."),
    ),
    debug: bool = typer.Option(
        False,
        "--debug",
        help="Enable debug logging.",
    ),
) -> None:
    """
    Scan and process source files.

    This command:
    - scans supported files
    - validates path headers
    - inserts missing headers
    - updates invalid headers

    Args:
        target_directory (str):
            Directory to scan.

        workdir (str | None):
            Optional base working directory
            used to resolve relative paths.

        apply (bool):
            Whether file changes should be written.

        debug (bool):
            Enable debug logging.

    Returns:
        None

    Examples:
        Scan only (Scan directory without applying changes):

        >>> python -m app.cli.main scan app

        Apply changes:

        >>> python -m app.cli.main scan app --apply

        Use custom working directory:

        >>> python -m app.cli.main scan src \\
        ...     --workdir /workspace/project
    """

    setup_logging(debug=debug)

    target_path = resolve_target_path(
        target_path=target_directory,
        working_directory=workdir,
    )

    strategies = [
        PythonLanguageStrategy(),
        JavaScriptLanguageStrategy(),
        ShellLanguageStrategy(),
        HtmlLanguageStrategy(),
        PhpLanguageStrategy(),
        MarkdownLanguageStrategy(),
    ]

    logger.info("")
    logger.info("[bold cyan]PATH HEADER SCANNER[/bold cyan]")
    logger.info("")

    logger.debug(
        "[yellow]Target Directory: %s[/yellow]",
        target_directory,
    )

    logger.debug(
        "[yellow]Resolved Path: %s[/yellow]",
        target_path,
    )

    if workdir:

        logger.info(
            "Working Directory: %s",
            workdir,
        )

    logger.info("")

    scanner = FileScanner(
        root_directory=target_path,
        strategies=strategies,
    )

    files = scanner.scan()

    if not files:

        logger.warning("[yellow]No supported files found[/yellow]")

        raise typer.Exit(code=0)

    processor = FileProcessor(
        root_directory=target_path,
        strategies=strategies,
        include_target_directory=include_target_directory,
    )

    results = processor.process_files(
        files=files,
        apply_changes=apply,
    )

    logger.info("")
    logger.info("[bold cyan]SUMMARY[/bold cyan]")

    valid_count = sum(1 for result in results if result.status.value == "valid")

    updated_count = sum(1 for result in results if result.status.value == "updated")

    inserted_count = sum(1 for result in results if result.status.value == "inserted")

    failed_count = sum(1 for result in results if result.status.value == "failed")

    logger.info(
        "[green]Valid:[/green] %s",
        valid_count,
    )

    logger.info(
        "[yellow]Updated:[/yellow] %s",
        updated_count,
    )

    logger.info(
        "[cyan]Inserted:[/cyan] %s",
        inserted_count,
    )

    logger.info(
        "[red]Failed:[/red] %s",
        failed_count,
    )

    logger.info("")

    if apply:
        logger.info("[bold green]Changes applied[/bold green]")
    else:
        logger.info(
            "[bold yellow]" "Dry-run mode " "(no files modified)" "[/bold yellow]"
        )


if __name__ == "__main__":
    app()
