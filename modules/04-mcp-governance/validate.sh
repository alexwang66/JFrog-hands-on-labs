#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
test -f "$MODULE_DIR/README.md"
test -f "$MODULE_DIR/CUSTOMER-GUIDE.md"
test -f "$MODULE_DIR/LIVE-VALIDATION.md"
test -f "$MODULE_DIR/module.env.example"
test -x "$MODULE_DIR/run-customer-demo.sh"
grep -qx 'JFROG_SERVER_ID=workshop' "$MODULE_DIR/module.env.example"
grep -qx 'JF_PROJECT=workshop' "$MODULE_DIR/module.env.example"
grep -qx 'JFROG_NPM_LOCAL_REPO=' "$MODULE_DIR/module.env.example"
grep -q '本機直接掛載僅可做離線 Smoke Test' "$MODULE_DIR/CUSTOMER-GUIDE.md"
grep -q 'Catalog 為空即停止' "$MODULE_DIR/LIVE-VALIDATION.md"
bash -n "$MODULE_DIR/run-customer-demo.sh"
node -e 'JSON.parse(require("node:fs").readFileSync(process.argv[1], "utf8"))' \
  "$MODULE_DIR/mcp-server/package.json"
node "$MODULE_DIR/mcp-server/smoke-test.mjs"
echo "Module 04 validation: PASS"
