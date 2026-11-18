class Annorex < Formula
  desc "Annotate the output of a coding agent in Rex and send the notes back."
  homepage "https://github.com/devararishivian/annorex"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devararishivian/annorex/releases/download/v0.2.3/annorex-aarch64-apple-darwin.tar.xz"
      sha256 "8ff35c3f6843d2391dfe55eedcee64f916a9c23108a507aa7e3dadfdecd3c6e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devararishivian/annorex/releases/download/v0.2.3/annorex-x86_64-apple-darwin.tar.xz"
      sha256 "84bbe3d2f1a6a86fbc83b22851185221087ea8253d54e1f62cff33a6e18ddead"
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
