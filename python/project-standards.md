---
profile: python
version: 1.0
scope: standards
source_repo: https://github.com/jmackown/dev-standards
last_updated: 2025-10-17
description: >
  Python project standards for all organisational repositories.
  Defines baseline expectations for code quality, structure, and tooling.
---

# 🧠 Python Project Standards

These standards define the baseline for Python projects and contributions across our organisation.  
They apply equally to human developers and AI-assisted tools (CLI, IDE, or agent-based).  
Existing projects may differ — always adapt to local conventions.

---

### 🚫 Scope and Application

These standards define the **target state** for new Python projects and substantial refactors.  
They are **not retroactive** — do **not** automatically modify legacy projects or existing codebases
to conform unless explicitly requested by a human maintainer.

AI-assisted tools must treat these standards as **reference guidance**, not commands.  
If an existing project already uses different, functional tooling (e.g. Poetry, Black, or Flake8),
those configurations are authoritative for that project until a deliberate migration plan is approved.

---

## 🏁 How to Use This Document

- Treat this file as the **source of truth** for new projects or major refactors.  
- If contributing to an **existing repository**, check its `pyproject.toml`, `Makefile`, and `README` — these override anything here if different.  
- AI tools (e.g. Claude Code, Codex, Gemini CLI, Cursor, Windsurf) should read this file to determine:
  - Which tools and formatters to use (`ruff`, `uv`, etc.),
  - How to handle venvs and Docker builds,
  - When **not** to refactor automatically.  
- This is a **living standard** — propose updates through PRs and review.

---

## 🧩 Coding Style & Architecture

- **Python version**: ≥3.11  
- **Formatting**: 4-space indentation, UTF-8 encoding  
- **Naming conventions**:  
  - `snake_case` → functions, variables  
  - `PascalCase` → classes  
  - `UPPER_SNAKE_CASE` → constants  
  - Modules/packages → lowercase  
- **Typing**:  
  - All public functions and data models must be type-annotated.  
  - Use `from __future__ import annotations`.  
  - Prefer `typing` / `typing_extensions` for type hints and generics.  
- **Docstrings**: concise; include inputs, outputs, and side effects. Use Google- or NumPy-style consistently.  
- **Imports**: absolute only, grouped as `stdlib`, `third-party`, `local`.  
- **Formatting & linting**:  
  - `ruff check` for linting and import order.  
  - `ruff format` for code formatting (no `black`).  
  - Enforce max line length ≤100.  
- **Dependency management**:  
  - New projects use [`uv`](https://docs.astral.sh/uv) for dependency management and builds.  
  - Pin dependencies; separate dev dependencies in `[tool.uv.dev-dependencies]`.  
- **Virtual environments**:  
  - Always use a venv (`uv venv` or `python -m venv`).  
  - Code must work both locally and in Docker — no reliance on global site-packages.  
- **Preferred frameworks and libraries**:  
  - **Web/API:** [`FastAPI`](https://fastapi.tiangolo.com)  
  - **Validation & config:** [`Pydantic`](https://docs.pydantic.dev) (v2)  
  - **Logging:** [`structlog`](https://www.structlog.org)  
  - **Testing:** [`pytest`](https://docs.pytest.org)  
  - **Lint/format/type:** `ruff`, `mypy`, `uv`  
- **Design**:  
  - Prefer composition over inheritance.  
  - Keep modules cohesive and small — one purpose per file.  
  - Functions <50 lines, classes <300 lines (guideline).  
  - For FastAPI: group routers per domain (`articles.py`, `sources.py`, `runs.py`).  
- **Boundaries**: validate and serialise at I/O edges (API, DB, LLM calls).  
- **Async**: prefer async endpoints and clients; avoid blocking I/O.  
- **Language & locale**:  
  - Docs/UI use British English (“colour”, “organisation”).  
  - Dates use UK format (DD/MM/YYYY).  
  - Code identifiers may follow library spellings.  
- **Pragmatism**:  
  - Don’t reinvent the wheel.  
  - Prefer maintained libraries over new internal code.  
  - When suggesting an external package, explain pros/cons and maintenance impact.  
  - Custom implementations only when they add measurable value (performance, domain-specific behaviour, or integration needs).

---

## 🧾 Logging Standards

- Use [`structlog`](https://www.structlog.org) for all application logging.  
- Log entries must always include:  
  - `request_id`: unique per inbound request (e.g. per FastAPI request).  
  - `correlation_id`: shared across calls between services to trace distributed workflows.  
- Use structured JSON logs (`logger.info("message", key=value, ...)`).  
- Log at appropriate levels:  
  - `debug` for diagnostics,  
  - `info` for normal operation,  
  - `warning` for recoverable issues,  
  - `error` for failed operations.  
- No print statements in production code.  
- Logs must be UTC and container-safe (stdout/stderr).  
- Mask or redact secrets and user data before logging.

---

## 🧪 Testing & Quality

- **Framework**: Pytest only.  
- **Layout**: mirror source tree (`src/x/y.py` → `tests/x/test_y.py`).  
- **Naming**: descriptive (`test_creates_new_source_when_valid_input`).  
- **Coverage**: ≥85% of changed lines, 100% for core logic.  
- **Fixtures**: deterministic; use `monkeypatch` or fakes for external APIs.  
- **Isolation**: no live network calls; wrap services behind adapters with stub responses.  
- **Data**: use factories (`factories/article_factory.py`) not random values.  
- **Speed**: <5 s per module; mark slow tests with `@pytest.mark.slow`.  
- **Regression**: every bug fix adds a reproducing test.  
- **Banned in tests**: `unittest`, `MagicMock`, `time.sleep`, real I/O.  

---

## 💾 Configuration & Secrets

- `.env` for local dev only; production uses Secret Manager or environment vars.  
- Always provide `.env.example` with placeholders.  
- Never commit secrets; enforce via `.gitignore` and scanners (`gitleaks`, `detect-secrets`).  
- Use `pydantic.BaseSettings` for config loading and overrides.  
- Config precedence: defaults < `.env` < env vars < CLI args.  
- Mask sensitive values in logs.  
- Cache deterministically and per resource; avoid storing unnecessary data.

---

## 🔒 Security & Compliance

- HTTPS only; validate certificates.  
- Restrict outbound network calls to known hosts.  
- Validate **all** untrusted inputs (including LLM outputs).  
- No arbitrary `eval`, shell execution, or dynamic code.  
- Review LLM prompts/outputs for data leakage or injection risks.  
- Keep dependencies current (`uv pip compile`, Dependabot, or Renovate).  
- All timestamps and stored datetimes must be UTC-aware.

---

## 🧑‍💻 Commits & Pull Requests

### 🧩 General Principles
- Every change must be **traceable to a Jira ticket** — include the ticket ID in both the **branch name** and **PR title**.  
  - Example: `TICKET-8888_add_new_feature`
- Commits should be **small and self-contained** — one logical change per commit.  
- AI-generated changes must strictly follow these conventions for auditability.  
- Human developers may use more natural commit language as long as the ticket reference is clear.

---

### 🧠 Commits
- **Format:**  
  - AI commits should follow [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `refactor:`, `test:`, `chore:`).  
  - Human commits *may* use this pattern but it’s not mandatory.  
- Include the Jira ticket ID at the start if not already in the branch name:  
  - Example: `TICKET-9084: fix broken prompt save logic`
- Messages must be concise and imperative (describe what the change *does*).

---

### 🌿 Branch Names
- The **only enforced rule** is that branch names must start with the **Jira ticket number** and be concise but descriptive.  
- No `feature/`, `bugfix/`, or other namespace prefixes.  
- Examples:  
  - ✅ `TICKET-10580_save_prompts_and_responses`  
  - ✅ `TICKET-10602_fix_slack_digest_filter`  
  - 🚫 `feature/TICKET-10580_save_prompts`  
- Use underscores `_` for readability; avoid spaces or hyphens.

---

### 🧾 Pull Requests
- **Title:** must include the Jira ticket ID, matching the branch name.  
- **Description:** use the following structure:
  ```markdown
  ## Why
  - Problem and goal.

  ## What
  - Summary of key changes.

  ## How
  - Implementation notes, trade-offs, risks.

  ## Test plan
  - Steps or commands to verify.
  ```
- Include screenshots or JSON examples when relevant.  
- PRs generated or authored by AI tools must include a comment like:  
  `<!-- generated-by: Claude Code (model xyz) -->`
- Human reviewers must review all AI-generated PRs before merge.  
- Update changelog or release notes for any user-visible change.

---

## ⚙️ Tooling & Environment

- **Preferred core tools**:  
  - `uv` for dependency and venv management  
  - `ruff` for lint + format  
  - `mypy` for type checks  
  - `pytest` for tests  
  - `structlog` for logging  
  - `FastAPI` for APIs  
  - `Pydantic` for schemas and config  
- `pyproject.toml` must define configs for these tools.  
- Include a `Makefile`, `taskfile.yml`, or `justfile` with tasks: `lint`, `test`, `run`, `format`, `build`.  
- Provide `README.md` or `CONTRIBUTING.md` explaining:  
  - Environment setup  
  - Running tests  
  - Linting/formatting  
  - Building/running Docker containers  
- Projects must run identically in venv and containerised environments.  
- Prefer lightweight, minimal base images (e.g. `python:3.11-slim`).  
- Keep dependencies minimal and explicit; prefer small, composable libraries.  
- Define `__all__` in public modules to clarify exports.  
- Require human PR review for all AI-generated or bulk edits.

---

## 🧰 Pre-commit Hooks

All repos should include this minimal `.pre-commit-config.yaml` to enforce consistent formatting:

```yaml
repos:
  - repo: https://gitlab.com/vojko.pribudic.foss/pre-commit-update
    rev: v0.8.0
    hooks:
      - id: pre-commit-update
        args: [--dry-run]

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.13.3
    hooks:
      - id: ruff
        args: [ --fix ]
      - id: ruff-format
```

Run `pre-commit install` after cloning to enable automatic checks.

---

## 🔚 Recommended Add-Ons

- **CI checks**: `ruff check`, `ruff format --check`, `pytest --maxfail=1 --disable-warnings -q`, `mypy`.  
- **Observability**: use `structlog` and propagate `correlation_id` between services.  
- **Time & locale**: always UTC, ISO-8601 timestamps.  
- **Reproducibility**: use `uv lock` or `requirements.lock` for builds.

<!-- ai-context:
type: standards
language: python
purpose: Define canonical conventions for new or refactored Python code.
legacy_policy: Do not refactor or migrate existing projects unless explicitly instructed.
canonical_source: https://github.com/jmackown/dev-standards/tree/main/python/project-standards.md
-->
