# Dockerfile

# =========================================================
# ➤ BASE STAGE
# =========================================================

# =========================
# 💿 Base image
# =========================

FROM python:3.14-slim AS base

# =========================
# 🔡 Environment
# =========================

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# =========================
# 📁 Working directory (WORKSPACE)
# =========================

WORKDIR /workspace

# =========================
# 📦 SYSTEM DEPENDENCIES
# =========================

RUN apt-get update && apt-get install -y \
    make \
    && rm -rf /var/lib/apt/lists/*

# =========================
# 📄 Copy application
# =========================

COPY . .

# =========================
# 🚀 PYTHON SETUP
# =========================

RUN pip install --no-cache-dir --upgrade pip


# =========================================================
# ➤ DEVELOPMENT STAGE
# =========================================================

# =========================
# 💿 DEVELOPMENT IMAGE
# =========================

FROM base AS development

# =========================
# 📦 Install DEV dependencies
# =========================

RUN pip install --no-cache-dir -e ".[dev]"

# =========================
# 🚀 Default command
# =========================

ENTRYPOINT ["path-header-scanner"]

CMD ["--help"]


# =========================================================
# ➤ PRODUCTION STAGE
# =========================================================

# =========================
# 💿 PRODUCTION IMAGE
# =========================

FROM base AS production

# =========================
# 📦 INSTALL RUNTIME DEPENDENCIES
# =========================

RUN pip install --no-cache-dir .

# =========================
# 🚀 Default command
# =========================

ENTRYPOINT ["path-header-scanner"]

CMD ["--help"]
