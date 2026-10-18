#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCHIVE="$MODULE_DIR/fixtures/env-demo-malicious/1.0.0/env-demo-malicious-1.0.0.zip"

test -f "$MODULE_DIR/README.md"
test -f "$MODULE_DIR/CUSTOMER-GUIDE.md"
test -f "$MODULE_DIR/LIVE-VALIDATION.md"
test -f "$MODULE_DIR/module.env.example"
test -x "$MODULE_DIR/run-customer-demo.sh"
test -f "$MODULE_DIR/fixtures/env-demo-malicious/SKILL.md"
test -f "$MODULE_DIR/approved/secure-release-review/SKILL.md"
test -s "$ARCHIVE"

for document in "$MODULE_DIR/README.md" "$MODULE_DIR/CUSTOMER-GUIDE.md"; do
  for step in 1 2 3 4; do
    grep -Fq "## 提示詞 $step" "$document"
  done
  grep -Fq '請幫我完成 Module 3' "$document"
  if grep -Eq '^```(bash|sh|shell)$|bash scripts/' "$document"; then
    echo "Module 3 customer documents must contain prompts only." >&2
    exit 1
  fi
done

grep -qx 'JFROG_SERVER_ID=workshop' "$MODULE_DIR/module.env.example"
grep -qx 'JF_PROJECT=workshop' "$MODULE_DIR/module.env.example"
grep -qx 'JFROG_SKILLS_REPO=' "$MODULE_DIR/module.env.example"
grep -q '不得安裝、解壓、載入或執行' "$MODULE_DIR/CUSTOMER-GUIDE.md"
grep -q '沒有核准項目即停止' "$MODULE_DIR/LIVE-VALIDATION.md"
bash -n "$MODULE_DIR/run-customer-demo.sh"

actual_sha="$(shasum -a 256 "$ARCHIVE" | awk '{print $1}')"
expected_sha="8a909f1d232a9748936904ed903d64410ae8557811fd2cb92dba00789742b417"
test "$actual_sha" = "$expected_sha"

entries="$(unzip -Z1 "$ARCHIVE")"
test "$entries" = "SKILL.md"

for skill in \
  "$MODULE_DIR/fixtures/env-demo-malicious/SKILL.md" \
  "$MODULE_DIR/approved/secure-release-review/SKILL.md"; do
  head -n 1 "$skill" | grep -qx -- '---'
  grep -q '^name: [a-z0-9-][a-z0-9-]*$' "$skill"
  grep -q '^description: .\+' "$skill"
done

echo "Module 03 validation: PASS (fixture inspected, never executed)"
