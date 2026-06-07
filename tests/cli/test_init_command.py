"""Tests for CLI `init` command argument handling and execution wiring."""

from typer.testing import CliRunner

from app.cli.main import app

runner = CliRunner()


def test_init_command_executes_with_defaults(monkeypatch) -> None:
    """
    Verify `init` executes with default resolved arguments.

    Args:
        monkeypatch: Pytest fixture used to replace InitMain.execute.

    Returns:
        None
    """
    captured = {}

    def fake_execute(self, args):
        captured["args"] = args

    monkeypatch.setattr(
        "app.cli.commands.init.command.InitMain.execute",
        fake_execute,
    )

    result = runner.invoke(
        app,
        ["init"],
    )

    assert result.exit_code == 0
    assert "args" in captured
    assert captured["args"].mode == "all"
    assert captured["args"].force_init is False
    assert captured["args"].ask is False


def test_init_command_accepts_flags(monkeypatch) -> None:
    """
    Verify `init` accepts explicit mode/force/ask flags.

    Args:
        monkeypatch: Pytest fixture used to replace InitMain.execute.

    Returns:
        None
    """
    captured = {}

    def fake_execute(self, args):
        captured["args"] = args

    monkeypatch.setattr(
        "app.cli.commands.init.command.InitMain.execute",
        fake_execute,
    )

    result = runner.invoke(
        app,
        ["init", "--mode", "config", "--force", "--ask"],
    )

    assert result.exit_code == 0
    assert "args" in captured
    assert captured["args"].mode == "config"
    assert captured["args"].force_init is True
    assert captured["args"].ask is True
