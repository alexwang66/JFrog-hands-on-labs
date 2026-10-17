#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SERVER_ID="workshop"
readonly PROJECT="workshop"
readonly HF_REPO="workshop-huggingfaceml"
readonly APPROVED_ENDPOINT="https://alexwangtrial.jfrog.io/artifactory/api/huggingfaceml/workshop-huggingfaceml"
readonly SAFE_CANDIDATE="openai-community/gpt2"
readonly BLOCKED_CANDIDATE="glockr1/ballr7"
readonly REVISION="main"

command -v jf >/dev/null
command -v python3 >/dev/null

printf '1/4 驗證 JFrog Server：%s\n' "$SERVER_ID"
jf rt ping --server-id "$SERVER_ID"

printf '2/4 驗證 Module 2 教材完整性\n'
bash "$MODULE_DIR/validate.sh"

printf '3/4 安全模型候選 Dry Run（不下載）\n'
HF_ENDPOINT="$APPROVED_ENDPOINT" \
  python3 "$MODULE_DIR/model-client/download_model.py" \
    --model "$SAFE_CANDIDATE" \
    --revision "$REVISION" \
    --local-dir model_cache/gpt2 \
    --dry-run

printf '4/4 阻擋模型候選 Dry Run（不下載）\n'
HF_ENDPOINT="$APPROVED_ENDPOINT" \
  python3 "$MODULE_DIR/model-client/download_model.py" \
    --model "$BLOCKED_CANDIDATE" \
    --revision "$REVISION" \
    --local-dir model_cache/blocked-model \
    --dry-run

printf '完成：Project=%s，Repository=%s。以上只做 Dry Run；實際模型下載必須先取得講師對精確模型與 Revision 的明確核准。\n' \
  "$PROJECT" "$HF_REPO"
