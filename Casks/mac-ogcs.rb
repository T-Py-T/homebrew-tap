# frozen_string_literal: true

cask "mac-ogcs" do
  arch arm: "499198724", intel: "499198725"

  version "0.1.0-alpha.2"
  sha256 arm:   "1e1eb17f562c67dc2b955e5d6a0d1e7c059c7b3edde966c1e517ff6fa580f03f",
         intel: "e305e92aefccccb51889ee2b5cc1d80014a39c3403eaee5a5d51147d3d8b44ae"

  github_token = ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", nil)
  download_headers = [
    "Accept: application/octet-stream",
    "X-GitHub-Api-Version: 2026-03-10",
  ]
  download_headers << "Authorization: Bearer #{github_token}" if github_token

  url "https://api.github.com/repos/T-Py-T/mac-ogcs/releases/assets/#{arch}",
      header: download_headers
  name "mac-ogcs"
  desc "Privacy-first Outlook-to-Google Calendar sync for terminals"
  homepage "https://github.com/T-Py-T/mac-ogcs"

  container type: :tar

  binary "mac-ogcs"

  caveats <<~EOS
    This private pre-release requires HOMEBREW_GITHUB_API_TOKEN when Homebrew
    downloads or upgrades it. Run `mac-ogcs` and press g for Google settings.

    The build is checksummed but not Developer ID notarized. This Cask preserves
    normal macOS quarantine metadata and does not bypass Gatekeeper.
  EOS
end
