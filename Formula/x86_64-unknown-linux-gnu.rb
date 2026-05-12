# frozen_string_literal: true

require_relative "../lib/toolchain"

class X8664UnknownLinuxGnu < Toolchain
  desc "x86_64 Linux GNU toolchain"
  version "0.2.1"

  bottle do
    root_url "https://github.com/MaterializeInc/homebrew-crosstools/releases/download/x86_64-unknown-linux-gnu-0.2.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65e9d7b24e9584def1f5c2c4c689257fb358570680647bc292616bf9bd28998c"
  end

  defconfig <<~EOS
    CT_ARCH_X86=y
    CT_ARCH_64=y
  EOS

  def test_signature(sig)
    assert_match "ELF 64-bit LSB executable, x86-64, version 1 (SYSV)", sig
    assert_match "GNU/Linux 5.10.240", sig
  end
end
