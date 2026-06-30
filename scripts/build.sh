#!/usr/bin/env bash
set -euo pipefail

HUGO_VERSION="${HUGO_VERSION:-0.163.3}"

ensure_hugo() {
  local want="$1"
  local current=""
  if command -v hugo >/dev/null 2>&1; then
    current="$(hugo version 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1 | tr -d 'v' || true)"
  fi
  if [[ "$current" == "$want" ]]; then
    return
  fi

  local os arch
  case "$(uname -s)" in
    Linux) os=Linux ;;
    Darwin) os=Darwin ;;
    *) echo "Unsupported OS for Hugo install: $(uname -s)" >&2; exit 1 ;;
  esac
  case "$(uname -m)" in
    x86_64 | amd64) arch=amd64 ;;
    aarch64 | arm64) arch=arm64 ;;
    *) echo "Unsupported arch for Hugo install: $(uname -m)" >&2; exit 1 ;;
  esac

  local dir="${TMPDIR:-/tmp}/hugo-${want}"
  mkdir -p "$dir"
  curl -fsSL \
    "https://github.com/gohugoio/hugo/releases/download/v${want}/hugo_extended_${want}_${os}-${arch}.tar.gz" \
    | tar -xz -C "$dir" hugo
  export PATH="$dir:$PATH"
  echo "Installed Hugo $(hugo version)"
}

ensure_hugo "$HUGO_VERSION"

args=(--minify --gc)

run_hugo() {
  hugo "${args[@]}" "$@"
}

# 仅在预览部署时覆盖 baseURL；生产环境使用 hugo.toml 中的 baseURL
if [[ -n "${HUGO_BASEURL:-}" ]]; then
  run_hugo -b "$HUGO_BASEURL"
elif [[ "${VERCEL_ENV:-}" == "preview" && -n "${VERCEL_URL:-}" ]]; then
  run_hugo -b "https://${VERCEL_URL}"
elif [[ "${CONTEXT:-}" =~ ^(deploy-preview|branch-deploy)$ && -n "${DEPLOY_PRIME_URL:-}" ]]; then
  run_hugo -b "$DEPLOY_PRIME_URL"
elif [[ "${CF_PAGES:-}" == "1" && -n "${CF_PAGES_URL:-}" ]]; then
  prod_branch="${CF_PAGES_PRODUCTION_BRANCH:-main}"
  if [[ "${CF_PAGES_BRANCH:-}" != "$prod_branch" ]]; then
    run_hugo -b "$CF_PAGES_URL"
  else
    run_hugo
  fi
else
  run_hugo
fi
