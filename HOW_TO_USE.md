# 📘 How to Use Dev Standards in Your Project

This guide explains how to integrate and maintain the organizational AI development standards in your project.

## 🚀 Quick Start

### First-Time Setup

Choose one of these methods to set up the standards:

#### Option 1: Clone and run (works with private repos)
```bash
git clone https://github.com/jmackown/dev-standards.git /tmp/dev-standards
bash /tmp/dev-standards/scripts/sync_standards.sh
rm -rf /tmp/dev-standards
```

#### Option 2: Direct curl (only for public repos)
```bash
curl -sSL https://raw.githubusercontent.com/jmackown/dev-standards/main/scripts/sync_standards.sh | bash
```

This will:
1. Create a `dev-standards/` folder with the organizational standards
2. **Auto-detect your project type** (Python, TypeScript, or JavaScript)
3. Create `dev-standards/ai_guidelines.yaml` with the detected profile
4. Create `.ai-context` file for AI tools to read  
5. Add an AI usage notice to your README.md

### Auto-Detection

The sync script automatically detects your project type by looking for:

- **TypeScript**: `tsconfig.json` or `.ts`/`.tsx` files
- **JavaScript**: `package.json` or `.js`/`.jsx` files  
- **Python**: `pyproject.toml`, `setup.py`, `requirements.txt`, or `.py` files

If you need to change the detected profile, edit `dev-standards/ai_guidelines.yaml`:

```yaml
profile: typescript  # Change to: python, javascript, typescript
source_repo: https://github.com/jmackown/dev-standards.git
source_branch: main
last_synced_commit: abc123def
```

## 🔄 Keeping Standards Updated

To update to the latest standards at any time, run the sync script again:

```bash
git clone https://github.com/jmackown/dev-standards.git /tmp/dev-standards
bash /tmp/dev-standards/scripts/sync_standards.sh
rm -rf /tmp/dev-standards

```

This will:
- Pull the latest standards from the central repository
- Only sync files relevant to your configured profile
- Preserve your local `ai_guidelines.yaml` and `.ai-context` files
- Show a diff so you can review changes before committing

## 📁 What Gets Added to Your Project

```
your-project/
├── .ai-context                  # Instructions for AI tools
├── dev-standards/
│   ├── ai_guidelines.yaml       # Your project's AI configuration  
│   ├── common/                  # Organization-wide AI policies
│   │   ├── ai-behaviour-policy.md
│   │   └── ai-guidelines.md
│   ├── python/                  # Language-specific standards (based on profile)
│   │   └── project-standards.md
│   └── HOW_TO_USE.md           # This file
└── README.md                    # (Updated with AI usage notice)
```

## 🤖 How AI Tools Use These Standards

When AI-assisted IDEs (Claude Code, Windsurf, Cursor, etc.) start in your repo:
1. They read `.ai-context` to find the standards files
2. They load the policies from `dev-standards/`
3. They follow the rules defined in those documents

This ensures consistent, safe AI assistance across all projects.

## 💾 Should I Commit the Standards?

**Yes, commit everything to your repository:**

### Why Commit These Files?

1. **Team Consistency** - All team members get the same AI behavior and standards
2. **CI/CD Integration** - Build pipelines can reference the standards
3. **Version Control** - Track when standards were updated in your project history
4. **Offline Access** - Standards are available even without internet access
5. **Onboarding** - New developers immediately have the correct AI setup

### What About Updates?

When you run the sync script to update:
- Review the changes with `git diff`
- Commit the updates with a clear message like "Update to latest dev standards v1.x"
- This creates an audit trail of when standards were updated

## ⚙️ Customization

### Changing Your Profile

1. Edit `dev-standards/ai_guidelines.yaml`
2. Change the `profile:` line to your language/framework
3. Run the sync script again to pull the new profile's standards

### Available Profiles

- `python` - Python projects with FastAPI, Pydantic, pytest standards
- `javascript` - JavaScript projects (standards coming soon)
- `typescript` - TypeScript projects (standards coming soon)

## 🛠️ Troubleshooting

### Standards not syncing?
- Check that `dev-standards/ai_guidelines.yaml` exists and has a valid profile
- Ensure you have internet access to GitHub
- Verify the repository URL in `dev-standards/ai_guidelines.yaml` is correct

### AI tools not following standards?
- Ensure `.ai-context` exists in your project root
- Check that AI tools have access to read the `dev-standards/` directory
- Some older AI tools may need the notice in your README.md

### Need to reset?
Remove these files/folders and run the setup again:
```bash
rm -rf dev-standards/ .ai-context
# Then run the setup script using one of the methods above
```

## 📚 Further Reading

- See `dev-standards/common/ai-behaviour-policy.md` for what AI tools can and cannot do
- See `dev-standards/common/ai-guidelines.md` for best practices
- See language-specific standards in `dev-standards/<profile>/`

## 🆘 Support

If you encounter issues or have questions:
1. Check this guide first
2. Review the standards documents in `dev-standards/`
3. Contact the engineering team or open an issue in the dev-standards repo