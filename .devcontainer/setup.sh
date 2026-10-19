#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly SERVER_ID="workshop"
readonly PLATFORM_URL="https://alexwangtrial.jfrog.io"
readonly PROJECT="workshop"
readonly NPM_REPO="workshop-npm"
readonly PYPI_REPO="workshop-pypi"
readonly NPM_REGISTRY="https://alexwangtrial.jfrog.io/artifactory/api/npm/workshop-npm/"
readonly SKILLS_CLI_VERSION="1.7.2"
readonly JFROG_SKILLS_COMMIT="bb18d74b933e22e19fceea9b1bcbcf91135f06a1"
readonly JFROG_SKILLS_SOURCE="https://github.com/jfrog/jfrog-skills/tree/${JFROG_SKILLS_COMMIT}"
readonly -a JFROG_SKILLS=(
  "jfrog"
  "jfrog-ai-catalog"
  "jfrog-init"
  "jfrog-mcp-management"
  "jfrog-package-curation"
  "jfrog-reference-architecture"
  "jfrog-setup-package-managers"
)

export CI=true
export JFROG_CLI_AVOID_NEW_VERSION_WARNING=true
export JFROG_CLI_USER_AGENT="${JFROG_CLI_USER_AGENT:-ai-catalog-workshop-codespaces/1.0}"

cd "$ROOT_DIR"
JFROG_SETUP_READY=false

install_copilot_jfrog_skills() {
  local skill

  printf '為 GitHub Copilot 安裝 JFrog Skills（commit %s）...\n' \
    "${JFROG_SKILLS_COMMIT:0:12}"
  npx --yes \
    --registry "$NPM_REGISTRY" \
    "skills@${SKILLS_CLI_VERSION}" add "$JFROG_SKILLS_SOURCE" \
    --global \
    --agent github-copilot \
    --skill "${JFROG_SKILLS[@]}" \
    --copy \
    --yes \
    --json

  for skill in "${JFROG_SKILLS[@]}"; do
    if [[ ! -f "$HOME/.agents/skills/$skill/SKILL.md" ]]; then
      printf 'Copilot Skill 安裝驗證失敗：%s\n' "$skill" >&2
      exit 1
    fi
  done

  printf 'GitHub Copilot JFrog Skills：PASS（%s 個）\n' "${#JFROG_SKILLS[@]}"
}

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
  if ! printf '%s' "$JFROG_ACCESS_TOKEN" |
    jf config add "$SERVER_ID" \
      --url "$PLATFORM_URL" \
      --access-token-stdin \
      --interactive=false \
      --overwrite; then
    printf 'JFrog Server 設定失敗；Live Lab 與 JFrog Skills 安裝已安全停止。\n' >&2
  elif ! jf config use "$SERVER_ID"; then
    printf 'JFrog Server 選取失敗；Live Lab 與 JFrog Skills 安裝已安全停止。\n' >&2
  elif ! jf rt ping --server-id "$SERVER_ID"; then
    printf 'JFrog 連線失敗；Live Lab 與 JFrog Skills 安裝已安全停止。\n' >&2
  elif ! jf setup npm \
    --server-id "$SERVER_ID" \
    --repo "$NPM_REPO" \
    --project "$PROJECT"; then
    printf '找不到或無權使用 workshop-npm；未改用其他 Repository，Live Lab 與 JFrog Skills 安裝已安全停止。\n' >&2
  else
    bash "$ROOT_DIR/scripts/write-package-binding.sh" npm "$NPM_REPO"
    if ! jf setup pip \
      --server-id "$SERVER_ID" \
      --repo "$PYPI_REPO" \
      --project "$PROJECT"; then
      printf '找不到或無權使用 workshop-pypi；未改用其他 Repository，Live Lab 與 JFrog Skills 安裝已安全停止。\n' >&2
    else
      bash "$ROOT_DIR/scripts/write-package-binding.sh" pypi "$PYPI_REPO"
      JFROG_SETUP_READY=true
      printf 'JFrog Codespace 設定：PASS\n'
    fi
  fi
else
  printf '%s\n' \
    '尚未提供 JFROG_ACCESS_TOKEN。Codespace 已建立，但 Module Live Lab 會安全停止。' \
    '請由講師在 GitHub Codespaces Secret 設定短期 Token，然後重建 Codespace。' \
    '不要把 Token 貼入 Copilot Chat。'
fi

if [[ "$JFROG_SETUP_READY" == true ]]; then
  install_copilot_jfrog_skills
elif [[ -z "${JFROG_ACCESS_TOKEN:-}" ]] &&
  [[ -f "$ROOT_DIR/.jfrog/local/package-resolution.json" ]] &&
  jq -e --arg repo "$NPM_REPO" \
    '.repositories.npm == $repo' \
    "$ROOT_DIR/.jfrog/local/package-resolution.json" >/dev/null; then
  install_copilot_jfrog_skills
else
  printf 'JFrog Skills 尚未安裝：找不到 workshop-npm 套件解析綁定。\n'
fi

bash scripts/validate-workshop.sh
printf 'Codespace 教材驗證：PASS。請在 Copilot Chat 選擇 Local Agent，輸入 /module1、/module2、/module3 或 /module4。\n'
