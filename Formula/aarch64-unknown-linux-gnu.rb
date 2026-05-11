# frozen_string_literal: true

require_relative "../lib/toolchain"

class Aarch64UnknownLinuxGnu < Toolchain
  desc "aarch64 Linux GNU toolchain"
  version "0.2.0"

  bottle do
    root_url "https://github.com/MaterializeInc/homebrew-crosstools/releases/download/aarch64-unknown-linux-gnu-0.2.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dc7ae811c37881c0a441029104eed0a07e5f81270c66c7c26a44442d01542ea"
  end

  defconfig <<~EOS
    CT_ARCH_ARM=y
    CT_ARCH_64=y
  EOS

  def test_signature(sig)
    assert_match "ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV)", sig
    assert_match "GNU/Linux 5.10.240", sig
  end
end
