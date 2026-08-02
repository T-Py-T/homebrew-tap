# frozen_string_literal: true

cask "mac-ogcs" do
  arch arm: "499220988", intel: "499220990"

  version "0.1.0-alpha.3"
  sha256 arm:   "ec565e1deb7621088d868010fa9baebc5fd0e4670f65b9096b17a6dde147a922",
         intel: "82e61beed16d918a239cf06c12db0d96e69647dae7f3d4e7d0203917b40968e6"

  github_token = ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", nil)
  download_headers = [
    "Accept: application/octet-stream",
    "X-GitHub-Api-Version: 2026-03-10",
  ]
  download_headers << "Authorization: Bearer #{github_token}" if github_token

  url "https://api.github.com/repos/T-Py-T/mac-ogcs/releases/assets/#{arch}?version=#{version}",
      header: download_headers
  name "mac-ogcs"
  desc "Privacy-first Outlook-to-Google Calendar sync for terminals"
  homepage "https://github.com/T-Py-T/mac-ogcs"

  depends_on :macos
  container type: :tar

  binary "mac-ogcs"

  caveats <<~EOS
    This private pre-release requires HOMEBREW_GITHUB_API_TOKEN when Homebrew
    downloads or upgrades it. Run `mac-ogcs` and press g for Google settings;
    the Colour row contains 24 presets and exact #RRGGBB entry.

    The build is checksummed but not Developer ID notarized. This Cask preserves
    normal macOS quarantine metadata and does not bypass Gatekeeper. Maintainer
    testing may use Privacy & Security > Allow Anyway for this exact binary.
  EOS
end
