# app/core/initialize/main.py

from rich import print as rprint

from app.core.initialize.generate import ScaffoldGenerator
from app.core.initialize.init_builder import InitBuilder
from app.core.initialize.init_config import InitConfig


class InitMain:
    def execute(self, args):
        # =========================================================
        # 1. Build config (single source of truth)
        # =========================================================
        config = InitConfig(
            mode=args.mode,
            force_init=args.force_init,
            ask=args.ask,
            dry_run=args.dry_run,
            no_debug=not args.debug,
            log_level=args.log_level,
        )

        # =========================================================
        # 2. Build spec
        # =========================================================
        spec = InitBuilder(config).build()

        # =========================================================
        # 3. Execute
        # =========================================================
        generator = ScaffoldGenerator(
            force=config.force_init,
            interactive=config.ask,
        )

        generator.run(
            templates=spec.templates,
            dirs=spec.dirs,
            template_dirs=spec.template_dirs,
        )

        print("\n")

        # =========================================================
        # 4. Output
        # =========================================================
        if spec.messages:
            for msg in spec.messages:
                # print(msg)
                rprint(f"[green]{msg}[/green]")

        rprint("\n[bold green]✅ Initialization complete[/bold green]")
        rprint(f"[dim]Mode: {config.mode.value}[/dim]\n")
        rprint("[bold yellow]💡 Next steps:[/bold yellow]")
        rprint("   [cyan]path-header-scanner run scan[/cyan]\n")
