# AGENTS.md

# Project Information

## Project Overview

Path Header Scanner is a Python CLI tool used to scan, validate, and update path headers in source code and documentation files.

### Primary Goals

- Detect missing path headers
- Validate existing path headers
- Update path headers automatically
- Support multiple file types
- Maintain consistent file header standards across the project

---

## Technology Stack

- Python 3.14+
- Typer
- Rich
- Ruff
- Black
- Pytest
- MkDocs

---

## Project Structure

Primary source code:

```text
app/
```

CLI entrypoint:

```text
app/cli/main.py
```

Tests:

```text
tests/
```

Documentation:

```text
docs/
```

See:

```text
docs/project_structure.md
```

---

# Development Standards

## General Coding Standards

- Follow PEP 8
- Use type hints whenever possible
- Prefer pathlib over os.path
- Prefer composition over inheritance
- Prefer dataclasses when appropriate
- Keep functions focused and small
- Prefer readable code over clever code
- Avoid unnecessary abstractions

---

## Implementation Quality

When generating code:

- Prefer complete implementations
- Avoid pseudo-code unless explicitly requested
- Avoid placeholder implementations
- Avoid incomplete examples
- Include imports when needed
- Keep naming consistent with the existing codebase
- Keep responsibilities clearly separated

Bad:

```python
def process():
    pass
```

Good:

```python
def process() -> None:
    """Process project files."""
    ...
```

---

# Documentation Standards

Documentation is mandatory.

Every new:

- File
- Class
- Function
- Public method

must include documentation.

---

## Documentation Coverage

Documentation should remain synchronized with the implementation.

Documentation should cover:

- Application architecture
- Features and workflows
- Commands and CLI usage
- Configuration
- Testing
- Developer workflows
- User workflows
- Major design decisions

See:

```text
docs/
```

for detailed documentation strategy and organization.

---

## File Documentation Format

Preferred format:

```python
# app/services/example_service.py

"""
Example service.

Responsibilities:
- Responsibility A
- Responsibility B
"""
```

---

## Class Documentation Format

Preferred format:

```python
class ExampleService:
    """
    Service responsible for handling example operations.

    Responsibilities:
        - Validate inputs
        - Execute business logic
        - Return processed results
    """
```

---

## Function Documentation Format

Preferred format:

```python
def example(value: str) -> str:
    """
    Example operation.

    Logic:
        Example processing logic.

    Args:
        value (str):
            Input value.

    Returns:
        str:
            Processed value.

    Raises:
        ValueError:
            If value is invalid.

    Examples:
        >>> example("hello")
        'HELLO'
    """
```

### Preferred Section Order

1. Description
2. Logic (optional)
3. Args
4. Returns
5. Raises
6. Notes (optional)
7. Examples (recommended)

---

# Logging Standards

Use logging whenever it improves debugging, monitoring, troubleshooting, or observability.

Preferred log levels:

## CRITICAL

Application cannot continue safely.

Examples:

- Corrupted state
- Fatal startup failure
- Critical system failure

---

## ERROR

Operation failed.

Examples:

- Command execution failure
- Validation failure
- External dependency failure

---

## WARNING

Recoverable issue.

Examples:

- Missing optional file
- Fallback behavior
- Deprecated feature usage

---

## INFO

Important state changes.

Examples:

- Workflow started
- Workflow completed
- File processed
- Command executed

---

## DEBUG

Detailed execution flow.

Examples:

- Function entry
- Variable values
- Branch selection
- Internal execution details

---

## Logging Recommendations

When useful, include:

- execution_time_ms
- processed_files
- failed_files
- success_count
- error_count
- retry_count
- validation_count

---

# API Development Standards

For FastAPI or similar frameworks:

Every route should include:

- summary
- description
- response models
- status codes

Example:

```python
@router.get(
    "/users",
    summary="List users",
    description="Returns all available users."
)
```

Add logging when useful.

---

# Testing Standards

All new functionality should include tests.

Preferred structure:

```text
tests/
├── unit/
├── integration/
└── e2e/
```

Before submitting changes:

Run Pytest or

```bash
make test
```

---

# Documentation Maintenance

Update documentation when:

- Adding commands
- Adding workflows
- Adding configuration options
- Refactoring architecture
- Introducing new subsystems
- Changing user-facing behavior

Important documentation:

```text
docs/installation.md
docs/usage.md
docs/configuration.md
docs/project_structure.md
```

---

# AI Collaboration Rules

This file applies to:

- ChatGPT
- Blackbox AI
- GitHub Copilot
- Cursor
- Claude
- Other AI coding assistants

---

## File Reception

Whenever files are provided:

1. Confirm files were received.
2. Summarize their purpose.
3. Identify missing files if needed.

---

## Missing Context Rule

If implementation requires additional files:

- Ask for the files first.
- Do not invent missing implementations.
- Do not assume project structure.
- Do not guess existing behavior.

---

## Phase-Based Development

Work in phases whenever possible.

### Phase 1 — Analysis

- Review current implementation
- Understand architecture
- Identify issues

### Phase 2 — Design

- Define responsibilities
- Define architecture
- Define affected files

### Phase 3 — Implementation

- Implement changes
- Add logging
- Add tests

### Phase 4 — Documentation

- Update documentation
- Update diagrams
- Update guides

### Phase 5 — Validation

- Run tests
- Validate workflows
- Review documentation

At the end of each phase provide:

- Completed work
- Remaining work
- Required files (if any)
- Recommended documentation updates

---

# Architecture Standards

When introducing significant architectural changes:

- Explain the reasoning
- Explain responsibilities
- Explain dependencies
- Explain trade-offs

Create architecture documentation before moving to the next major feature.

Recommended location:

```text
docs/architecture/
```

Examples:

```text
docs/architecture/
├── overview.md
├── component-responsibilities.md
├── design-patterns.md
├── dependency-flow.md
└── diagrams.md
```

---

## Diagram Requirements

For significant architecture changes:

- Generate Mermaid diagrams
- Explain component relationships
- Explain data flow
- Explain dependency flow

Store diagrams under:

```text
docs/architecture/
```

---

# Long Responses

When generating large code changes:

- Prefer complete file responses
- Avoid truncating implementations
- Avoid omitting important sections
- Split responses logically when needed

---

# Git Workflow

Primary branches:

```text
main
develop
```

Feature branches:

```text
feature/<name>
```

Bug fix branches:

```text
bugfix/<name>
```

Release branches:

```text
release/<version>
```

---

# Do Not

- Do not remove tests without justification.
- Do not remove documentation without justification.
- Do not change public CLI behavior without discussion.
- Do not modify CHANGELOG.md automatically unless explicitly requested.
- Do not bump versions automatically unless explicitly requested.
- Do not introduce architectural changes without explaining the impact.
- Do not invent missing code or files.

---

# Final Response Checklist

Before completing implementation:

- Code completed
- Tests added
- Logging added where appropriate
- Documentation updated
- Diagrams updated (if architecture changed)
- Project structure reviewed
- Missing files identified

Always provide:

1. What changed
2. Why it changed
3. Files modified
4. Documentation updates
5. Next recommended step
