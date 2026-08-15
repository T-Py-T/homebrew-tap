class Atomic < Formula
  desc "Verifiable coding agent runtime"
  homepage "https://github.com/bastani-inc/atomic"
  url "https://registry.npmjs.org/@bastani/atomic/-/atomic-0.9.13.tgz"
  sha256 "43f26237192831a08de7d47e124220cc8c8e7eb0a550573c04a32a94e98b3c57"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    fix_embedded_postgres_links
    bin.install_symlink libexec/"bin/atomic"
  end

  def fix_embedded_postgres_links
    return unless OS.mac?

    native_dirs = Dir[libexec/"lib/node_modules/@bastani/atomic/node_modules/@embedded-postgres/*/native"]
    native_dirs.each do |native_dir|
      Dir["#{native_dir}/**/*"].select { |path| File.file?(path) }.each do |path|
        id_output = Utils.safe_popen_read("/usr/bin/otool", "-D", path)
        id_path = id_output.lines.drop(1).map(&:strip).find { |line| line.start_with?("/Library/PostgreSQL/18/lib/") }
        if id_path
          system "/usr/bin/install_name_tool", "-id", "@loader_path/#{File.basename(id_path)}", path
        end

        output = Utils.safe_popen_read("/usr/bin/otool", "-L", path)
        output.lines.grep(%r{^\s+/Library/PostgreSQL/18/lib/}).each do |line|
          old_path = line.strip.split.first
          new_path = "@loader_path/#{File.basename(old_path)}"
          system "/usr/bin/install_name_tool", "-change", old_path, new_path, path
        end
      end

      architecture = Pathname(native_dir).parent.basename.to_s
      destination = var/"atomic"/version/architecture/"native"
      destination.parent.mkpath
      rm_r destination if destination.exist?
      mv native_dir, destination
      ln_s destination, native_dir
    end
  end

  test do
    assert_match "atomic", shell_output("#{bin}/atomic --help")
  end
end
