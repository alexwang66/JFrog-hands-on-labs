#!/usr/bin/env bash
set -euo pipefail

EXPECTED_REGISTRY="https://alexwangtrial.jfrog.io/artifactory/api/npm/workshop-npm/"
BLOCKED_VERSION="1.14.1"
EXPECTED_SAFE_VERSION="1.20.0"

for command in npm node jq; do
  command -v "$command" >/dev/null || {
    echo "Missing required command: $command" >&2
    exit 1
  }
done

actual_registry="$(npm config get registry)"
if [[ "$actual_registry" != "$EXPECTED_REGISTRY" ]]; then
  echo "Unexpected npm registry: $actual_registry" >&2
  echo "Run: jf setup npm --server-id workshop --repo workshop-npm --project workshop" >&2
  exit 1
fi

test_dir="$(mktemp -d "${TMPDIR:-/tmp}/axios-curation-demo.XXXXXX")"
trap 'rm -rf "$test_dir"' EXIT
cd "$test_dir"
npm init -y >/dev/null

versions_file="$test_dir/curated-versions.json"
npm view axios versions --json > "$versions_file"

if jq -e --arg version "$BLOCKED_VERSION" 'index($version) != null' "$versions_file" >/dev/null; then
  echo "Safety stop: axios@$BLOCKED_VERSION is currently visible in the curated registry." >&2
  echo "Revalidate JFrog Catalog/Curation before running the installation test." >&2
  exit 1
fi

recommended="$(npm view axios version --json | jq -r '.')"
echo "Curation-filtered highest visible version: axios@$recommended"

set +e
npm install "axios@$BLOCKED_VERSION" \
  --ignore-scripts --package-lock=false --no-audit --no-fund \
  > blocked.stdout 2> blocked.stderr
blocked_rc=$?
set -e

if [[ "$blocked_rc" -eq 0 ]]; then
  echo "Safety failure: blocked version unexpectedly installed." >&2
  exit 1
fi
if ! grep -Eq 'ETARGET|No matching version|403|blocked' blocked.stderr; then
  echo "Installation failed for an unexpected reason:" >&2
  sed -n '1,80p' blocked.stderr >&2
  exit 1
fi
echo "Blocked as expected: axios@$BLOCKED_VERSION"
sed -n '1,5p' blocked.stderr

if [[ "$recommended" != "$EXPECTED_SAFE_VERSION" ]]; then
  echo "Safety stop: expected axios@$EXPECTED_SAFE_VERSION but registry recommends axios@$recommended." >&2
  echo "Review current Curation evidence before installing." >&2
  exit 1
fi

npm install "axios@$recommended" \
  --ignore-scripts --package-lock=false --no-audit --no-fund

installed="$(node -p 'require("./node_modules/axios/package.json").version')"
test "$installed" = "$recommended"
echo "Installed compliant version: axios@$installed"
