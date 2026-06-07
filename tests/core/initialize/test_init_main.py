"""Tests for InitMain orchestration of initialization generation flow."""

from types import SimpleNamespace

from app.cli.constants.enums import InitMode
from app.core.initialize.main import InitMain


def test_init_main_executes_generator_with_built_spec(monkeypatch) -> None:
    """
    Verify InitMain builds spec and invokes ScaffoldGenerator with expected args.

    Args:
        monkeypatch: Pytest fixture used to replace ScaffoldGenerator class.

    Returns:
        None
    """
    captured = {}

    class FakeGenerator:
        def __init__(self, force, interactive):
            captured["force"] = force
            captured["interactive"] = interactive

        def run(self, templates, dirs, template_dirs):
            captured["templates"] = templates
            captured["dirs"] = dirs
            captured["template_dirs"] = template_dirs

    monkeypatch.setattr(
        "app.core.initialize.main.ScaffoldGenerator",
        FakeGenerator,
    )

    args = SimpleNamespace(
        mode=InitMode.ALL,
        force_init=True,
        ask=False,
        dry_run=False,
        debug=True,
        log_level="info",
    )

    InitMain().execute(args)

    assert captured["force"] is True
    assert captured["interactive"] is False
    assert len(captured["templates"]) == 2
    assert ".config/path_header_scanner" in captured["dirs"]
