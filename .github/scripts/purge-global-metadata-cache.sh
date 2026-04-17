#!/bin/bash
set -euo pipefail

# Purge the jsDelivr cache for any changed files in the .metadata directory
#
# Required environment variables:
#   CHANGED_FILES - Newline-separated list of changed file paths (from get-changed-files.sh)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

METADATA_FILES=$(echo "$CHANGED_FILES" | grep '^\.metadata/' || true)

if [ -z "$METADATA_FILES" ]; then
  echo "No changes in .metadata directory, skipping cache purge"
  exit 0
fi

echo "Changed metadata files:"
echo "$METADATA_FILES"

echo "$METADATA_FILES" | while IFS= read -r file; do
  [ -z "$file" ] && continue
  bash "$SCRIPT_DIR/purge-jsdelivr-cache.sh" "$file"
done
