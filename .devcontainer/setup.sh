#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly SERVER_ID="workshop"
readonly PLATFORM_URL="https://alexwangtrial.jfrog.io"
readonly PROJECT="workshop"
readonly NPM_REPO="workshop-npm"
readonly PYPI_REPO="workshop-pypi"

export CI=true
export JFROG_CLI_AVOID_NEW_VERSION_WARNING=true
export JFROG_CLI_USER_AGENT="ai-catalog-workshop-codespaces/1.0"

cd "$ROOT_DIR"

if ! command -v jf >/dev/null 2>&1; then
  printf '安裝 JFrog CLI...\n'
  curl -fL https://install-cli.jfrog.io | sh
fi

for command in jf node npm python3 jq; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'Codespace 缺少必要工具：%s\n' "$command" >&2
    exit 1
  fi
done

if [[ -n "${JFROG_ACCESS_TOKEN:-}" ]]; then
  printf '設定 JFrog Server、Project 與 Virtual Repository...\n'
  printf '%s' "$JFROG_ACCESS_TOKEN" |
    jf config add "$SERVER_ID" \
      --url "$PLATFORM_URL" \
      --access-token-stdin \
      --interactive=false \
      --overwrite
  jf config use "$SERVER_ID"
  jf rt ping --server-id "$SERVER_ID"
  jf setup npm \
    --server-id "$SERVER_ID" \
    --repo "$NPM_REPO" \
    --project "$PROJECT"
  bash "$ROOT_DIR/scripts/write-package-binding.sh" npm "$NPM_REPO"
  jf setup pip \
    --server-id "$SERVER_ID" \
    --repo "$PYPI_REPO" \
    --project "$PROJECT"
  bash "$ROOT_DIR/scripts/write-package-binding.sh" pypi "$PYPI_REPO"
  printf 'JFrog Codespace 設定：PASS\n'
else
  printf '%s\n' \
    '尚未提供 JFROG_ACCESS_TOKEN。Codespace 已建立，但 Module Live Lab 會安全停止。' \
    '請由講師在 GitHub Codespaces Secret 設定短期 Token，然後重建 Codespace；不要把 Token 貼入 Copilot Chat。'
fi

bash scripts/validate-workshop.sh
printf 'Codespace 教材驗證：PASS。請在 Copilot Chat 選擇 Local Agent，輸入 /module1、/module2、/module3 或 /module4。\n'
