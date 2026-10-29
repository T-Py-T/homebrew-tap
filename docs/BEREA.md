# Cut a Berea cask from a major release

The public tap is [T-Py-T/homebrew-tap](https://github.com/T-Py-T/homebrew-tap)
(`brew tap T-Py-T/tap`). Berea source and release ZIPs stay in the private
[T-Py-T/Berea](https://github.com/T-Py-T/Berea) repository. This change adds a
non-installable template. It does not upload a GitHub release. It does not
publish a bottle. `brew install` cannot download an app from it yet.

Do not write version `1.0.0`. Do not call a cut stable until the Graph
search-click related nodes path works on that build. Packaged `desktop` is
still `0.1.0`. After the first stable major, bump only the major component
(`2.0.0`, then `3.0.0`). Do not ship minors or patches through this Cask.

## What the Cask installs

Homebrew installs `Berea.app` into `appdir`, which defaults to
`/Applications/Berea.app`. That path is the one the Keychain access-control
list in Berea's desktop docs already names. To keep the current owner path,
pass `--appdir="$HOME/Applications"` on install and upgrade.

The Cask does not install `com.berea.service`, does not touch port 4318, and
does not write LaunchAgents. The knowledge store, rooms data, and owner
token live outside the app bundle. The template sets `zap :not_required`.

## Build the qualified ZIP

1. On a Mac that holds the Developer ID credentials, from a Berea checkout
   at the release commit:

   ```sh
   cd desktop
   npm install
   npm run package -- --sign
   npm run package -- --sign --arch x64
   ```

2. Confirm the bundle is Developer ID signed, hardened-runtime, notarized,
   and stapled. `npm run package -- --sign` already runs
   `codesign --verify --deep --strict` and `spctl --assess`. An unsigned
   local `ditto` into `~/Applications` is not this asset.

3. Zip each architecture so `Berea.app` is at the archive root:

   ```sh
   version=VERSION
   (cd dist/Berea-darwin-arm64 && zip -ry "../Berea_${version}_darwin_arm64.zip" Berea.app)
   (cd dist/Berea-darwin-x64 && zip -ry "../Berea_${version}_darwin_x64.zip" Berea.app)
   ```

4. Compute SHA-256 of those two ZIPs. Do not reuse a checksum from an
   unsigned `desktop/dist` folder.

5. Create a private GitHub release tagged `vVERSION` with those two assets.
   Do not attach stores, Keychain items, fixtures, or test evidence.

`VERSION` is the first stable major when the Graph search-click related
nodes path works, then the next major after that. It is never `0.1.0`.

## Activate the Cask

Once the private assets exist at that tag and those filenames:

1. Copy `Templates/berea.rb.tmpl` to `Casks/berea.rb`.
2. Replace `VERSION`, `SHA256_ARM64`, and `SHA256_X64` with the real values.
3. Run `brew style --cask Casks/berea.rb` and
   `brew audit --strict --cask t-py-t/tap/berea`.
4. Run `brew test-bot --only-tap-syntax --tap=T-Py-T/tap`.
5. Open a metadata-only pull request on this tap. Merge that PR only after
   the style and audit gates pass. Do not merge a 1.0 Cask before the Graph
   gate.

The private GitHub download strategy in `lib/` reads
`HOMEBREW_GITHUB_API_TOKEN` at download time. Authorized users need Contents
read access to `T-Py-T/Berea`. Do not put a token in the Cask.

## Install and upgrade after the Cask is live

```sh
brew tap T-Py-T/tap
read -rs HOMEBREW_GITHUB_API_TOKEN && export HOMEBREW_GITHUB_API_TOKEN
brew install --cask T-Py-T/tap/berea
unset HOMEBREW_GITHUB_API_TOKEN
```

```sh
read -rs HOMEBREW_GITHUB_API_TOKEN && export HOMEBREW_GITHUB_API_TOKEN
brew update
brew upgrade --cask T-Py-T/tap/berea
unset HOMEBREW_GITHUB_API_TOKEN
```

`brew update` refreshes tap metadata. `brew upgrade --cask` replaces
`Berea.app`. Quit the app before upgrade. These commands are the future
path. This change does not run them.

`livecheck` is skipped on purpose. Homebrew will not auto-detect tags.
Copy a new major into `Casks/berea.rb` when that major is cut.
