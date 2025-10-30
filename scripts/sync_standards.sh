#!/usr/bin/env bash
set -euo pipefail

CANONICAL_REPO="https://github.com/jmackown/dev-standards"
TARGET_DIR="dev-standards"
TMP_DIR="$(mktemp -d)"

echo "🔄 Syncing development standards from ${CANONICAL_REPO}..."

# Clone the canonical repo into a temp directory
git clone --depth 1 "${CANONICAL_REPO}" "${TMP_DIR}" >/dev/null 2>&1

# Get the version from the repo being synced
STANDARDS_VERSION=""
if [[ -f "${TMP_DIR}/VERSION" ]]; then
    STANDARDS_VERSION=$(cat "${TMP_DIR}/VERSION")
    echo "📦 Standards version: v${STANDARDS_VERSION}"
fi

# Get the latest commit hash from the cloned repo
LATEST_COMMIT=$(cd "${TMP_DIR}" && git rev-parse HEAD)

# Auto-detect project type for first run
detect_project_type() {
    # Check for TypeScript first (more specific than JavaScript)
    if [[ -f "tsconfig.json" ]] || [[ -f "package.json" && $(find . -name "*.ts" -o -name "*.tsx" | head -1) ]]; then
        echo "typescript"
        return
    fi
    
    # Check for JavaScript
    if [[ -f "package.json" ]] || [[ $(find . -maxdepth 2 -name "*.js" -o -name "*.jsx" | head -1) ]]; then
        echo "javascript"
        return
    fi
    
    # Check for Python
    if [[ -f "pyproject.toml" ]] || [[ -f "setup.py" ]] || [[ -f "requirements.txt" ]] || [[ $(find . -maxdepth 2 -name "*.py" | head -1) ]]; then
        echo "python"
        return
    fi
    
    # Default fallback
    echo "python"
}

# Check if this is a first run by looking for dev-standards/ai_guidelines.yaml
FIRST_RUN=false
if [[ ! -f "dev-standards/ai_guidelines.yaml" ]]; then
    FIRST_RUN=true
fi

# Read the profile from dev-standards/ai_guidelines.yaml to determine what to sync
PROFILE=""
if [[ -f "dev-standards/ai_guidelines.yaml" ]]; then
    PROFILE=$(grep "^profile:" dev-standards/ai_guidelines.yaml | awk '{print $2}' | tr -d '"' | tr -d "'")
    if [[ -n "$PROFILE" ]]; then
        echo "📦 Using profile: ${PROFILE}"
    fi
else
    # Auto-detect on first run
    PROFILE=$(detect_project_type)
    echo "🔍 Auto-detected project type: ${PROFILE}"
fi

# Build rsync exclude list based on profile
RSYNC_EXCLUDES=(
    "--exclude=.git"
    "--exclude=.gitignore"
    "--exclude=.githooks/"
    "--exclude=VERSION"
    "--exclude=README.md"
    "--exclude=scripts/"
    "--exclude=consumer_files/"
)

# If a profile is set, exclude other language directories
if [[ -n "$PROFILE" ]]; then
    # Get all directories in the repo (to identify language-specific ones)
    for dir in "${TMP_DIR}"/*; do
        if [[ -d "$dir" ]]; then
            dirname=$(basename "$dir")
            # Skip common, scripts, consumer_files, and .git
            if [[ "$dirname" != "common" && "$dirname" != "scripts" && "$dirname" != "consumer_files" && "$dirname" != ".git" ]]; then
                # If this isn't our profile directory, exclude it
                if [[ "$dirname" != "$PROFILE" ]]; then
                    RSYNC_EXCLUDES+=("--exclude=${dirname}/")
                fi
            fi
        fi
    done
fi

# Copy over new files, preserving local overrides if needed
rsync -a --delete "${RSYNC_EXCLUDES[@]}" \
  "${TMP_DIR}/" "${TARGET_DIR}/"

# First-run setup after rsync has completed
if [[ "$FIRST_RUN" == "true" ]]; then
    echo "📝 First run detected - setting up configuration files..."
    
    # Copy the ai_guidelines.yaml template from the temp directory
    # Note: We do this before cleaning up temp dir since consumer_files is excluded from rsync
    if [[ -f "${TMP_DIR}/consumer_files/ai_guidelines.yaml.template" ]]; then
        # Ensure dev-standards directory exists
        mkdir -p dev-standards
        
        # Copy template and update with detected profile
        cp "${TMP_DIR}/consumer_files/ai_guidelines.yaml.template" dev-standards/ai_guidelines.yaml
        sed -i '' "s/^profile:.*$/profile: ${PROFILE}/" dev-standards/ai_guidelines.yaml
        echo "✅ Created dev-standards/ai_guidelines.yaml with profile: ${PROFILE}"
        echo "   You can edit dev-standards/ai_guidelines.yaml to change the profile if needed"
    else
        echo "⚠️  Warning: ai_guidelines.yaml template not found"
    fi
    
    # Copy the .ai-context template from the temp directory
    if [[ -f "${TMP_DIR}/consumer_files/.ai-context" ]]; then
        cp "${TMP_DIR}/consumer_files/.ai-context" .ai-context
        echo "✅ Created .ai-context file in project root"
    else
        echo "⚠️  Warning: .ai-context template not found"
    fi
    
    # Find and update README file
    README_FILE=""
    for readme in README.md README.MD Readme.md readme.md; do
        if [[ -f "$readme" ]]; then
            README_FILE="$readme"
            break
        fi
    done
    
    if [[ -n "$README_FILE" ]]; then
        # Check if AI notice is already present (to avoid duplicates)
        if ! grep -q "<!-- ai-standards-notice -->" "$README_FILE"; then
            echo "📝 Adding AI usage notice to $README_FILE..."
            
            # Get the AI notice content from the temp directory
            AI_NOTICE_FILE="${TMP_DIR}/consumer_files/ai_readme_notice.md"
            if [[ -f "$AI_NOTICE_FILE" ]]; then
                # Extract just the content (skip the front matter - first 2 lines)
                NOTICE_CONTENT=$(tail -n +3 "$AI_NOTICE_FILE")
                
                # Create a marker to prevent duplicate insertions
                MARKER="<!-- ai-standards-notice -->"
                
                # Create a temp file with the notice content
                TEMP_NOTICE=$(mktemp)
                echo "$MARKER" > "$TEMP_NOTICE"
                echo "$NOTICE_CONTENT" >> "$TEMP_NOTICE"
                
                # Process the README file - find first header and insert notice after it
                TEMP_README=$(mktemp)
                INSERTED=false
                while IFS= read -r line; do
                    echo "$line" >> "$TEMP_README"
                    if [[ "$INSERTED" == "false" ]] && [[ "$line" =~ ^#[^#] ]]; then
                        echo "" >> "$TEMP_README"
                        cat "$TEMP_NOTICE" >> "$TEMP_README"
                        INSERTED=true
                    fi
                done < "$README_FILE"
                
                mv "$TEMP_README" "$README_FILE"
                rm "$TEMP_NOTICE"
                echo "✅ Added AI usage notice to $README_FILE"
            else
                echo "⚠️  Warning: AI notice template not found"
            fi
        else
            echo "ℹ️  AI usage notice already present in $README_FILE"
        fi
    else
        echo "ℹ️  No README file found - please add AI usage notice manually"
        echo "    You can find the template in: ${TARGET_DIR}/consumer_files/ai_readme_notice.md"
    fi
fi

# Update the version and last_synced_commit in dev-standards/ai_guidelines.yaml
if [[ -f "dev-standards/ai_guidelines.yaml" ]]; then
    # Update the version line
    if [[ -n "$STANDARDS_VERSION" ]]; then
        if grep -q "^version:" "dev-standards/ai_guidelines.yaml"; then
            sed -i '' "s/^version:.*$/version: ${STANDARDS_VERSION}/" "dev-standards/ai_guidelines.yaml"
        else
            echo "version: ${STANDARDS_VERSION}" >> "dev-standards/ai_guidelines.yaml"
        fi
    fi
    
    # Update the last_synced_commit line
    if grep -q "^last_synced_commit:" "dev-standards/ai_guidelines.yaml"; then
        sed -i '' "s/^last_synced_commit:.*$/last_synced_commit: ${LATEST_COMMIT}/" "dev-standards/ai_guidelines.yaml"
    else
        echo "last_synced_commit: ${LATEST_COMMIT}" >> "dev-standards/ai_guidelines.yaml"
    fi
    echo "📌 Updated dev-standards/ai_guidelines.yaml with version: v${STANDARDS_VERSION} (${LATEST_COMMIT:0:8})"
fi

# Clean up temp directory
rm -rf "${TMP_DIR}"

echo "✅ Standards synced successfully to version v${STANDARDS_VERSION:-unknown}."
echo "Check 'git diff' to review changes before committing."
