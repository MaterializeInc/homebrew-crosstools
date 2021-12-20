# frozen_string_literal: true

require_relative "../lib/toolchain"

class X8664UnknownLinuxGnu < Toolchain
  desc "x86_64 Linux GNU toolchain"
  version "0.1.0"

  defconfig <<~EOS
    CT_ARCH_64=y
    CT_ARCH_X86=y
  EOS
  glibc_version "2.12.1"
  linux_version "2.6.32"
end
