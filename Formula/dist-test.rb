class DistTest < Formula
  desc "Repository for cargo-dist action test"
  homepage "https://github.com/agentjhonny/dist-test"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agentjhonny/dist-test/releases/download/0.1.0/dist-test-aarch64-apple-darwin.tar.xz"
      sha256 "2f8ab6bcfaccb87e5225afa42c796732cb7b86506d26ee4aff9b86d76694dbfa"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/agentjhonny/dist-test/releases/download/0.1.0/dist-test-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d9327605da057e910a9db9635e47aa05bd710f7f4e86c471d30237ed8c6df505"
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
