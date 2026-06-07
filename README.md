<!-- README.md -->

# Path Header Scanner

![Build](https://github.com/devalltect00/Path-Header-Scanner/actions/workflows/ci.yml/badge.svg)
![Release](https://img.shields.io/github/v/release/devalltect00/Path-Header-Scanner)
![Python](https://img.shields.io/badge/python-3.14+-blue.svg)
![License](https://img.shields.io/github/license/devalltect00/Path-Header-Scanner)
![Ruff](https://img.shields.io/badge/lint-ruff-purple.svg)
![Pytest](https://img.shields.io/badge/tested%20with-pytest-0A9EDC.svg)
![MkDocs](https://img.shields.io/badge/docs-MkDocs-success.svg)

A clean and lightweight developer utility for automatically inserting, validating, and updating file path headers across source code and documentation files.

Supports:

- Python
- JavaScript / TypeScript
- Shell scripts
- PHP
- HTML
- Markdown

Designed for:

- local development
- Docker workflows
- CI/CD pipelines
- multi-language repositories

---

# Features

- Recursive directory scanning
- Automatic path header generation
- Missing header insertion
- Invalid header replacement
- Dry-run support
- Debug logging
- Docker support
- Docker Compose support
- Makefile integration
- Multi-language support
- Markdown support
- Safe header migration
- Shebang preservation
- Encoding declaration preservation
- PHP opening tag preservation

---

# Example

Before:

```python
print("hello")
```

After:

```python
# app/main.py

print("hello")
```

Markdown example:

```md
<!-- docs/path-header/user_guide.md -->

# User Guide
```

---

# Quick Start

# Local

```bash
py -m app scan app
```

Apply changes:

```bash
py -m app scan app --apply
```

Debug mode:

```bash
py -m app scan app --debug
```

---

# Docker

```bash
docker build -t path-header-scanner .
```

Run scanner:

```bash
docker run -it --rm \
    -w /workspace \
    -v "${PWD}:/workspace" \
    path-header-scanner \
    scan app
```

Apply changes:

```bash
docker run -it --rm \
    -w /workspace \
    -v "${PWD}:/workspace" \
    path-header-scanner \
    scan app --apply
```

---

# Makefile Commands

Build Docker image:

```bash
make docker-build
```

Dry-run scan:

```bash
make docker-scan
```

Apply changes:

```bash
make docker-apply
```

Debug mode:

```bash
make docker-debug
```

Custom target:

```bash
make docker-debug TARGET=src
```

---

# Project Structure

```text
app/
├── cli/
├── constants/
├── core/
├── languages/
├── models/
├── utils/
└── __main__.py
```

See full structure in [`project_structure.md`](docs/project_structure.md).

---

# Supported Languages

| Language                | Extensions                   |
| ----------------------- | ---------------------------- |
| Python                  | `.py`                        |
| JavaScript / TypeScript | `.js`, `.jsx`, `.ts`, `.tsx` |
| Shell                   | `.sh`, `.bash`, `.zsh`       |
| PHP                     | `.php`                       |
| HTML                    | `.html`, `.htm`              |
| Markdown                | `.md`, `.markdown`           |

See full documentation in [`supported_languages.md`](docs/path-header/languages/supported_languages.md).

---

# Documentation

# User Documentation

- [`user_guide.md`](docs/path-header/user_guide.md)
- [`docker.md`](docs/path-header/docker.md)

---

# Developer Documentation

- [`developer_guide.md`](docs/path-header/developer_guide.md)
- [`workflow.md`](docs/path-header/workflow.md)
- [`diagrams.md`](docs/path-header/diagrams.md)
- [`design_patterns.md`](docs/path-header/design_patterns.md)
- [`testing.md`](docs/path-header/testing.md)

---

# Language Documentation

- [`supported_languages.md`](docs/path-header/languages/supported_languages.md)
- [`markdown_language_strategy.md`](docs/path-header/languages/markdown_language_strategy.md)

---

# Changelog

See [`CHANGELOG.md`](CHANGELOG.md)

---

# Security

See [`SECURITY.md`](SECURITY.md)

---

# Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md)

---

# License

This project is licensed under the MIT License.

See [`LICENSE`](LICENSE)

---

# Notes

- Paths use POSIX-style separators.
- Docker workflows support mounted workspaces.
- Markdown headers use HTML comments intentionally.
- Existing special lines are preserved safely.
- File updates preserve trailing newlines.
