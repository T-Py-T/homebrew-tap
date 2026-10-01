# Hireability snapshot

Quick orientation for recruiters, hiring managers, and engineers reviewing this
repository as a work sample. Install steps and layout live in [README.md](../README.md).

## What

Public Homebrew tap for T-Py-T command-line tools and macOS applications: the
`atomic` formula (versioned npm release) and the `mac-ogcs` cask (prebuilt
terminal binary from a private GitHub release via a custom download strategy in
[`lib/`](../lib)).

## Why

- Distribution metadata stays public and reviewable while private release assets
  stay off the tap; tokens are read only at download time.
- SHA-256 checksums, pinned third-party actions, and PR-only `brew test-bot`
  syntax checks reduce surprise installs.
- Complements [T-Py-T/chezmoi-dotfiles](https://github.com/T-Py-T/chezmoi-dotfiles)
  Brewfile-driven bootstrap: this tap ships `atomic` and `mac-ogcs` without
  folding Homebrew package definitions into the dotfiles tree.

## How to evaluate

1. Read [README.md](../README.md) — install commands, [repository layout](../README.md#repository-layout), and [validate a change](../README.md#validate-a-change).
2. Skim recent [brew test-bot](https://github.com/T-Py-T/homebrew-tap/actions/workflows/tests.yml) workflow runs (pull requests only).
3. Review [SECURITY.md](../SECURITY.md) for credentials, quarantine, and reporting expectations.

## Topics

`homebrew` · tap · formula · cask · macOS · npm · Ruby · private GitHub releases ·
GitHub Actions · `brew test-bot`

## License

Repository-owned formulae, casks, templates, and documentation:
[MIT License](../LICENSE). Packaged software remains under its own license.

## Tip-cite

Default-branch tip prefix: `c079f9a` (`main`). This pull request is pending
Steward resolve against that tip. Tip citation only — not READY, not a score or
bake-off claim, and not AUTH unpark.
