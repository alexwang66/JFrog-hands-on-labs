#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "README.md"
  "AGENTS.md"
  ".devcontainer/devcontainer.json"
  ".devcontainer/setup.sh"
  ".github/copilot-instructions.md"
  ".github/prompts/module1.prompt.md"
  ".github/prompts/module2.prompt.md"
  ".github/prompts/module3.prompt.md"
  ".github/prompts/module4.prompt.md"
  "scripts/run-module.sh"
  "templates/policy-matrix.md"
  "docs/00-workshop-overview.md"
  "docs/01-saas-request-checklist.md"
  "docs/02-instructor-runbook.md"
  "docs/03-codespaces-copilot.md"
  "docs/08-end-to-end-demo.md"
  "docs/09-troubleshooting.md"
  "docs/10-cleanup.md"
  "docs/references.md"
  "modules/01-curation-package/README.md"
  "modules/01-curation-package/module.env.example"
  "modules/01-curation-package/LIVE-VALIDATION.md"
  "modules/01-curation-package/run-live-demo.sh"
  "modules/02-model-governance/README.md"
  "modules/02-model-governance/model-client/download_model.py"
  "modules/02-model-governance/model-client/upload_model.py"
  "modules/02-model-governance/run-customer-demo.sh"
  "modules/02-model-governance/assets/Block-model.png"
  "modules/03-skill-governance/README.md"
  "modules/03-skill-governance/fixtures/env-demo-malicious/SKILL.md"
  "modules/03-skill-governance/fixtures/env-demo-malicious/1.0.0/env-demo-malicious-1.0.0.zip"
  "modules/04-mcp-governance/README.md"
  "modules/04-mcp-governance/mcp-server/server.mjs"
)

for path in "${required_files[@]}"; do
  if [[ ! -f "$ROOT_DIR/$path" ]]; then
    echo "Missing required file: $path" >&2
    exit 1
  fi
done

for script in \
  "$ROOT_DIR/.devcontainer/setup.sh" \
  "$ROOT_DIR/scripts/run-module.sh" \
  "$ROOT_DIR/modules/02-model-governance/run-customer-demo.sh"; do
  bash -n "$script"
done

node -e 'JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"))' \
  "$ROOT_DIR/.devcontainer/devcontainer.json"

for module in 1 2 3 4; do
  grep -q "^name: module${module}$" \
    "$ROOT_DIR/.github/prompts/module${module}.prompt.md"
  grep -q "bash scripts/run-module.sh ${module}" \
    "$ROOT_DIR/.github/prompts/module${module}.prompt.md"
done

if grep -ERq \
  --exclude-dir=.git \
  --exclude-dir=.jfrog \
  --exclude-dir=.venv \
  --exclude-dir=node_modules \
  --exclude-dir=model_cache \
  --exclude='*.png' \
  --exclude='*.zip' \
  "(JFROG_ACCESS_TOKEN|API_KEY|PASSWORD)=['\"]?[A-Za-z0-9_-]{12,}" "$ROOT_DIR"; then
  echo "Possible secret found in workshop files." >&2
  exit 1
fi

bash "$ROOT_DIR/modules/01-curation-package/validate.sh"
bash "$ROOT_DIR/modules/02-model-governance/validate.sh"
bash "$ROOT_DIR/modules/03-skill-governance/validate.sh"
bash "$ROOT_DIR/modules/04-mcp-governance/validate.sh"
echo "Workshop validation: PASS"
