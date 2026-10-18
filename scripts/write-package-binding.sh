#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly BINDING_DIR="$ROOT_DIR/.jfrog/local"
readonly BINDING_PATH="$BINDING_DIR/package-resolution.json"

if [[ $# -ne 2 ]]; then
  printf '用法：bash scripts/write-package-binding.sh <npm|pypi> <repository>\n' >&2
  exit 2
fi

readonly PACKAGE_TYPE="$1"
readonly REPOSITORY="$2"

case "$PACKAGE_TYPE" in
  npm|pypi) ;;
  *)
    printf '不支援的套件類型：%s\n' "$PACKAGE_TYPE" >&2
    exit 2
    ;;
esac

mkdir -p "$BINDING_DIR"
binding_tmp="$(mktemp "$BINDING_DIR/package-resolution.json.tmp.XXXXXX")"
trap 'rm -f "$binding_tmp"' EXIT

if [[ -f "$BINDING_PATH" ]]; then
  jq \
    --arg package_type "$PACKAGE_TYPE" \
    --arg repository "$REPOSITORY" \
    '.repositories = (.repositories // {}) | .repositories[$package_type] = $repository' \
    "$BINDING_PATH" > "$binding_tmp"
else
  jq -n \
    --arg package_type "$PACKAGE_TYPE" \
    --arg repository "$REPOSITORY" \
    '{repositories: {($package_type): $repository}}' > "$binding_tmp"
fi

mv "$binding_tmp" "$BINDING_PATH"
trap - EXIT
printf '工作區綁定：%s=%s\n' "$PACKAGE_TYPE" "$REPOSITORY"
