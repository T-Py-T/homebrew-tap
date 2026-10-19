#!/usr/bin/env bash
# scripts/ci-local.sh
# In GitHub Actions this runs the full `brew test-bot --only-tap-syntax`.
# Locally it never taps, installs, or otherwise modifies Homebrew: it only
# runs `ruby -c` on each formula/cask (plus rubocop if already installed).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

run_ruby_syntax_checks() {
  if ! command -v ruby >/dev/null 2>&1; then
    echo "ruby is not on PATH; install it first, then re-run." >&2
    exit 1
  fi
  local failed=0 count=0
  while IFS= read -r -d '' file; do
    count=$((count + 1))
    if ! ruby -c "$file" >/dev/null; then
      echo "syntax error: $file" >&2
      failed=1
    fi
  done < <(find Formula Casks lib Templates -type f -name '*.rb' -print0 2>/dev/null || true)
  echo "ruby -c: checked ${count} file(s)"
  if [[ "$failed" -ne 0 ]]; then
    return 1
  fi
  if command -v rubocop >/dev/null 2>&1; then
    echo "rubocop (advisory):"
    rubocop Formula Casks lib Templates 2>/dev/null || true
  fi
}

if [[ -n "${GITHUB_ACTIONS:-}" ]]; then
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_INSTALL_CLEANUP=1
  brew test-bot --only-tap-syntax --tap=t-py-t/tap
else
  echo "Local run: Ruby syntax checks only (full brew test-bot runs in GitHub Actions)." >&2
  run_ruby_syntax_checks
fi
