# app/cli/commands/scan/resolver.py

from .models import ScanArgs


def resolve_scan_args(config, cli_args) -> ScanArgs:
    return ScanArgs(
        target_directory=config.resolve(
            cli_args.target_directory,
            ["cli", "scan", "target_directory"],
            None,
        ),
        workdir=config.resolve(
            cli_args.workdir,
            ["cli", "scan", "workdir"],
            None,
        ),
        apply=config.resolve(
            cli_args.apply,
            ["cli", "scan", "apply"],
            False,
        ),
        include_target_directory=config.resolve(
            cli_args.include_target_directory,
            ["cli", "scan", "include_target_directory"],
            True,
        ),
        debug=config.resolve(
            cli_args.debug,
            ["cli", "execution", "debug"],
            False,
        ),
    )
