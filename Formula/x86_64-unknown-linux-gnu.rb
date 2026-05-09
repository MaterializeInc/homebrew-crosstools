# frozen_string_literal: true

require_relative "../lib/toolchain"

class X8664UnknownLinuxGnu < Toolchain
  desc "x86_64 Linux GNU toolchain"
  version "0.1.0"

  bottle do
    root_url "https://github.com/MaterializeInc/homebrew-crosstools/releases/download/x86_64-unknown-linux-gnu-0.1.0"
    sha256 cellar: :any, arm64_big_sur: "bb23a1e08218c0acdfe8701c0a0aea5a76adb010610c941976a0368939debbd4"
    sha256 cellar: :any, catalina:      "8290d01510eb2a1bb8c6f4c97e88ad73e1536ffb9b3e0eb2417b25cb294d114d"
  end

  defconfig <<~EOS
    CT_ARCH_64=y
    CT_ARCH_X86=y
  EOS
  glibc_version "2.12.1"
  linux_version "2.6.32"

  def test_signature(sig)
    assert_match "ELF 64-bit LSB executable, x86-64, version 1 (SYSV)", sig
    assert_match "GNU/Linux 2.6.32", sig
  end
end
