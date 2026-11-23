class Annorex < Formula
  desc "Annotate the output of a coding agent in Rex and send the notes back."
  homepage "https://github.com/devararishivian/annorex"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devararishivian/annorex/releases/download/v0.5.0/annorex-aarch64-apple-darwin.tar.xz"
      sha256 "43f155e0c77204ebf5c6af8bdcd02d96727698278195c43ab81360baf5950136"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devararishivian/annorex/releases/download/v0.5.0/annorex-x86_64-apple-darwin.tar.xz"
      sha256 "09fc206f12f660fb1473861b66e4a67b6d7435d4c1d485e6037ef2713c374ba8"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
  }.freeze

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
      bin.install "annorex"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "annorex"
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
