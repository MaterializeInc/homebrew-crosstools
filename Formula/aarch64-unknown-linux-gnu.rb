# frozen_string_literal: true

require_relative "../lib/toolchain"

class Aarch64UnknownLinuxGnu < Toolchain
  desc "aarch64 Linux GNU toolchain"
  defconfig <<~EOS
    CT_ARCH_64=y
    CT_ARCH_ARM=y
  EOS
end
