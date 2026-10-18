#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly SERVER_ID="workshop"
readonly PROJECT="workshop"
readonly NPM_REPO="workshop-npm"
readonly PYPI_REPO="workshop-pypi"
readonly BINDING_PATH="$ROOT_DIR/.jfrog/local/package-resolution.json"

export JFROG_CLI_AVOID_NEW_VERSION_WARNING=true
export JFROG_CLI_USER_AGENT="${JFROG_CLI_USER_AGENT:-ai-catalog-workshop-copilot/1.0}"

usage() {
  printf '用法：bash scripts/run-module.sh <1|2|3|4>\n' >&2
}

binding_matches() {
  local package_type="$1"
  local repository="$2"

  [[ -f "$BINDING_PATH" ]] &&
    jq -e \
      --arg package_type "$package_type" \
      --arg repository "$repository" \
      '.repositories[$package_type] == $repository' \
      "$BINDING_PATH" >/dev/null
}

if [[ $# -ne 1 || ! "$1" =~ ^[1-4]$ ]]; then
  usage
  exit 2
fi

printf '執行時間（Asia/Shanghai）：%s\n' \
  "$(TZ=Asia/Shanghai date '+%Y-%m-%dT%H:%M:%S%z')"

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
    if binding_matches npm "$NPM_REPO"; then
      printf 'npm 工作區已綁定：%s\n' "$NPM_REPO"
    else
      jf setup npm \
        --server-id "$SERVER_ID" \
        --repo "$NPM_REPO" \
        --project "$PROJECT"
      bash "$ROOT_DIR/scripts/write-package-binding.sh" npm "$NPM_REPO"
    fi
    exec bash "$ROOT_DIR/modules/01-curation-package/run-live-demo.sh"
    ;;
  2)
    if binding_matches pypi "$PYPI_REPO"; then
      printf 'PyPI 工作區已綁定：%s\n' "$PYPI_REPO"
    else
      jf setup pip \
        --server-id "$SERVER_ID" \
        --repo "$PYPI_REPO" \
        --project "$PROJECT"
      bash "$ROOT_DIR/scripts/write-package-binding.sh" pypi "$PYPI_REPO"
    fi
    exec bash "$ROOT_DIR/modules/02-model-governance/run-customer-demo.sh"
    ;;
  3)
    exec bash "$ROOT_DIR/modules/03-skill-governance/run-customer-demo.sh"
    ;;
  4)
    exec bash "$ROOT_DIR/modules/04-mcp-governance/run-customer-demo.sh"
    ;;
esac
