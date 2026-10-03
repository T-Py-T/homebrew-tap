# Security policy

Public Homebrew tap distribution for [T-Py-T](https://github.com/T-Py-T) packages.
Treat edits to download URLs, SHA-256 checksums, install hooks, Ruby in `lib/`,
and GitHub Actions as security-sensitive.

## Scope

**In scope for reports here**

- Suspected tampering with formulae, casks, templates, or workflow files in this repository
- Leaked credentials or tokens committed to the tap
- Bypass or weakening of checksum verification, quarantine handling, or Gatekeeper expectations
- Issues in the tap's custom download strategy that could expose tokens or fetch unintended artifacts

**Out of scope**

- Vulnerabilities in upstream `atomic`, `mac-ogcs`, or other packaged software (report to those projects)
- General Homebrew or macOS issues unrelated to this tap's definitions
- Workstation bootstrap in [T-Py-T/chezmoi-dotfiles](https://github.com/T-Py-T/chezmoi-dotfiles) (see that repository's policies)

## Report a vulnerability

Use [GitHub private vulnerability reporting](https://github.com/T-Py-T/homebrew-tap/security/advisories/new) for this repository, or contact the repository owner through a private channel you already use for T-Py-T work.

Do not open a public issue with exploit details, live tokens, or credential material.

## Maintainer expectations

- Never commit credentials, authenticated URLs, or long-lived tokens.
- Preserve macOS quarantine metadata and Gatekeeper verification; do not add quarantine-removal hooks.
- Pin third-party GitHub Actions to full commit hashes.
- Require review for release URL or checksum changes once branch protection is enabled.

## Related documentation

- [README.md](README.md) — install, package layout, and change validation
- [LICENSE](LICENSE) — MIT for tap-owned files; packaged software keeps its own license
- [T-Py-T/chezmoi-dotfiles](https://github.com/T-Py-T/chezmoi-dotfiles) — Brewfiles that consume this tap (separate security boundary)

## Tip-cite

Default-branch tip prefix: `6912f058` (`main`, Ship 248 merge). This pull request is pending
Steward resolve against that tip. Tip citation only — not READY, not a score or
bake-off claim, and not AUTH unpark.
