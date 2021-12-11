# frozen_string_literal: true

require_relative "../lib/toolchain"

class X8664UnknownLinuxGnu < Toolchain
  desc "x86_64 Linux GNU toolchain"
  defconfig <<~EOS
    CT_ARCH_64=y
    CT_ARCH_X86=y
  EOS
end
