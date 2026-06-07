# app/cli/commands/init/command.py

from types import SimpleNamespace

import typer

# from app.services import InitService
from app.cli.constants.args import CliArgs
from app.cli.constants.enums import LogLevelChoices
from app.config.config_loader import get_config
from app.core.initialize.main import InitMain

from .options import *
from .resolver import resolve_init_args

app = typer.Typer()


@app.callback(
    rich_help_panel="Initialization",
)

# @app.command("init")
def init(
    ctx: typer.Context,
    mode: ModeOption = None,
    force_init: ForceOption = None,
    ask: AskOption = None,
):
    """
    Initialize your project

    🚀 [bold cyan]Initialize your project[/bold cyan]

    Prepare everything needed to start using Path-Header-Scanner.

    [dim]Recommended to run once after installation or in a new project[/dim]

    ────────────────────────────────────────

    📦 [bold]What this command does:[/bold]

      • [green]Create configuration files[/green]

    ────────────────────────────────────────

    📌 [bold]Usage:[/bold]

      [yellow]path-header-scanner init[/yellow]

    ────────────────────────────────────────

    ⚙️ [bold]Options:[/bold]

      [cyan]--mode[/cyan] [dim](config | templates | examples | all)[/dim]
          Choose what to initialize
          [dim]Default: all[/dim]

      [cyan]--force[/cyan]
          Overwrite existing files without confirmation

      [cyan]--ask[/cyan]
          Prompt before creating or overwriting files

    ────────────────────────────────────────

    🧪 [bold]Examples:[/bold]

      [yellow]path-header-scanner init[/yellow]
          [dim]Initialize everything[/dim]

      [yellow]path-header-scanner init --mode config[/yellow]
          [dim]Only create config files[/dim]

      [yellow]path-header-scanner init --force[/yellow]
          [dim]Overwrite existing setup[/dim]

    ────────────────────────────────────────

    💡 [bold]Tips:[/bold]

      • Safe to run multiple times
      • Use [cyan]--mode[/cyan] to initialize specific parts only
    """
    config = get_config()

    # REQUIRED defaults
    cli_args = CliArgs(
        mode=mode,
        force_init=force_init,
        ask=ask,
    )

    args = resolve_init_args(config=config, cli_args=cli_args)

    combined_args = SimpleNamespace(
        **vars(args),
        dry_run=False,
        debug=True,
        log_level=LogLevelChoices.INFO,
    )

    InitMain().execute(combined_args)
