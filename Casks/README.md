# Casks

Place prebuilt terminal tools and macOS applications here after their release archives, versions, and SHA-256 checksums exist.

The Berea Mac app template is `Templates/berea.rb.tmpl` until that release exists.

For terminal-only tools, use a Cask `binary` artifact. Do not remove `com.apple.quarantine` in `preflight` or `postflight`; sign and notarize release artifacts instead.
