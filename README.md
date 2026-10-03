# T-Py-T Homebrew Tap

[![brew test-bot](https://github.com/T-Py-T/homebrew-tap/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/T-Py-T/homebrew-tap/actions/workflows/tests.yml)

Public [Homebrew tap](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap) for
T-Py-T command-line tools and macOS applications. Package definitions,
checksums, templates, and pull-request syntax validation are visible in this
repository. `atomic` installs from a public npm release; `mac-ogcs` downloads a
private GitHub release and requires an authorized token when Homebrew fetches or
upgrades it.

**Topics:** Homebrew · tap · formula · cask · macOS · npm · private GitHub
releases · GitHub Actions · `brew test-bot`. **Reviewers:** [Security policy](SECURITY.md) · [MIT
License](LICENSE)

## Install

```sh
brew tap T-Py-T/tap
```

Install the public `atomic` formula:

```sh
brew install T-Py-T/tap/atomic
```

Upgrade it with:

```sh
brew upgrade T-Py-T/tap/atomic
```

## Install mac-ogcs

The `mac-ogcs` package definition is public, but its release archive is private.
Before installing or upgrading it, export a GitHub token with read access to the
`T-Py-T/mac-ogcs` repository:

```sh
export HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"
brew install --cask T-Py-T/tap/mac-ogcs
```

The token is read at download time by the custom strategy in [`lib/`](lib). It
is not stored in the Cask. Clear the variable when the install is complete if
you do not need it for subsequent upgrades.

## Repository layout

- `Casks/` contains prebuilt terminal binaries and macOS applications.
- `Formula/` contains tools built from source or distributed as Homebrew bottles.
- `lib/` contains reusable Ruby support loaded by generated Casks.
- `Templates/` contains non-installable starting points for new packages.
- `.github/workflows/` validates tap syntax on pull requests.

mac-ogcs is a terminal application, but its prebuilt release belongs in a Cask: Homebrew's `binary` artifact links the executable without requiring a desktop `.app` bundle or a compiler on the destination Mac.

The mac-ogcs Cask loads its private-release download strategy from `lib/`. The
strategy reads `HOMEBREW_GITHUB_API_TOKEN` only when Homebrew downloads an
asset, after Homebrew restores sensitive environment variables. Keeping the
class outside the Cask block also satisfies Homebrew's Ruby style rules.

## Add or update a package

1. Publish signed release archives for Apple silicon and Intel.
2. Calculate the SHA-256 checksum of each final archive.
3. Copy the appropriate template into `Casks/` or `Formula/` and replace every placeholder.
4. Run `brew style` and `brew audit --strict` for the new package.
5. Open a pull request and require the tap checks to pass before merging.

Do not add quarantine-removal hooks. Release artifacts must remain compatible with normal macOS Gatekeeper checks.

## Package notes

- [`Formula/atomic.rb`](Formula/atomic.rb) installs the versioned npm release,
  repairs embedded PostgreSQL library paths on macOS, and links the `atomic`
  executable.
- [`Casks/mac-ogcs.rb`](Casks/mac-ogcs.rb) uses GitHub's authenticated
  release-asset API with per-architecture SHA-256 checksums. The reusable
  starting point is [`Templates/mac-ogcs.rb.tmpl`](Templates/mac-ogcs.rb.tmpl).

The mac-ogcs Cask preserves quarantine metadata and contains no Gatekeeper
bypass hook.

## Validate a change

Run Homebrew's tap checks before opening a pull request:

```sh
brew test-bot --only-tap-syntax --tap=T-Py-T/tap
```

The pull-request workflow runs the same syntax gate. It does not run on pushes,
schedules, or manual dispatches.

## Documentation

- [Homebrew tap guide](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)
- [Cask cookbook](https://docs.brew.sh/Cask-Cookbook)
- [T-Py-T/chezmoi-dotfiles](https://github.com/T-Py-T/chezmoi-dotfiles) — platform Brewfiles that reference this tap for workstation bootstrap
