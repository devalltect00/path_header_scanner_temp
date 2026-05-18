# Makefile for path-header-scanner

# =========================================================
#
# 🔡 VARIABLES
#
# =========================================================

# ----------------------------------------------------------
# 🔡 VARIABLES - 📦 PROJECT CONFIGURATION
# ----------------------------------------------------------

.DEFAULT_GOAL := help

APP_NAME := path-header-scanner
PROJECT_PACKAGE := path_header_scanner
PROJECT_COMMAND := path-header-scanner

TARGET ?= app
WORKSPACE_DIR := /workspace
WORKDIR ?= $(WORKSPACE_DIR)

# Source Directories
SOURCE_APP := app
SOURCE_TESTS := tests

SOURCE_DIRS := $(SOURCE_APP) $(SOURCE_TESTS)

# ----------------------------------------------------------
# 🔡 VARIABLES - 🖥️ PLATFORM DETECTION
# ----------------------------------------------------------

ifeq ($(OS),Windows_NT)
	PLATFORM := windows

	PYTHON_SYSTEM := python

	VENV_BIN_DIR := Scripts

	VENV_ACTIVATE := activate.bat
	VENV_ACTIVATE_PS := Activate.ps1

	PYTHON_EXECUTABLE := python.exe
	PIP_EXECUTABLE := pip.exe

	NULL_DEVICE := nul
else
	PLATFORM := unix

	PYTHON_SYSTEM := python3

	VENV_BIN_DIR := bin

	VENV_ACTIVATE := activate

	PYTHON_EXECUTABLE := python
	PIP_EXECUTABLE := pip

	NULL_DEVICE := /dev/null
endif

# ----------------------------------------------------------
# 🔡 VARIABLES - 🐍 PYTHON VIRTUAL ENVIRONMENT
# ----------------------------------------------------------

VENV_NAME ?= venv
VENV_DIR := $(CURDIR)/$(VENV_NAME)
VENV_BIN := $(VENV_DIR)/$(VENV_BIN_DIR)

PYTHON := $(VENV_BIN)/$(PYTHON_EXECUTABLE)
PIP := $(VENV_BIN)/$(PIP_EXECUTABLE)

ifeq ($(PLATFORM),windows)
	ACTIVATE_COMMAND := $(VENV_BIN)/$(VENV_ACTIVATE)
	ACTIVATE_COMMAND_PS := $(VENV_BIN)/$(VENV_ACTIVATE_PS)
else
	ACTIVATE_COMMAND := source $(VENV_BIN)/$(VENV_ACTIVATE)
endif

# Lines to exclude from requirements.txt (prefix match)
REQUIREMENTS_EXCLUDE_PREFIXES := -e

# ----------------------------------------------------------
# 🔡 VARIABLES - 🧰 DEVELOPMENT TOOLS
# ----------------------------------------------------------

PYTEST := pytest
RUFF := ruff
BLACK := black
MKDOCS := mkdocs
TWINE := twine
BUILD := build
PRE_COMMIT := pre-commit

# ----------------------------------------------------------
# 🔡 VARIABLES - 🐋 LOCAL APP ARGS
# ----------------------------------------------------------

LOCAL_SCAN_ARGS ?=

# ----------------------------------------------------------
# 🔡 VARIABLES - 🐋 DOCKER CONFIGURATION
# ----------------------------------------------------------

DOCKER := docker
DOCKER_COMPOSE := $(DOCKER) compose

DOCKER_TAG := latest
DOCKER_REPOSITORY := $(APP_NAME)

# Docker Images
DOCKER_IMAGE_BASE := $(APP_NAME)-base:$(DOCKER_TAG)
DOCKER_IMAGE_DEV := $(APP_NAME)-dev:$(DOCKER_TAG)
DOCKER_IMAGE_PROD := $(APP_NAME)-prod:$(DOCKER_TAG)

# Dockerfile
DOCKERFILE_BASE := Dockerfile
# DOCKERFILE_DEV := Dockerfile.dev
# DOCKERFILE_PROD := Dockerfile.prod

DOCKER_RUN := $(DOCKER) run --rm
DOCKER_RUN_INTERACTIVE := $(DOCKER_RUN) -it
DOCKER_RUN_NO_ENTRYPOINT := $(DOCKER_RUN) --entrypoint ""

# Container Shell
SHELL_BIN ?= sh

DOCKER_WORKSPACE := \
	-w $(WORKSPACE_DIR) \
	-v "$(CURDIR):$(WORKSPACE_DIR)"

# ----------------------------------------------------------
# 🔡 VARIABLES - 🐋 DOCKER SERVICES
# ----------------------------------------------------------

# Docker Services name
SERVICE_APP := app
SERVICE_TEST := test
SERVICE_LINT := lint
SERVICE_LINT_FIX := lint-fix
SERVICE_FORMAT := format
SERVICE_FORMAT_CHECK := format-check
SERVICE_DOCS := docs
SERVICE_SHELL := shell
SERVICE_BUILD := build

# ----------------------------------------------------------
# 🔡 VARIABLES - 🐋 DOCKER APP ARGS
# ----------------------------------------------------------

DOCKER_SCAN_ARGS ?=

# ----------------------------------------------------------
# 🔡 VARIABLES - 🐋 DOCKER COMPOSE CONFIGURATION
# ----------------------------------------------------------

# Docker Compose Files
COMPOSE_FILE_BASE := docker-compose.yml
COMPOSE_FILE_DEV := docker-compose.dev.yml
COMPOSE_FILE_PROD := docker-compose.prod.yml

# Development Compose Stack
COMPOSE_BASE_FILES := \
	-f $(COMPOSE_FILE_BASE)

COMPOSE_DEV_FILES := \
	-f $(COMPOSE_FILE_BASE) \
	-f $(COMPOSE_FILE_DEV)

# Production Compose Stack
COMPOSE_PROD_FILES := \
	-f $(COMPOSE_FILE_BASE) \
	-f $(COMPOSE_FILE_PROD)

COMPOSE_BASE := $(DOCKER_COMPOSE) $(COMPOSE_BASE_FILES)
COMPOSE_DEV := $(DOCKER_COMPOSE) $(COMPOSE_DEV_FILES)
COMPOSE_PROD := $(DOCKER_COMPOSE) $(COMPOSE_PROD_FILES)

COMPOSE_DEV_BUILD := $(COMPOSE_DEV) build
COMPOSE_DEV_RUN := $(COMPOSE_DEV) run --rm
COMPOSE_DEV_UP := $(COMPOSE_DEV) up
COMPOSE_DEV_DOWN := $(COMPOSE_DEV) down
COMPOSE_DEV_EXEC := $(COMPOSE_DEV) exec

COMPOSE_DEV_RUN_APP := $(COMPOSE_DEV_RUN) $(SERVICE_APP)
COMPOSE_DEV_RUN_TEST := $(COMPOSE_DEV_RUN) $(SERVICE_TEST)
COMPOSE_DEV_RUN_LINT := $(COMPOSE_DEV_RUN) $(SERVICE_LINT)
COMPOSE_DEV_RUN_LINT_FIX := $(COMPOSE_DEV_RUN) $(SERVICE_LINT_FIX)
COMPOSE_DEV_RUN_FORMAT := $(COMPOSE_DEV_RUN) $(SERVICE_FORMAT)
COMPOSE_DEV_RUN_FORMAT_CHECK := $(COMPOSE_DEV_RUN) $(SERVICE_FORMAT_CHECK)
COMPOSE_DEV_UP_DOCS := $(COMPOSE_DEV_UP) $(SERVICE_DOCS)
COMPOSE_DEV_RUN_SHELL := $(COMPOSE_DEV_RUN) $(SERVICE_SHELL)
COMPOSE_DEV_RUN_BUILD := $(COMPOSE_DEV_RUN) $(SERVICE_BUILD)

COMPOSE_PROD_BUILD := $(COMPOSE_PROD) build
COMPOSE_PROD_RUN := $(COMPOSE_PROD) run --rm
COMPOSE_PROD_UP := $(COMPOSE_PROD) up
COMPOSE_PROD_DOWN := $(COMPOSE_PROD) down

COMPOSE_PROD_RUN_APP := $(COMPOSE_PROD_RUN) $(SERVICE_APP)

# ----------------------------------------------------------
# 🔡 VARIABLES - 🐋 DOCKER COMPOSE APP ARGS
# ----------------------------------------------------------

COMPOSE_SCAN_ARGS ?=

# ----------------------------------------------------------
# 🔡 VARIABLES - 🌐 GITHUB CONTAINER REGISTRY
# ----------------------------------------------------------

CONTAINER_REGISTRY ?= ghcr.io

CONTAINER_USERNAME ?= devalltect00

CONTAINER_REPOSITORY ?=

CONTAINER_TAG ?= latest

CONTAINER_IMAGE = \
	$(CONTAINER_REGISTRY)/$(CONTAINER_USERNAME)/$(CONTAINER_REPOSITORY):$(CONTAINER_TAG)

# ----------------------------------------------------------
# 🔡 VARIABLES - 🌐 GITHUB CONTAINER - Workspace
# ----------------------------------------------------------

REMOTE_WORKSPACE ?= $(CURDIR)

DOCKER_REMOTE_WORKSPACE := \
	-w /workspace \
	-v "$(REMOTE_WORKSPACE):/workspace"

# ----------------------------------------------------------
# 🔡 VARIABLES - 🌐 GITHUB CONTAINER - ARGS
# ----------------------------------------------------------

REMOTE_ARGS ?=

# =========================================================
# 🛠️ INTERNAL HELPERS
# =========================================================

.PHONY: check-venv
check-venv:
ifeq ($(PLATFORM),windows)
	@if not exist "$(PYTHON)" ( \
		echo Virtual environment not found. Run 'make venv' first. && exit 1 \
	)
else
	@test -f "$(PYTHON)" || ( \
		echo "Virtual environment not found. Run 'make venv' first."; \
		exit 1 \
	)
endif


# =========================================================
# ⚙️ SETUP & INSTALLATION
# =========================================================

.PHONY: venv
venv:
	"$(PYTHON_SYSTEM)" -m venv $(VENV_NAME)
	@echo.
	@echo =========================================================
	@echo Virtual environment created successfully.
	@echo =========================================================
	@echo.

.PHONY: activate
activate:
	@echo.
	@echo =========================================================
	@echo Activation Commands
	@echo =========================================================
	@echo.
ifeq ($(PLATFORM),windows)
	@echo CMD:
	@echo   $(ACTIVATE_COMMAND)
	@echo.
	@echo PowerShell:
	@echo   $(ACTIVATE_COMMAND_PS)
else
	@echo $(ACTIVATE_COMMAND)
endif
	@echo.

.PHONY: install
install: check-venv
	"$(PIP)" install -e .

.PHONY: install-dev
install-dev: check-venv
	"$(PIP)" install -e ".[dev]"

.PHONY: install-docs
install-docs: check-venv
	"$(PIP)" install -e ".[docs]"

.PHONY: install-all
install-all: check-venv
	"$(PIP)" install -e ".[dev,docs]"

.PHONY: upgrade-pip
upgrade-pip: check-venv
	"$(PIP)" install --upgrade pip

.PHONY: setup
setup: venv upgrade-pip install-all
	@echo.
	@echo =========================================================
	@echo Project setup completed successfully.
	@echo =========================================================
	@echo.

.PHONY: pre-commit-install
pre-commit-install:
	@echo install hooks
	$(PRE_COMMIT) install

.PHONY: pre-commit-run
pre-commit-run:
	@echo run hooks manually
	$(PRE_COMMIT) run --all-files

.PHONY: pre-commit-update
pre-commit-update:
	@echo update hook versions
	$(PRE_COMMIT) autoupdate

.PHONY: check-python
check-python:
	"$(PYTHON_SYSTEM)" --version


# =========================================================
# 🚀 LOCAL COMMANDS
# =========================================================

.PHONY: l-scan
l-scan:
	$(PROJECT_COMMAND) scan $(TARGET) $(LOCAL_SCAN_ARGS)

.PHONY: l-scan-only
l-scan-only:
	@$(MAKE) l-scan TARGET="$(TARGET)"

.PHONY: l-scan-apply
l-scan-apply:
	@$(MAKE) l-scan TARGET="$(TARGET)" DOCKER_SCAN_ARGS="--apply

.PHONY: l-scan-debug
l-scan-debug:
	@$(MAKE) l-scan TARGET="$(TARGET)" DOCKER_SCAN_ARGS="--debug


# =========================================================
# 🧪 TESTING
# =========================================================

.PHONY: test
test: check-venv
	@echo =========================================================
	@echo Running tests
	@echo =========================================================
	"$(PYTHON)" -m $(PYTEST)

.PHONY: test-verbose
test-verbose: check-venv
	@echo =========================================================
	@echo Running tests (verbose)
	@echo =========================================================
	"$(PYTHON)" -m $(PYTEST) -v

.PHONY: test-cov
test-cov: check-venv
	@echo =========================================================
	@echo Running tests with coverage
	@echo =========================================================
	"$(PYTHON)" -m $(PYTEST) --cov=$(PROJECT_PACKAGE) --cov-report=term-missing


# =========================================================
# 🧶 LINT & FORMAT
# =========================================================

##### RUFF + BLACK

.PHONY: lint
lint: check-venv
	@echo =========================================================
	@echo Running lint checks (ruff)
	@echo =========================================================
	"$(PYTHON)" -m $(RUFF) check $(SOURCE_DIRS)

.PHONY: lint-fix
lint-fix: check-venv
	@echo =========================================================
	@echo Fixing lint issues (ruff)
	@echo =========================================================
	"$(PYTHON)" -m $(RUFF) check $(SOURCE_DIRS) --fix

.PHONY: lint-fix-unsafe
lint-fix-unsafe:
	@echo =========================================================
	@echo Fixing lint issues (ruff) with unsafe-fixes
	@echo =========================================================
	$(PYTHON) -m $(RUFF) check $(SOURCE_DIRS) --fix --unsafe-fixes

.PHONY: format-ruff
format-ruff: check-venv
	@echo =========================================================
	@echo Formatting code (ruff formatter)
	@echo =========================================================
	"$(PYTHON)" -m $(RUFF) format $(SOURCE_DIRS)

.PHONY: format
format: check-venv
	@echo =========================================================
	@echo Formatting code (black)
	@echo =========================================================
	"$(PYTHON)" -m $(BLACK) $(SOURCE_DIRS)

.PHONY: format-check
format-check: check-venv
	@echo =========================================================
	@echo Checking code format (black)
	@echo =========================================================
	@"$(PYTHON)" -m $(BLACK) $(SOURCE_DIRS) --check || ( \
		echo. && \
		echo Code is not formatted. Run 'make format' first. && \
		exit 1 \
	)

.PHONY: fix
fix: check-venv
	@echo =========================================================
	@echo Run Ruff autofix + Black formatter
	@echo =========================================================
	@$(MAKE) format
	@$(MAKE) lint-fix

.PHONY: check
check: check-venv
	@echo =========================================================
	@echo Run local validation workflow
	@echo Run formatting, lint, and tests
	@echo =========================================================
	@$(MAKE) format-check
	@$(MAKE) lint
	@$(MAKE) test

.PHONY: qa
qa:
	@$(MAKE) fix
	@$(MAKE) check

.PHONY: ci
ci: c-ci

.PHONY: check-ci
check-ci:
	@echo =========================================================
	@echo Run CI validation workflow
	@echo =========================================================
	@$(MAKE) format-check
	@$(MAKE) lint
	@$(MAKE) test


# =========================================================
# 📚 Documentation
# =========================================================

.PHONY: docs-serve
docs-serve: check-venv
	"$(PYTHON)" -m $(MKDOCS) serve

.PHONY: docs-build
docs-build: check-venv
	"$(PYTHON)" -m $(MKDOCS) build


# =========================================================
# 📦 REQUIREMENTS
# =========================================================

.PHONY: requirements
requirements: check-venv
	@echo.
	@echo =========================================================
	@echo Generating requirements.txt from virtual environment...
	@echo =========================================================
	@echo.
	@"$(PYTHON)" -c "import subprocess; \
prefixes = tuple('$(REQUIREMENTS_EXCLUDE_PREFIXES)'.split()); \
req = subprocess.check_output([r'$(PIP)', 'freeze'], text=True); \
filtered = '\n'.join(line for line in req.splitlines() if not line.startswith(prefixes)); \
open('requirements.txt', 'w').write(filtered + '\n')"
	@echo Cleaning comment lines from requirements.txt...
	@"$(PYTHON)" -c "from pathlib import Path; \
p = Path('requirements.txt'); \
lines = p.read_text().splitlines(); \
cleaned = '\n'.join(line for line in lines if not line.lstrip().startswith('# Editable install')); \
p.write_text(cleaned + '\n')"
	@echo.
	@echo requirements.txt generated successfully (filtered).


# =========================================================
# 📦 BUILD & PUBLISH
# =========================================================

.PHONY: build
build: check-venv clean-cache
	"$(PYTHON)" -m $(BUILD)

.PHONY: publish
publish: check-venv
	"$(PYTHON)" -m $(TWINE) upload dist/*

.PHONY: build-all
build-all: build d-build-all


# =========================================================
# 🐋 DOCKER BUILD
# =========================================================

.PHONY: d-build-base
d-build-base:
	$(DOCKER) build -f $(DOCKERFILE_BASE) -t $(DOCKER_IMAGE_BASE) .

.PHONY: d-build-dev
d-build-dev: d-build-base
	$(DOCKER) build -f $(DOCKERFILE_BASE) --target development -t $(DOCKER_IMAGE_DEV) .

.PHONY: d-build-prod
d-build-prod: d-build-base
	$(DOCKER) build -f $(DOCKERFILE_BASE) --target production -t $(DOCKER_IMAGE_PROD) .

.PHONY: d-build-all
d-build-all: d-build-base d-build-dev d-build-prod

# =========================================================
# 🐋 DOCKER RUN (DEV)
# =========================================================

.PHONY: d-test
d-test:
	$(DOCKER_RUN_NO_ENTRYPOINT) $(DOCKER_WORKSPACE) $(DOCKER_IMAGE_DEV) python -m pytest -v

# =========================================================
# 🐋 DOCKER RUN (PROD)
# =========================================================

.PHONY: d-scan
d-scan:
	$(DOCKER_RUN_INTERACTIVE) $(DOCKER_WORKSPACE) $(DOCKER_IMAGE_PROD) scan $(TARGET) $(DOCKER_SCAN_ARGS)

.PHONY: d-scan-only
d-scan-only:
	@$(MAKE) d-scan TARGET="$(TARGET)"

.PHONY: d-scan-apply
d-scan-apply:
	@$(MAKE) d-scan TARGET="$(TARGET)" DOCKER_SCAN_ARGS="--apply"

.PHONY: d-scan-debug
d-scan-debug:
	@$(MAKE) d-scan TARGET="$(TARGET)" DOCKER_SCAN_ARGS="--debug"

# =========================================================
# 🐋 DOCKER COMPOSE
# =========================================================

.PHONY: c-build-base
c-build-base:
	$(COMPOSE_BASE) build base

.PHONY: c-build-dev
c-build-dev:
	$(COMPOSE_DEV) build

.PHONY: c-build-prod
c-build-prod:
	$(COMPOSE_PROD) build

.PHONY: c-build-all
c-build-all: c-build-base
	$(COMPOSE_DEV) build
	$(COMPOSE_PROD) build

.PHONY: c-up
c-up:
	$(COMPOSE_DEV) up

.PHONY: c-up-build
c-up-build:
	$(COMPOSE_DEV) up --build

.PHONY: c-up-detached
c-up-detached:
	$(COMPOSE_DEV) up -d

.PHONY: c-down
c-down:
	$(COMPOSE_DEV) down

c-down-clean:
	$(COMPOSE_DEV) down -v --remove-orphans

c-logs:
	$(COMPOSE_DEV) logs -f


# =========================================================
# 🐋 DOCKER COMPOSE RUN PROJECT
# =========================================================

.PHONY: c-scan
c-scan:
	$(COMPOSE_PROD_RUN_APP) scan $(TARGET) $(COMPOSE_SCAN_ARGS)

.PHONY: c-scan-only
c-scan-only:
	@$(MAKE) c-scan TARGET="$(TARGET)"

.PHONY: c-scan-apply
c-scan-apply:
	@$(MAKE) c-scan TARGET="$(TARGET)" COMPOSE_SCAN_ARGS="--apply"

.PHONY: c-scan-debug
c-scan-debug:
	@$(MAKE) c-scan TARGET="$(TARGET)" COMPOSE_SCAN_ARGS="--debug"

.PHONY: c-test
c-test:
	$(COMPOSE_DEV_RUN_TEST)

.PHONY: c-lint
c-lint:
	$(COMPOSE_DEV_RUN_LINT)

.PHONY: c-lint-fix
c-lint-fix:
	$(COMPOSE_DEV_RUN_LINT_FIX)

.PHONY: c-format
c-format:
	$(COMPOSE_DEV_RUN_FORMAT)

.PHONY: c-format-check
c-format-check:
	$(COMPOSE_DEV_RUN_FORMAT_CHECK)

.PHONY: c-docs
c-docs:
	$(COMPOSE_DEV_UP_DOCS) -d

.PHONY: c-shell
c-shell:
	$(COMPOSE_DEV_RUN_SHELL)

.PHONY: c-build-package
c-build-package:
	$(COMPOSE_DEV_RUN_BUILD)

.PHONY: c-exec-shell
c-exec-shell:
	$(COMPOSE_DEV_EXEC) $(SERVICE_APP) $(SHELL_BIN)

.PHONY: c-fix
c-fix:
	@echo format and lint autofix
	@$(MAKE) c-format
	@$(MAKE) c-lint-fix

.PHONY: c-check
c-check:
	@echo Validation only
	@$(MAKE) c-format-check
	@$(MAKE) c-lint
	@$(MAKE) c-test

.PHONY: c-qa
c-qa:
	@echo Full Quality Workflow
	@$(MAKE) c-fix
	@$(MAKE) c-check

.PHONY: c-ci
c-ci:
	@echo CI Workflow
	@$(MAKE) c-build-dev
	@$(MAKE) c-check

# =========================================================
# 🌐 REMOTE CONTAINER - PATH HEADER SCAN
# =========================================================

# GITHUB REMOTE CONTAINER

.PHONY: r-phs-pull
r-phs-pull: CONTAINER_REPOSITORY=path_header_scanner
r-phs-pull:
	$(DOCKER) pull $(CONTAINER_IMAGE)

.PHONY: r-phs-scan
r-phs-scan: CONTAINER_REPOSITORY=path_header_scanner
r-phs-scan:
	$(DOCKER_RUN_INTERACTIVE) \
	$(DOCKER_REMOTE_WORKSPACE) \
	$(CONTAINER_IMAGE) \
	scan $(TARGET) $(REMOTE_ARGS)

.PHONY: r-phs-scan-only
r-phs-scan-only:
	@$(MAKE) r-phs-pull
	@$(MAKE) r-phs-scan TARGET="$(TARGET)"

.PHONY: r-phs-scan-apply
r-phs-scan-apply:
	@$(MAKE) r-phs-pull
	@$(MAKE) r-phs-scan \
		TARGET="$(TARGET)" \
		REMOTE_ARGS="--apply"

.PHONY: r-phs-scan-debug
r-phs-scan-debug:
	@$(MAKE) r-phs-pull
	@$(MAKE) r-phs-scan \
		TARGET="$(TARGET)" \
		REMOTE_ARGS="--debug"

# =========================================================
# 🔧 GIT UTILITIES
# =========================================================

.PHONY: git-current-branch
git-current-branch:
	git branch --show-current

.PHONY: git-url-origin
git-url-origin:
	git remote get-url origin

.PHONY: git-log
git-log:
	git log --oneline --graph --decorate --all -n 25

.PHONY: git-tags
git-tags:
	git log --no-walk --tags --pretty="format:%h %d %s"


# =========================================================
# 🧹 CLEANUP
# =========================================================

.PHONY: clean-cache
clean-cache:
	@echo Cleaning cache and build artifacts...
	@$(PYTHON_SYSTEM) -c "import pathlib, shutil;
	paths = ['.pytest_cache', '.ruff_cache', '.mypy_cache', '.coverage', 'htmlcov', 'build', 'dist'];
	[shutil.rmtree(p, ignore_errors=True) for p in paths if pathlib.Path(p).exists()]"
	@$(PYTHON_SYSTEM) -c "import pathlib, shutil;
	[shutil.rmtree(p, ignore_errors=True) for p in pathlib.Path('.').glob('*.egg-info')]"
	@echo Cache cleanup completed.

.PHONY: clean-pyc
clean-pyc:
	@echo Cleaning Python cache files...
	@$(PYTHON_SYSTEM) -c "import pathlib;
	[p.unlink() for p in pathlib.Path('.').rglob('*.pyc') if p.exists()]"
	@$(PYTHON_SYSTEM) -c "import pathlib, shutil;
	[shutil.rmtree(p, ignore_errors=True) for p in pathlib.Path('.').rglob('__pycache__')]"
	@echo Python cache cleanup completed.

.PHONY: clean-venv
clean-venv:
	@echo Removing virtual environment...
	@$(PYTHON_SYSTEM) -c "import pathlib, shutil;
	venv = pathlib.Path('$(VENV_NAME)');
	shutil.rmtree(venv, ignore_errors=True) if venv.exists() else None"
	@echo Virtual environment removed.

.PHONY: clean-all
clean-all: clean-cache clean-pyc
	@echo Full cleanup completed.

.PHONY: d-remove-images
d-remove-images:
	@echo Removing Docker images...
	-$(DOCKER) rmi $(DOCKER_IMAGE_BASE)
	-$(DOCKER) rmi $(DOCKER_IMAGE_DEV)
	-$(DOCKER) rmi $(DOCKER_IMAGE_PROD)
	@echo Docker image cleanup completed.

.PHONY: d-prune
d-prune:
	$(DOCKER) system prune -f

.PHONY: d-prune-all
d-prune-all:
	$(DOCKER) system prune -a -f --volumes


# =========================================================
# 🆘 HELP
# =========================================================

.PHONY: help
help:
	@echo.
	@echo =========================================================
	@echo  $(APP_NAME) - Available Commands
	@echo =========================================================
	@echo.

	@echo [Setup ^& Installation]
	@echo   make venv                     Create virtual environment
	@echo   make activate                 Show activation command
	@echo   make install                  Install package
	@echo   make install-dev              Install package with development dependencies
	@echo   make install-docs             Install package with documentation dependencies
	@echo   make install-all              Install all optional dependencies
	@echo   make upgrade-pip              Upgrade pip inside virtual environment
	@echo   make setup                    Full project setup
	@echo.
	@echo   make pre-commit-install       Install pre-commit Git hooks
	@echo   make pre-commit-run           Run pre-commit hooks manually
	@echo   make pre-commit-update        Update pre-commit hook versions
	@echo.
	@echo   make check-python             Show system Python version
	@echo.

	@echo [Quality Assurance]
	@echo   make fix                      Apply formatting and automatic lint fixes
	@echo   make check                    Run formatting checks, lint, and tests
	@echo   make qa                       Run fix + check workflow
	@echo   make ci                       Run compose-based CI validation
	@echo.

	@echo [Local Validation]
	@echo   make check                  Run formatting checks, lint, and tests using local virtual environment
	@echo   make check-ci               Run CI-compatible formatting checks, lint, and tests without local venv dependency
	@echo.

	@echo [Lint ^& Format]
	@echo   make lint                     Run Ruff lint checks
	@echo   make lint-fix                 Run Ruff autofix
	@echo   make lint-fix-unsafe          Run Ruff autofix including unsafe fixes
	@echo   make format-ruff              Format code using Ruff formatter
	@echo   make format                   Format code using Black
	@echo   make format-check             Check Black formatting without modifying files
	@echo.

	@echo [Testing]
	@echo   make test                     Run tests
	@echo   make test-verbose             Run tests with verbose output
	@echo   make test-cov                 Run tests with coverage
	@echo.

	@echo [Documentation]
	@echo   make docs-serve               Serve MkDocs locally
	@echo   make docs-build               Build MkDocs site
	@echo.

	@echo [Requirements]
	@echo   make requirements             Generate requirements.txt using pip freeze
	@echo.

	@echo [Build ^& Publish]
	@echo   make build                    Build package artifacts
	@echo   make publish                  Publish package using Twine
	@echo.

	@echo [Local Commands]
	@echo   make l-scan TARGET=^<path^> LOCAL_SCAN_ARGS=              Run scanner locally with custom arguments
	@echo   make l-scan-only TARGET=^<path^>                          Run scanner locally with default settings
	@echo   make l-scan-apply TARGET=^<path^>                         Run scanner locally and apply changes
	@echo   make l-scan-debug TARGET=^<path^>                         Run scanner locally in debug mode
	@echo.

	@echo [Docker]
	@echo   make d-build-base             Build base Docker image
	@echo   make d-build-dev              Build development Docker image
	@echo   make d-build-prod             Build production Docker image
	@echo   make d-build-all              Build all Docker images
	@echo.
	@echo   make d-scan TARGET=^<path^> DOCKER_SCAN_ARGS=             Run scanner inside Docker with custom arguments
	@echo   make d-scan-only TARGET=^<path^>                          Run scanner in Docker with default settings
	@echo   make d-scan-apply TARGET=^<path^>                         Run scanner in Docker and apply changes
	@echo   make d-scan-debug TARGET=^<path^>                         Run scanner in Docker in debug mode
	@echo.
	@echo   make d-test                   Run pytest inside Docker
	@echo.

	@echo [Docker Compose]
	@echo   make c-build-base             Build base compose image
	@echo   make c-build-dev              Build development compose stack
	@echo   make c-build-prod             Build production compose stack
	@echo   make c-build-all              Build all compose stacks
	@echo.
	@echo   make c-up                     Start development compose stack
	@echo   make c-up-build               Start compose stack and rebuild images
	@echo   make c-up-detached            Start compose stack in background
	@echo   make c-down                   Stop compose stack
	@echo.
	@echo   make c-scan TARGET=^<path^> COMPOSE_SCAN_ARGS=            Run scanner using compose with custom arguments
	@echo   make c-scan-only TARGET=^<path^>                          Run scanner using compose with default settings
	@echo   make c-scan-apply TARGET=^<path^>                         Run scanner using compose and apply changes
	@echo   make c-scan-debug TARGET=^<path^>                         Run scanner using compose in debug mode
	@echo.
	@echo   make c-test                   Run tests using compose
	@echo.
	@echo   make c-check                  Run formatting checks, lint, and tests using Docker Compose
	@echo   make c-fix                    Run formatting and lint autofix using Compose
	@echo   make c-qa                     Run full QA workflow using compose
	@echo   make c-ci                     Run Full CI workflow using Docker Compose
	@echo.
	@echo   make c-lint                   Run linter using compose
	@echo   make c-lint-fix               Run Ruff autofix using compose
	@echo   make c-format                 Run formatter using compose
	@echo   make c-format-check           Check Black formatting using compose
	@echo.
	@echo   make c-docs                   Run documentation service
	@echo   make c-shell                  Open shell service
	@echo   make c-build-package          Build package using compose
	@echo   make c-exec-shell             Execute shell inside running app container
	@echo.

	@echo [Remote Container - Path Header Scanner]
	@echo   make r-phs-pull                                         Pull remote container image from registry
	@echo.
	@echo   make r-phs-scan TARGET=^<path^> REMOTE_ARGS=              Run scanner from remote container image
	@echo   make r-phs-scan-only TARGET=^<path^>                      Run scanner from remote container with default settings
	@echo   make r-phs-scan-apply TARGET=^<path^>                     Run scanner from remote container and apply changes
	@echo   make r-phs-scan-debug TARGET=^<path^>                     Run scanner from remote container in debug mode
	@echo.

	@echo [Git Utilities]
	@echo   make git-current-branch       Show current branch
	@echo   make git-url-origin           Show Git remote origin URL
	@echo   make git-log                  Show recent commit history
	@echo   make git-tags                 Show tags
	@echo.

	@echo [Cleanup]
	@echo   make clean-cache              Remove cache and build artifacts
	@echo   make clean-pyc                Remove Python cache files
	@echo   make clean-venv               Remove virtual environment
	@echo   make clean-all                Run full cleanup
	@echo.
	@echo   make d-remove-images          Remove project Docker images
	@echo   make d-prune                  Run Docker system prune
	@echo   make d-prune-all              Remove all unused Docker resources
	@echo.

	@echo [Variables]
	@echo   TARGET=^<dir^>                  Target directory to scan
	@echo   VENV_NAME=^<name^>              Virtual environment directory name
	@echo   DOCKER_TAG=^<tag^>              Docker image tag
	@echo.
	@echo   LOCAL_SCAN_ARGS=^<args^>        Additional arguments for local scan commands
	@echo   DOCKER_SCAN_ARGS=^<args^>       Additional arguments for Docker scan commands
	@echo   COMPOSE_SCAN_ARGS=^<args^>      Additional arguments for compose scan commands
	@echo.
	@echo   REMOTE_WORKSPACE=^<path^>       Workspace directory mounted into remote container
	@echo   REMOTE_ARGS=^<args^>            Additional arguments passed to remote scanner
	@echo   CONTAINER_TAG=^<tag^>           Remote container image tag
	@echo   CONTAINER_USERNAME=^<name^>     Remote container registry username
	@echo.
	@echo   CONTAINER_REGISTRY=^<registry^> Remote container registry
	@echo   CONTAINER_REPOSITORY=^<repo^>   Remote container repository
	@echo.

	@echo [Examples]
	@echo   make l-scan-only TARGET=app WORKDIR=workspace
	@echo   make d-scan-apply TARGET=tests
	@echo   make c-scan-debug TARGET=.
	@echo.
	@echo.
	@echo   # --------------------------------------------------
	@echo   # Local Development Workflow
	@echo   # --------------------------------------------------
	@echo   make l-scan-only TARGET=app
	@echo   make l-scan-apply TARGET=tests
	@echo   make test
	@echo   make check
	@echo.
	@echo   # --------------------------------------------------
	@echo   # Docker Workflow
	@echo   # --------------------------------------------------
	@echo   make d-build-dev
	@echo   make d-scan-only TARGET=app
	@echo   make d-scan-debug TARGET=.
	@echo   make d-test
	@echo.
	@echo   # --------------------------------------------------
	@echo   # Docker Compose Workflow
	@echo   # --------------------------------------------------
	@echo   make c-build-dev
	@echo   make c-scan-only TARGET=app
	@echo   make c-test
	@echo   make c-check
	@echo.
	@echo   # --------------------------------------------------
	@echo   # Full QA Workflow
	@echo   # --------------------------------------------------
	@echo   make c-qa
	@echo.
	@echo   # --------------------------------------------------
	@echo   # CI Workflow
	@echo   # --------------------------------------------------
	@echo   make c-ci
	@echo.
	@echo   # --------------------------------------------------
	@echo   # Remote Container Workflow - Path Header Scanner
	@echo   # --------------------------------------------------
	@echo   # Pull latest remote image
	@echo   make r-phs-pull
	@echo.
	@echo   # Pull a specific image version
	@echo   make r-phs-pull CONTAINER_TAG=1.2.3
	@echo.
	@echo   # Pull image using SHA tag
	@echo   make r-phs-pull CONTAINER_TAG=sha-80e987cab9263c49275927465242be9a187b2dfb
	@echo.
	@echo   # Pull image using specified repository name and tag
	@echo   make r-phs-pull CONTAINER_REPOSITORY=path_header_scanner CONTAINER_TAG=latest
	@echo.
	@echo   # Common command
	@echo   make r-phs-scan-only TARGET=app
	@echo   make r-phs-scan-apply TARGET=tests
	@echo   make r-phs-scan-debug TARGET=.
	@echo.
	@echo   # Scan another local project using remote image
	@echo   make r-phs-scan-only REMOTE_WORKSPACE="E:/another-project" TARGET=.
	@echo.
	@echo   # Use a specific container image version
	@echo   make r-phs-scan-only TARGET=. CONTAINER_TAG=1.0.0
	@echo.

	@echo =========================================================
