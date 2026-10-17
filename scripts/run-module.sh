#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly SERVER_ID="workshop"
readonly PROJECT="workshop"
readonly NPM_REPO="workshop-npm"
readonly PYPI_REPO="workshop-pypi"

export JFROG_CLI_AVOID_NEW_VERSION_WARNING=true
export JFROG_CLI_USER_AGENT="ai-catalog-workshop-copilot/1.0"

usage() {
  printf '用法：bash scripts/run-module.sh <1|2|3|4>\n' >&2
}

if [[ $# -ne 1 || ! "$1" =~ ^[1-4]$ ]]; then
  usage
  exit 2
fi

if ! command -v jf >/dev/null 2>&1; then
  printf '找不到 JFrog CLI。請重建 GitHub Codespace，讓 postCreateCommand 完成設定。\n' >&2
  exit 1
fi

printf '前置檢查：JFrog Server=%s，Project=%s\n' "$SERVER_ID" "$PROJECT"
if ! jf rt ping --server-id "$SERVER_ID"; then
  printf '%s\n' \
    'JFrog 驗證失敗。請確認 JFROG_ACCESS_TOKEN 已設為此 Repository 的 GitHub Codespaces Secret，然後重建 Codespace。' \
    '不要把 Token 貼入 Copilot Chat，也不要切換到其他 Server。' >&2
  exit 1
fi

case "$1" in
  1)
    jf setup npm \
      --server-id "$SERVER_ID" \
      --repo "$NPM_REPO" \
      --project "$PROJECT"
    exec bash "$ROOT_DIR/modules/01-curation-package/run-live-demo.sh"
    ;;
  2)
    jf setup pip \
      --server-id "$SERVER_ID" \
      --repo "$PYPI_REPO" \
      --project "$PROJECT"
    exec bash "$ROOT_DIR/modules/02-model-governance/run-customer-demo.sh"
    ;;
  3)
    exec bash "$ROOT_DIR/modules/03-skill-governance/run-customer-demo.sh"
    ;;
  4)
    exec bash "$ROOT_DIR/modules/04-mcp-governance/run-customer-demo.sh"
    ;;
esac
