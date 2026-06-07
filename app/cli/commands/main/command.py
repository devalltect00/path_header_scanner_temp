# app/cli/commands/main/command.py

import logging
import sys

import typer
from typer.main import get_command

from app.cli.constants.args import CliArgs
from app.cli.utils import banner
from app.config.config_loader import get_config

from .options import *
from .resolver import resolve_main_args


def main(
    ctx: typer.Context,
    no_banner: NoBannerOption = None,
    help: HelpOption = None,
    version: VersionOption = None,
):
    # REQUIRED defaults
    cli_args = CliArgs(
        no_banner=no_banner,
        help=help,
        version=version,
    )

    args = resolve_main_args(config=None, cli_args=cli_args)

    if args.help:
        if not args.no_banner:
            banner.show()
        typer.echo(ctx.get_help())
        raise typer.Exit()

    if not args.no_banner:
        banner.show()

    if ctx.invoked_subcommand is None:
        typer.echo(ctx.get_help())
        raise typer.Exit()

    full_command = " ".join(sys.argv[1:])
    logger = logging.getLogger("main")
    logger.debug(
        "[cyan]CLI COMMAND[/cyan] | [dim]Path Header Scanner %s[/dim]", full_command
    )
