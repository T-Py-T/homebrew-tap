# frozen_string_literal: true

require "download_strategy"

# Downloads versioned mac-ogcs assets from its private GitHub repository.
class MacOgcsPrivateRepositoryReleaseDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    @url = url
    parse_url_pattern
    set_github_token
    meta[:headers] ||= []
    meta[:headers] << "Accept: application/octet-stream"
    meta[:headers] << "Authorization: Bearer #{@github_token}"
    super(asset_api_url, name, version, **meta)
  end

  def download_url
    "https://#{@github_token}@api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}"
  end

  private

  def parse_url_pattern
    pattern = %r{https://github.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)}
    match = @url.match(pattern)
    raise CurlDownloadStrategyError, "Invalid private GitHub release URL" unless match

    @owner, @repo, @tag, @filename = match.captures
  end

  def set_github_token
    @github_token = ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", nil)
    raise CurlDownloadStrategyError, "HOMEBREW_GITHUB_API_TOKEN is required" unless @github_token

    GitHub.repository(@owner, @repo)
  end

  def asset_id
    return @asset_id if @asset_id

    asset = GitHub.get_release(@owner, @repo, @tag)["assets"]
                  .find { |candidate| candidate["name"] == @filename }
    raise CurlDownloadStrategyError, "Release asset not found" unless asset

    @asset_id = asset.fetch("id")
  end

  def asset_api_url
    "https://api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}"
  end
end
