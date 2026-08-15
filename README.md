# T-Py-T Homebrew Tap

Private Homebrew distribution for T-Py-T command-line tools and macOS applications.

## Install

This repository is private, so authenticate Git before tapping it. SSH is the simplest option on a machine that already has access:

```sh
brew tap T-Py-T/tap git@github.com:T-Py-T/homebrew-tap.git
```

After a package has been published:

```sh
brew install --cask T-Py-T/tap/mac-ogcs
brew install T-Py-T/tap/atomic
```

Upgrade installed packages with:

```sh
brew upgrade T-Py-T/tap/atomic
```

A private tap and a private release download use separate credentials. No
package in this repository embeds a token. Before installing or upgrading
mac-ogcs, expose a GitHub token with read access to the private application
repository:

```sh
export HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"
brew install --cask T-Py-T/tap/mac-ogcs
```

## Repository layout

- `Casks/` contains prebuilt terminal binaries and macOS applications.
- `Formula/` contains tools built from source or distributed as Homebrew bottles.
- `lib/` contains reusable Ruby support loaded by generated Casks.
- `Templates/` contains non-installable starting points for new packages.
- `.github/workflows/` contains the workflows generated and recommended by Homebrew for tap validation and bottle publishing.

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

## mac-ogcs package

The active private pre-release is [`Casks/mac-ogcs.rb`](Casks/mac-ogcs.rb). It
uses GitHub's authenticated release-asset API with immutable per-architecture
asset IDs and SHA-256 checksums. The reusable starting point remains
[`Templates/mac-ogcs.rb.tmpl`](Templates/mac-ogcs.rb.tmpl).

The first proof is not Developer ID notarized. The Cask deliberately preserves
quarantine metadata and contains no Gatekeeper bypass hook.

## Documentation

See [Homebrew's tap documentation](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap) and [Cask cookbook](https://docs.brew.sh/Cask-Cookbook).
