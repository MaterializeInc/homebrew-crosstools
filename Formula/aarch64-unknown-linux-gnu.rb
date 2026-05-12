# frozen_string_literal: true

require_relative "../lib/toolchain"

class Aarch64UnknownLinuxGnu < Toolchain
  desc "aarch64 Linux GNU toolchain"
  version "0.2.1"

  bottle do
    root_url "https://github.com/MaterializeInc/homebrew-crosstools/releases/download/aarch64-unknown-linux-gnu-0.2.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7733624805dd4b5c9911ba6178d1d2ed3a6e049674d885000f9826cd75087c2d"
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
