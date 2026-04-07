#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$ROOT_DIR/.env"

STATIC_DIR="$ROOT_DIR/static"
REPO_NAME="${REPO_NAME:-$(basename "$ROOT_DIR")}"
VISIBILITY="${VISIBILITY:-public}"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"
PAGES_BRANCH="${PAGES_BRANCH:-gh-pages}"
COMMIT_MESSAGE="${COMMIT_MESSAGE:-Initial site deployment}"
REPO_SLUG=""

log() {
  printf '\n==> %s\n' "$1"
}

fail() {
  printf '\nError: %s\n' "$1" >&2
  exit 1
}

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

load_env_file() {
  [ -f "$ENV_FILE" ] || return

  local line
  local key
  local value

  while IFS= read -r line || [ -n "$line" ]; do
    line="$(trim "$line")"

    [ -z "$line" ] && continue
    case "$line" in
      \#*) continue ;;
    esac

    key="${line%%=*}"
    value="${line#*=}"
    key="$(trim "$key")"
    value="$(trim "$value")"

    [[ "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || fail "Invalid key in .env: $key"

    if [[ "$value" == \"*\" && "$value" == *\" ]]; then
      value="${value:1:${#value}-2}"
    elif [[ "$value" == \'*\' && "$value" == *\' ]]; then
      value="${value:1:${#value}-2}"
    fi

    export "$key=$value"
  done < "$ENV_FILE"
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing required command: $1"
}

ensure_repo() {
  if git -C "$ROOT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    return
  fi

  log "Initializing local git repository"
  git -C "$ROOT_DIR" init -b "$DEFAULT_BRANCH"
}

ensure_local_identity() {
  if git -C "$ROOT_DIR" config user.name >/dev/null 2>&1 && git -C "$ROOT_DIR" config user.email >/dev/null 2>&1; then
    return
  fi

  fail "Git user.name and user.email are not configured. Set them before running deploy.sh."
}

ensure_files() {
  [ -d "$STATIC_DIR" ] || fail "Expected static directory at $STATIC_DIR"
  [ -f "$STATIC_DIR/index.html" ] || fail "Expected static/index.html to exist before deployment"
}

ensure_github_auth() {
  gh auth status >/dev/null 2>&1 || fail "GitHub CLI is not authenticated. Run: gh auth login"
}

ensure_remote_and_repo() {
  if git -C "$ROOT_DIR" remote get-url origin >/dev/null 2>&1; then
    return
  fi

  log "Creating GitHub repository $REPO_NAME"
  gh repo create "$REPO_NAME" --"$VISIBILITY" --source "$ROOT_DIR" --remote origin --push=false
}

resolve_repo_slug() {
  REPO_SLUG="$(cd "$ROOT_DIR" && gh repo view --json owner,name --jq '.owner.login + "/" + .name')"
}

commit_main_branch() {
  log "Creating local commit on $DEFAULT_BRANCH"
  git -C "$ROOT_DIR" add .

  if git -C "$ROOT_DIR" diff --cached --quiet; then
    printf 'Nothing new to commit on %s\n' "$DEFAULT_BRANCH"
    return
  fi

  git -C "$ROOT_DIR" commit -m "$COMMIT_MESSAGE"
}

push_main_branch() {
  log "Pushing $DEFAULT_BRANCH to origin"
  git -C "$ROOT_DIR" push -u origin "$DEFAULT_BRANCH"
}

publish_pages_branch() {
  log "Publishing static/ to $PAGES_BRANCH"

  local tmp_dir
  local remote_url
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' EXIT
  remote_url="$(git -C "$ROOT_DIR" remote get-url origin)"

  git clone --branch "$DEFAULT_BRANCH" --single-branch "$remote_url" "$tmp_dir/repo" >/dev/null 2>&1

  (
    cd "$tmp_dir/repo"
    git checkout --orphan "$PAGES_BRANCH" >/dev/null 2>&1
    find . -mindepth 1 -maxdepth 1 \
      ! -name .git \
      ! -name . \
      -exec rm -rf {} +
    cp -R "$STATIC_DIR"/. .
    touch .nojekyll
    git add .
    git commit -m "Publish GitHub Pages"
    git push -f origin "$PAGES_BRANCH"
  )
}

configure_pages() {
  local owner
  local name
  local create_status
  local update_status

  owner="${REPO_SLUG%%/*}"
  name="${REPO_SLUG##*/}"

  log "Configuring GitHub Pages"
  if gh api \
    --method POST \
    -H "Accept: application/vnd.github+json" \
    "/repos/$owner/$name/pages" \
    -f source[branch]="$PAGES_BRANCH" \
    -f source[path]="/" >/dev/null 2>&1; then
    printf '\nGitHub Pages should publish from branch %s at: https://%s.github.io/%s/\n' "$PAGES_BRANCH" "$owner" "$name"
    return
  fi

  create_status=$?

  if gh api \
    --method PUT \
    -H "Accept: application/vnd.github+json" \
    "/repos/$owner/$name/pages" \
    -f source[branch]="$PAGES_BRANCH" \
    -f source[path]="/" >/dev/null; then
    printf '\nGitHub Pages should publish from branch %s at: https://%s.github.io/%s/\n' "$PAGES_BRANCH" "$owner" "$name"
    return
  fi

  update_status=$?
  fail "Unable to configure GitHub Pages automatically (create exit $create_status, update exit $update_status). Confirm the repo exists on GitHub, that '$PAGES_BRANCH' was pushed to origin, and that your GitHub CLI token has repo admin access."
}

main() {
  load_env_file
  require_command git
  require_command gh
  ensure_files
  ensure_repo
  ensure_local_identity
  ensure_github_auth
  ensure_remote_and_repo
  resolve_repo_slug
  commit_main_branch
  push_main_branch
  publish_pages_branch
  configure_pages
}

main "$@"
