#!/bin/bash
set -euo pipefail

# Purge the jsDelivr cache for changed .choreo files in a project
#
# Required environment variables:
#   CHANGED_FILES     - Newline-separated list of changed file paths (from get-changed-files.sh)
#   PROJECT_PATH      - Path to the project directory (e.g. ballerina-integrator/my-project)
#   GITHUB_REPOSITORY - Repository in "owner/repo" format

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

METADATA_FILES=("instructions.md" "diagram.md" "config-schema.json")

MATCHED_FILES=""
for file in "${METADATA_FILES[@]}"; do
  TARGET="${PROJECT_PATH}/.choreo/${file}"
  if echo "$CHANGED_FILES" | grep -qx "$TARGET"; then
    MATCHED_FILES="${MATCHED_FILES}${TARGET}"$'\n'
  fi
done

MATCHED_FILES=$(echo "$MATCHED_FILES" | sed '/^$/d')

if [ -z "$MATCHED_FILES" ]; then
  echo "No metadata file changes in ${PROJECT_PATH}, skipping cache purge"
  exit 0
fi

echo "Changed metadata files in ${PROJECT_PATH}:"
echo "$MATCHED_FILES"

echo "$MATCHED_FILES" | while IFS= read -r file; do
  [ -z "$file" ] && continue
  bash "$SCRIPT_DIR/purge-jsdelivr-cache.sh" "$file"
done
