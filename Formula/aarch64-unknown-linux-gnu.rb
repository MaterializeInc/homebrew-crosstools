# frozen_string_literal: true

require_relative "../lib/toolchain"

class Aarch64UnknownLinuxGnu < Toolchain
  desc "aarch64 Linux GNU toolchain"
  version "0.2.0"

  defconfig <<~EOS
    CT_ARCH_ARM=y
    CT_ARCH_64=y
  EOS

  def test_signature(sig)
    assert_match "ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV)", sig
    assert_match "GNU/Linux 5.10.240", sig
  end
end
