---
profile: common
version: 1.0
scope: ai-guidelines
source_repo: https://github.com/jmackown/dev-standards
last_updated: 2025-10-17
description: >
  Defines practical guidance and expectations for using AI tools in software development.
  Applies to all developers and AI-assisted environments (IDE, CLI, agent, or automation).
---

# 🤖 AI Usage Guidelines

These guidelines define *how* we use AI responsibly and effectively across engineering teams.
They apply to all contexts where AI assists with design, coding, documentation, or decision-making.

---

## 🎯 Purpose

AI tools are collaborators, not replacements.  
They exist to speed up exploration, reduce boilerplate, and improve consistency — not to make
unreviewed or untraceable decisions.

Use AI to:
- Generate first drafts or scaffolding.
- Explore solutions or alternatives quickly.
- Summarise or refactor code *on request*.
- Identify potential bugs or missing tests.
- Generate or improve documentation.

Do **not** use AI to:
- Autonomously commit or merge code.
- Change project dependencies or configs.
- Override local or team conventions without review.
- Replace code reviews or testing.

---

## 🔍 Review & Accountability

- All AI-generated work must be **reviewed by a human** before merge or release.
- AI tools must **cite themselves** in commits or PRs:
  - Example: `<!-- generated-by: Claude Code (model xyz) -->`
- Developers are accountable for any AI-authored changes they commit.

---

## 🧱 Collaboration Principles

- Treat AI as a **junior engineer** — helpful, fast, but prone to mistakes.
- Always read the diff. Never assume correctness.
- Use precise prompts; vague requests cause large, costly edits.
- Prefer narrow, surgical edits over sweeping refactors.
- Avoid “fix everything” instructions; focus on the current problem.

---

## 🧩 Working with Standards

- AI tools must **load and respect**:
  - `ai-behaviour-policy.md` — for allowed actions.
  - `project-standards.md` — for style and structure.
- When multiple rules conflict, **human judgement wins**.
- Standards evolve — sync regularly from `dev-standards`.

---

## ⚖️ Ethical Use

- Be transparent about AI assistance in all deliverables.
- Do not pass off AI output as independent human work in formal deliverables or papers.
- Never use AI to generate or modify content that violates IP, licensing, or company policy.

---

## 💬 Feedback and Improvement

- If AI tools make consistent errors, log an issue or open a PR to update standards.
- When an AI suggestion is genuinely better than the current rule, propose a standards change.
- Use AI feedback loops to refine documentation and examples.

---

<!-- ai-context:
type: ai-guidelines
scope: organisation-wide
purpose: Define how AI tools should be used responsibly in software development.
canonical_source: https://github.com/jmackown/dev-standards/tree/main/common/ai-guidelines.md
-->
