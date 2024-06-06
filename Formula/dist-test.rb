class DistTest < Formula
  desc "Repository for cargo-dist action test"
  homepage "https://github.com/agentjhonny/dist-test"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agentjhonny/dist-test/releases/download/0.1.1/dist-test-aarch64-apple-darwin.tar.xz"
      sha256 "f95860a6d766ffb5521a7cb27b8e86481dc15220514110428996ee360046c2ef"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/agentjhonny/dist-test/releases/download/0.1.1/dist-test-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cce47915f144225e5583a423bf97eab9e59cb730ea149b72a3208489a92289e7"
    end
  end

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "dist-test"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dist-test"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
