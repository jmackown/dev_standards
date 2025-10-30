---
profile: common
version: 1.0
scope: ai-behaviour-policy
source_repo: https://github.com/jmackown/dev-standards
last_updated: 2025-10-17
description: >
  Defines required, discouraged, and banned behaviours for AI-assisted
  development tools (e.g. Claude Code, Cursor, Windsurf, Gemini CLI).
---

# 🤖 AI Behaviour Policy

These rules apply to all AI-assisted development tools used within our organisation.  
They define what automated agents and IDE integrations *may* or *must not* do when interacting with repositories.

---

## ✅ Required Behaviours

AI tools **must**:
- Respect local configuration (`pyproject.toml`, `.pre-commit-config.yaml`, `.env`, etc.).  
- Use the **existing pre-commit hooks** for linting and formatting — do not run `ruff`, `mypy`, or similar globally.  
- Make **incremental, minimal edits** — modify only the code or files directly relevant to the user’s request.  
- Always confirm before running destructive or environment-altering commands.  
- Ask for explicit confirmation before committing, pushing, or merging changes.  
- Include an AI attribution comment in generated commits or PRs, e.g.:  
  `<!-- generated-by: Claude Code (model xyz) -->`

---

## ⚠️ Discouraged Behaviours

AI tools should **avoid**:
- Reformatting entire repositories or sweeping style rewrites.  
- Running `ruff`, `mypy`, or any linter recursively unless explicitly asked.  
- Regenerating dependency locks (`uv lock`, `poetry lock`) automatically.  
- Making speculative “improvements” without a related Jira ticket.  
- Refactoring legacy code purely to conform to new standards.  
- Making multiple unrelated edits in a single PR.

---

## 🚫 Banned Behaviours

AI tools **must not**:
- Execute arbitrary shell commands (`apt`, `brew`, `docker`, etc.) without explicit approval.  
- Install or remove dependencies automatically.  
- Delete or rename files unless clearly requested.  
- Modify `.gitignore`, `.env`, or build configurations.  
- Make network calls to external APIs or upload internal code to unapproved endpoints.  
- Run full-project formatters or linters autonomously (e.g. `ruff format --fix .`).  
- Push commits or merge branches without human review.  

---

## 🧩 AI Context and Token Use

- Keep operations **scoped** — focus on relevant files, not whole trees.  
- Avoid large-context refactors or “re-lint everything” operations; rely on pre-commit for that.  
- Use minimal context for code completions, diffs, and targeted edits.  
- Prefer analysis and reasoning over automated reformatting.  

---

## 🔍 Audit and Traceability

- All AI-generated commits and PRs must include:
  - A comment identifying the model and tool version.  
  - A clear reference to the initiating Jira ticket.  
- A human reviewer must approve all AI-generated changes before merge.  

---

## 🧭 Scope and Enforcement

This policy applies to:
- All repositories containing a `.guidelines.yaml` file or using any AI tooling integration.  
- All AI tools connected to organisational credentials (including IDE integrations, CLI tools, and MCP agents).

While this file is **not executable**, AI agents, IDEs, and orchestration layers (e.g. your MCP or GraphQL gateways) should parse and enforce it programmatically where possible.

---

<!-- ai-context:
type: ai-policy
scope: organisation-wide
purpose: Define required, discouraged, and banned behaviours for AI-assisted development.
canonical_source: https://github.com/jmackown/dev-standards/tree/main/common/ai-behaviour-policy.md
-->
