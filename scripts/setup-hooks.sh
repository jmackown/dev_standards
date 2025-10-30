#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Setting up git hooks for automatic semantic versioning..."

# Check if we're in a git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Install pre-push hook
HOOKS_DIR=".git/hooks"
SOURCE_HOOK=".githooks/pre-push"
TARGET_HOOK="$HOOKS_DIR/pre-push"

if [[ ! -f "$SOURCE_HOOK" ]]; then
    echo "❌ Error: Source hook not found at $SOURCE_HOOK"
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

# Copy and make executable
cp "$SOURCE_HOOK" "$TARGET_HOOK"
chmod +x "$TARGET_HOOK"

echo "✅ Pre-push hook installed successfully"
echo ""
echo "🏷️  How it works:"
echo "- When you push to 'main', the hook analyzes your commits"
echo "- Uses conventional commit messages to determine version bump:"
echo "  • feat: → minor version (1.1.0 → 1.2.0)"
echo "  • fix: → patch version (1.1.0 → 1.1.1)" 
echo "  • BREAKING CHANGE: → major version (1.1.0 → 2.0.0)"
echo "- Automatically creates git tags and updates VERSION file"
echo ""
echo "📝 Use conventional commits like:"
echo "  git commit -m 'feat: add auto-detection for project types'"
echo "  git commit -m 'fix: resolve README insertion issue'"
echo "  git commit -m 'feat!: change sync script API (BREAKING CHANGE)'"
echo ""
echo "🚀 Ready! Your next push to main will trigger automatic versioning."