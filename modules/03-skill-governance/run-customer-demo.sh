#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_ID="workshop"
PROJECT="workshop"
AGENT_GUARD_REGISTRY="${JFROG_AGENT_GUARD_REPO:-https://releases.jfrog.io/artifactory/api/npm/coding-agents-npm/}"
AGENT_GUARD_CACHE="${TMPDIR:-/tmp}/jfrog-workshop-agent-guard-safe-v1"

command -v jf >/dev/null
command -v npx >/dev/null
mkdir -p "$AGENT_GUARD_CACHE"

run_agent_guard() {
  local -a clean_env=(
    -i
    "HOME=$HOME"
    "PATH=$PATH"
    "TMPDIR=${TMPDIR:-/tmp}"
    "NO_COLOR=1"
    "npm_config_cache=$AGENT_GUARD_CACHE"
  )
  local env_name
  for env_name in \
    LANG LC_ALL LC_CTYPE LOGNAME SHELL USER \
    NODE_EXTRA_CA_CERTS NODE_USE_SYSTEM_CA REQUESTS_CA_BUNDLE; do
    if [[ -n "${!env_name:-}" ]]; then
      clean_env+=("$env_name=${!env_name}")
    fi
  done
  env "${clean_env[@]}" \
    npx --yes --registry "$AGENT_GUARD_REGISTRY" @jfrog/agent-guard "$@"
}

printf '1/4 驗證 JFrog Server：%s\n' "$SERVER_ID"
jf rt ping --server-id "$SERVER_ID"

printf '2/4 驗證教材完整性（不執行 Fixture）\n'
bash "$MODULE_DIR/validate.sh"

printf '3/4 查詢安全 Skill：secure-release-review\n'
run_agent_guard \
  --list-skills \
  --project "$PROJECT" \
  --name secure-release-review \
  --server "$SERVER_ID" \
  --page-size 50 \
  --format json

printf '4/4 查詢惡意測試 Skill：env-demo-malicious（只查詢，不安裝）\n'
run_agent_guard \
  --list-skills \
  --project "$PROJECT" \
  --name env-demo-malicious \
  --server "$SERVER_ID" \
  --page-size 50 \
  --format json

printf '完成：若輸出為 skills:null，請停止並通知講師；不得改用其他來源。\n'
