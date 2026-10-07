# Focus Owned packaging preparation

The public tap holds installer metadata. Focus Owned source and release downloads remain in the private `T-Py-T/FocusOwned` repository. This draft adds a non-installable template, not a released cask. It does not upload, download, install or upgrade an app.

## Release dependencies

The source changes in Focus Owned PR #5 must be reviewed and merged before a release is selected. After that, verify the exact source commit, marketing version, build number and final artifact destination. Physical device hydration and populated updates still require acceptance; notes, attachments, sessions and history currently have local-only transport coverage.

The initial package supports Apple silicon and macOS Sonoma or later. Its version is `VERSION,BUILD`; its private tag is `vVERSION-buildBUILD` and its asset name is `FocusOwned_VERSION_buildBUILD_darwin_arm64.zip`. The final ZIP must contain these top-level artifacts:

- `FocusOwned-macOS.app`, with stable bundle identifier `com.taylor.FocusOwned` and matching version/build.
- `focus-owned-axi`, compiled from the same reviewed source commit.

Qualify the app and CLI for distribution with Developer ID signing, hardened runtime and notarization, retaining required app entitlements. Development signing or an unsigned build is not that qualification. Assess the final archive under normal Gatekeeper conditions; never remove quarantine or change system security settings to make it install.

Verify that the archive contains only app/CLI distribution payloads. User stores, account credentials, private inventories, backups and test evidence must never enter either the archive or this public repository. Required embedded app-signing metadata may remain within the app bundle. Compute SHA-256 from the final qualified ZIP after signing/packaging; do not reuse a checksum from an unsigned validation archive.

## Installer handoff

Once the qualified private asset exists at the verified tag and filename, copy `Templates/focus-owned.rb.tmpl` to `Casks/focus-owned.rb` and replace `VERSION`, `BUILD` and `SHA256`. Review the exact URL/version/checksum together in a separate release metadata PR. Validate style, audit and tap syntax before merging; assess a standard-user install and a populated same-identity update before delivery.

The existing private GitHub release strategy reads `HOMEBREW_GITHUB_API_TOKEN` at download time. Authorized users need read access to `T-Py-T/FocusOwned`; public tap access alone does not grant private asset access. Use the existing approved credential context without storing credentials in the cask, repository or logs.

The cask installs one stable `Focus Owned.app` path and links the CLI. Its app identity preserves the existing app-owned `default.store`, journals, selected pins and backups. It has no `zap`, user-data cleanup, quarantine bypass or runtime hooks. Quit the app before an explicit upgrade; do not automatically restart it.

Future commands after the cask is released:

```sh
brew install --cask T-Py-T/tap/focus-owned
brew update
brew upgrade --cask T-Py-T/tap/focus-owned
```

`brew update` refreshes package metadata; `brew upgrade --cask` replaces the installed artifacts. These commands are documentation, not actions taken by this draft. A public tap is the accepted existing design; private taps are also technically usable with authorized access.

## Draft validation

The pull-request workflow checks the exact PR head with the existing tap syntax gate and Ruby syntax for the template. No release downloads or private Focus Owned credentials are required for those checks. A syntax pass does not prove signing, notarization, installation, update preservation or physical synchronization.
