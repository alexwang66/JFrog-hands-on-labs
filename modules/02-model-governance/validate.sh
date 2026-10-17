#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PYTHONPYCACHEPREFIX="${TMPDIR:-/tmp}/ai-catalog-workshop-pycache"
python3 -m py_compile \
  "$MODULE_DIR/model-client/download_model.py" \
  "$MODULE_DIR/model-client/upload_model.py"
test -s "$MODULE_DIR/assets/Block-model.png"
actual_sha="$(shasum -a 256 "$MODULE_DIR/assets/Block-model.png" | awk '{print $1}')"
test "$actual_sha" = "9d1e7c61f98ac5dacfb5f290f50cf60a83178f9e8d8f8dd8c107aa4d78f2687a"
test -f "$MODULE_DIR/model-client/requirements.txt"
test -x "$MODULE_DIR/run-customer-demo.sh"
bash -n "$MODULE_DIR/run-customer-demo.sh"
grep -q '^JFROG_SERVER_ID=workshop$' "$MODULE_DIR/module.env.example"
grep -q '^JF_PROJECT=workshop$' "$MODULE_DIR/module.env.example"
grep -q '^JFROG_PYPI_VIRTUAL_REPO=workshop-pypi$' "$MODULE_DIR/module.env.example"
grep -q '^JFROG_HUGGINGFACE_REPO=workshop-huggingfaceml$' "$MODULE_DIR/module.env.example"
grep -q '^HF_ENDPOINT=https://alexwangtrial.jfrog.io/artifactory/api/huggingfaceml/workshop-huggingfaceml$' \
  "$MODULE_DIR/module.env.example"
if rg -n 'HF_HUB_DISABLE_SSL_VERIFICATION|verify[[:space:]]*=[[:space:]]*False' "$MODULE_DIR/model-client"; then
  echo "TLS verification bypass found." >&2
  exit 1
fi

approved_endpoint="https://alexwangtrial.jfrog.io/artifactory/api/huggingfaceml/workshop-huggingfaceml"
dry_run_output="$(
  HF_ENDPOINT="$approved_endpoint" \
    python3 "$MODULE_DIR/model-client/download_model.py" \
      --model openai-community/gpt2 \
      --revision main \
      --local-dir model_cache/gpt2 \
      --dry-run
)"
grep -q '^endpoint=https://alexwangtrial.jfrog.io/artifactory/api/huggingfaceml/workshop-huggingfaceml$' \
  <<<"$dry_run_output"
grep -q '^token_configured=no$' <<<"$dry_run_output"

if HF_ENDPOINT="https://huggingface.co" \
  python3 "$MODULE_DIR/model-client/download_model.py" \
    --model openai-community/gpt2 \
    --dry-run >/dev/null 2>&1; then
  echo "Public Hugging Face endpoint was not rejected." >&2
  exit 1
fi
echo "Module 02 validation: PASS"
