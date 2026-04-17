#!/bin/bash
set -euo pipefail

# Purge the jsDelivr cache for a single file in this repository
#
# Usage: bash purge-jsdelivr-cache.sh <file_path>
#
# Required environment variables:
#   GITHUB_REPOSITORY - Repository in "owner/repo" format (e.g. hasathcharu/integration-samples)
#
# Optional environment variables:
#   GITHUB_REF_NAME - Branch or tag name (defaults to "main")

FILE_PATH="${1:?Usage: purge-jsdelivr-cache.sh <file_path>}"
BRANCH="${GITHUB_REF_NAME:-main}"

PURGE_URL="https://purge.jsdelivr.net/gh/${GITHUB_REPOSITORY}@${BRANCH}/${FILE_PATH}"

echo "Purging jsDelivr cache for: ${FILE_PATH}"
echo "URL: ${PURGE_URL}"

RESPONSE=$(curl -s -w "\n%{http_code}" "${PURGE_URL}")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 200 ]; then
  echo "Cache purged successfully"
else
  echo "Failed to purge cache (HTTP ${HTTP_CODE})"
  echo "$BODY"
  exit 1
fi
