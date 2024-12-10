# frozen_string_literal: true

require_relative "../lib/toolchain"

class X8664UnknownLinuxGnu < Toolchain
  desc "x86_64 Linux GNU toolchain"
  version "0.2.0"

  defconfig <<~EOS
    CT_ARCH_64=y
    CT_ARCH_X86=y
  EOS

  def test_signature(sig)
    assert_match "ELF 64-bit LSB executable, x86-64, version 1 (SYSV)", sig
    assert_match "GNU/Linux 2.6.32", sig
  end
end
