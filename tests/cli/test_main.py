# tests/cli/test_main.py

"""
Tests for CLI commands.

This module validates:
- CLI execution
- command arguments
- exit codes
- scan command behavior
"""

from pathlib import Path

from typer.testing import CliRunner

from app.cli.main import app
from app.cli.utils import banner

runner = CliRunner()


def test_main_help_shows_banner_by_default(monkeypatch) -> None:
    calls = {"count": 0}

    def fake_show():
        calls["count"] += 1

    monkeypatch.setattr(banner, "show", fake_show)

    result = runner.invoke(
        app,
        ["--help"],
    )

    assert result.exit_code == 0
    assert calls["count"] == 1


def test_main_help_no_banner_flag(monkeypatch) -> None:
    calls = {"count": 0}

    def fake_show():
        calls["count"] += 1

    monkeypatch.setattr(banner, "show", fake_show)

    result = runner.invoke(
        app,
        ["--no-banner", "--help"],
    )

    assert result.exit_code == 0
    assert calls["count"] == 0


def test_scan_command_success(
    tmp_path: Path,
) -> None:
    """
    Test successful scan command execution.

    Args:
        tmp_path (Path):
            Temporary pytest directory.

    Returns:
        None
    """

    file_path = tmp_path / "main.py"

    file_path.write_text(
        'print("hello")\n',
        encoding="utf-8",
    )

    result = runner.invoke(
        app,
        [
            "scan",
            str(tmp_path),
        ],
    )

    assert result.exit_code == 0


def test_scan_command_apply_changes(
    tmp_path: Path,
) -> None:
    """
    Test scan command with apply mode.

    Args:
        tmp_path (Path):
            Temporary pytest directory.

    Returns:
        None
    """

    file_path = tmp_path / "main.py"

    file_path.write_text(
        'print("hello")\n',
        encoding="utf-8",
    )

    result = runner.invoke(
        app,
        [
            "scan",
            str(tmp_path),
            "--apply",
            "--exclude-target-directory",
        ],
    )

    updated_content = file_path.read_text(
        encoding="utf-8",
    )

    assert result.exit_code == 0

    print("updated_content", updated_content)

    assert "# main.py" in updated_content


def test_scan_command_empty_directory(
    tmp_path: Path,
) -> None:
    """
    Test scan command on empty directory.

    Args:
        tmp_path (Path):
            Temporary pytest directory.

    Returns:
        None
    """

    result = runner.invoke(
        app,
        [
            "scan",
            str(tmp_path),
        ],
    )

    assert result.exit_code == 0


def test_scan_command_invalid_directory() -> None:
    """
    Test scan command with invalid directory.

    Returns:
        None
    """

    result = runner.invoke(
        app,
        [
            "scan",
            "non-existent-directory",
        ],
    )

    assert result.exit_code != 0


def test_scan_command_multiple_languages(
    tmp_path: Path,
) -> None:
    """
    Test scan command with multiple languages.

    Args:
        tmp_path (Path):
            Temporary pytest directory.

    Returns:
        None
    """

    python_file = tmp_path / "main.py"

    javascript_file = tmp_path / "main.js"

    php_file = tmp_path / "index.php"

    python_file.write_text(
        'print("hello")\n',
        encoding="utf-8",
    )

    javascript_file.write_text(
        'console.log("hello");\n',
        encoding="utf-8",
    )

    php_file.write_text(
        ('<?php\necho "hello";\n'),
        encoding="utf-8",
    )

    result = runner.invoke(
        app,
        [
            "scan",
            str(tmp_path),
            "--apply",
            "--exclude-target-directory",
        ],
    )

    assert result.exit_code == 0

    assert "# main.py" in python_file.read_text(
        encoding="utf-8",
    )

    assert "// main.js" in javascript_file.read_text(
        encoding="utf-8",
    )

    assert "// index.php" in php_file.read_text(
        encoding="utf-8",
    )
