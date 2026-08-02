# frozen_string_literal: true

cask "mac-ogcs" do
  arch arm: "499247898", intel: "499247894"

  version "0.1.0-alpha.4"
  sha256 arm:   "cba9b9a826ce43a553858d8cf424d41b1e3e4d9776b6f5f58f85facf4d6b2d1b",
         intel: "e94b814e594bd2adcf4607d604947d25ec51d9d00219a52a351d2a181a5695e8"

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
    persistent recurring schedule, or g for Google colour settings.

    The build is checksummed but not Developer ID notarized. This Cask preserves
    normal macOS quarantine metadata and does not bypass Gatekeeper. Maintainer
    testing may use Privacy & Security > Allow Anyway for this exact binary.
  EOS
end
