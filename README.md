# 📘 Developer & AI Standards

This repository defines the shared **developer standards and AI usage policies** for all projects across the organisation.  
It ensures humans and AI assistants follow consistent, safe, and high-quality engineering practices.

For more words: read this [blog post here](https://jcmc.dev/posts/2025/10/dev_standards/).

---

## 🧩 Repository Structure

| Path | Purpose |
|------|----------|
| `common/ai-behaviour-policy.md` | Defines what AI tools may and may not do (actions, commands, commits). |
| `common/ai-guidelines.md` | Practical rules for how AI should assist human developers responsibly. |
| `python/project-standards.md` | Language-specific coding and architecture standards for Python projects. |
| `scripts/sync_standards.sh` | Script to pull the latest standards into a project (preferred update method). |
| `.ai-context` (in consuming repos) | Machine-readable manifest telling AI tools which standards to load. |
| `AI_NOTICE.txt` (in consuming repos) | Fallback notice for tools that don’t parse `.ai-context`. |

---

## 🚀 Getting Started — Add to an Existing Project

1. **Fetch the standards**
   Clone and run the sync script to pull the latest standards into your project:
   ```bash
   git clone https://github.com/jmackown/dev-standards.git /tmp/dev-standards
   bash /tmp/dev-standards/scripts/sync_standards.sh
   rm -rf /tmp/dev-standards
   ```
   This creates or updates the `dev-standards/` folder in your project, plus sets up `.ai-context` and `ai_guidelines.yaml`.  
   > We do **not** use Git submodules or automation — the sync script is a simple pull-only update.

2. **Configure your project profile**
   Edit `ai_guidelines.yaml` (created automatically by the sync script):

   ```yaml
   profile: python  # Change to match your project type
   source_repo: https://github.com/jmackown/dev-standards.git
   source_branch: main
   ```

---

## 🔄 Keeping Up to Date

To pull the latest version of the standards at any time:
```bash
git clone https://github.com/jmackown/dev-standards.git /tmp/dev-standards
bash /tmp/dev-standards/scripts/sync_standards.sh
rm -rf /tmp/dev-standards
```

This will:
- Download the latest version of `dev-standards` from the canonical repository  
- Replace your local copy  
- Preserve your `.ai-context` and `AI_NOTICE.txt` files  
- Show you a diff so you can review before committing

> The script does not auto-merge changes — updates are explicit and reviewed locally.

---

## 🧱 How This Works with AI Tools

When AI-assisted IDEs (e.g. Claude Code, Windsurf, Cursor) start in your repo:
1. They detect `.ai-context`.
2. They load and read the listed Markdown files.
3. The instructions inside guide their behaviour and ensure compliance.

Tools that ignore `.ai-context` will still see `AI_NOTICE.txt` or the note in your `README.md`.

---

## 🧑‍💻 Contributing to Standards

1. **Setup automatic versioning** (first time only)
   ```bash
   ./scripts/setup-hooks.sh
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b standards/update-ai-policy
   ```

3. **Edit or add documentation**
   - Follow the existing frontmatter structure (`profile`, `scope`, `version`, etc.).
   - Keep tone factual and directive — no marketing language.

4. **Use conventional commits**
   ```bash
   git commit -m "feat: add TypeScript project standards"
   git commit -m "fix: resolve sync script README insertion issue"  
   git commit -m "feat!: change AI context file format (BREAKING CHANGE)"
   ```

5. **Run validation**
   - Ensure Markdown formatting and YAML frontmatter are valid.
   - Check all cross-references are correct.

6. **Open a PR**
   - Use a descriptive title (e.g. `PLAN-10580_update_ai_usage_guidelines`).
   - Include rationale and examples in the PR description.

7. **Review and merge**
   - At least one peer reviewer and one standards maintainer must approve.
   - All AI-generated changes must include attribution in the commit message.
   - When merged to `main`, automatic versioning will create appropriate tags.

---

## 🧭 Governance & Versioning

### Automatic Semantic Versioning

This repository uses git hooks for automatic semantic versioning:

- **Setup**: Run `./scripts/setup-hooks.sh` once to enable automatic versioning
- **Versioning**: Uses [conventional commits](https://www.conventionalcommits.org/) to determine version bumps:
  - `feat: description` → minor version (1.1.0 → 1.2.0)
  - `fix: description` → patch version (1.1.0 → 1.1.1)  
  - `feat!: description` or `BREAKING CHANGE:` → major version (1.1.0 → 2.0.0)
- **Process**: When pushing to `main`, the pre-push hook automatically:
  - Analyzes commit messages since the last tag
  - Calculates the new version number
  - Updates the `VERSION` file and templates
  - Creates a git tag (e.g., `v1.2.3`)
  - Commits the version changes

### Governance

- **Source of truth:** The `main` branch of this repository  
- **Change cadence:** Reviewed quarterly or as needed by Engineering/AI working group  
- **Compliance:** Projects are expected to align on next update cycle; legacy repos remain exempt until refactor
- **Version tracking:** Consumer projects track which standards version they're using via `dev-standards/ai_guidelines.yaml`

---

## 🔗 Related Resources

- Internal AI guidance: `common/ai-guidelines.md`  
- Behaviour policy (runtime): `common/ai-behaviour-policy.md`  
- Python engineering standards: `python/project-standards.md`

---

## 🧠 Summary

| Layer | Controls | Enforced by |
|--------|-----------|-------------|
| **AI Behaviour Policy** | What the AI may do | AI IDEs / context |
| **AI Guidelines** | How the AI should assist | AI tools + developers |
| **Language Standards** | What good code looks like | Humans + AI |
| **.ai-context** | How everything connects | AI tools automatically |
