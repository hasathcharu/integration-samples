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

RESPONSE=$(curl -s -w "\n%{http_code}" -H "User-Agent: GitHub-Actions-Purge" "${PURGE_URL}")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

echo "Response (HTTP ${HTTP_CODE}): ${BODY}"

if [ "$HTTP_CODE" -ne 200 ]; then
  echo "Failed to purge cache"
  exit 1
fi
