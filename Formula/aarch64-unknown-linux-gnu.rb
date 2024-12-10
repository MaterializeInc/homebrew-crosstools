# frozen_string_literal: true

require_relative "../lib/toolchain"

class Aarch64UnknownLinuxGnu < Toolchain
  desc "aarch64 Linux GNU toolchain"
  version "0.2.0"

  bottle do
    root_url "https://github.com/MaterializeInc/homebrew-crosstools/releases/download/aarch64-unknown-linux-gnu-0.2.0"
    sha256 cellar: :any, arm64_big_sur: "TODO"
    sha256 cellar: :any, catalina:      "TODO"
  end

  defconfig <<~EOS
    CT_ARCH_64=y
    CT_ARCH_ARM=y
  EOS

  def test_signature(sig)
    assert_match "ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV)", sig
    assert_match "GNU/Linux 3.10.108", sig
  end
end
