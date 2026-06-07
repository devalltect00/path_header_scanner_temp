# app/cli/ui/console.py

from rich.console import Console

from app.theme.theme import theme

console = Console(theme=theme.to_rich_theme())
