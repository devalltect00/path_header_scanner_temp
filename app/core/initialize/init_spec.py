# app/core/initialize/init_spec.py

from dataclasses import dataclass
from typing import List, Optional


@dataclass
class InitSpec:
    """
    Initialization Plan

    Represents a fully prepared initialization configuration.

    This is a pure data object used by InitService to execute
    scaffold generation without knowing how the plan was built.

    Execution-ready definition of initialization.

    This is NOT logic.
    This is NOT input.

    This is WHAT will be executed.

    Attributes:
        name (str):
            Human-readable mode name (for logging)

        templates (List):
            List of template files to generate

        dirs (List):
            List of directories to create

        template_dirs (Optional[List]):
            Optional template directories (used for examples)

        messages (List[str]):
            Success messages to display after execution
    """

    name: str
    templates: List
    dirs: List
    template_dirs: Optional[List] = None
    messages: Optional[List[str]] = None
