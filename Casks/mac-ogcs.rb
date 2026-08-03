# frozen_string_literal: true

cask "mac-ogcs" do
  arch arm: "499519946", intel: "499519944"

  version "0.1.0-alpha.8"
  sha256 arm:   "5422d3ca130c8db702988f19445336271b56c6d40407621de19a4aa1b60bddcd",
         intel: "ccea8ed8970c9356ce70c3ab33ae9dcb5a7eb8db3568b3fb6f44174b9b733e81"

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
    downloads or upgrades it. Run `mac-ogcs`; press n to Sync now, r for a
    persistent recurring schedule, or g for Google source-calendar name and
    colour settings.

    The build is checksummed but not Developer ID notarized. This Cask preserves
    normal macOS quarantine metadata and does not bypass Gatekeeper. Maintainer
    testing may use Privacy & Security > Allow Anyway for this exact binary.
  EOS
end
