#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
test -f "$MODULE_DIR/README.md"
test "$(wc -l < "$MODULE_DIR/README.md" | tr -d ' ')" -eq 5
grep -Fxq '# Module 1' "$MODULE_DIR/README.md"
grep -Fxq '請幫我完成 Module 1' "$MODULE_DIR/README.md"
test -f "$MODULE_DIR/module.env.example"
test -f "$MODULE_DIR/LIVE-VALIDATION.md"
test -f "$MODULE_DIR/run-live-demo.sh"
grep -q '^JFROG_NPM_VIRTUAL_REPO=' "$MODULE_DIR/module.env.example"
grep -q '^WORKSHOP_BLOCKED_PACKAGE=' "$MODULE_DIR/module.env.example"
bash -n "$MODULE_DIR/run-live-demo.sh"
grep -Fq '${TMPDIR:-/tmp}/axios-curation-demo.XXXXXX' \
  "$MODULE_DIR/run-live-demo.sh"
grep -q '^JFROG_SERVER_ID=workshop$' "$MODULE_DIR/module.env.example"
grep -q '^JFROG_URL=https://alexwangtrial.jfrog.io$' "$MODULE_DIR/module.env.example"
grep -q '^JF_PROJECT=workshop$' "$MODULE_DIR/module.env.example"
grep -q '^JFROG_NPM_VIRTUAL_REPO=workshop-npm$' "$MODULE_DIR/module.env.example"
grep -q '^JFROG_NPM_REMOTE_REPO=workshop-npm-remote$' "$MODULE_DIR/module.env.example"
grep -q '^WORKSHOP_SAFE_PACKAGE=axios@1.20.0$' "$MODULE_DIR/module.env.example"
grep -q '^WORKSHOP_BLOCKED_PACKAGE=axios@1.14.1$' "$MODULE_DIR/module.env.example"
echo "Module 01 validation: PASS"
