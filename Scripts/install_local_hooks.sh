#!/bin/sh
set -eu
repo=$(git rev-parse --show-toplevel)
cd "$repo"
command -v pre-commit >/dev/null
pre-commit validate-config .pre-commit-config.yaml
current=$(git config --local --get core.hooksPath || true)
if [ -n "$current" ] && [ "$current" != .githooks ]; then
  echo "An existing hook path is configured; preserve it and review integration first." >&2
  exit 1
fi
chmod +x .githooks/pre-commit
git config --local core.hooksPath .githooks
printf '%s\n' 'Installed repo-local .githooks/pre-commit; no global Git configuration changed.'
