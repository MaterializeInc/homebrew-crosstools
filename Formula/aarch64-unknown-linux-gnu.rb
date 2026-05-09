# frozen_string_literal: true

require_relative "../lib/toolchain"

class Aarch64UnknownLinuxGnu < Toolchain
  desc "aarch64 Linux GNU toolchain"
  version "0.1.0"

  bottle do
    root_url "https://github.com/MaterializeInc/homebrew-crosstools/releases/download/aarch64-unknown-linux-gnu-0.1.0"
    sha256 cellar: :any, arm64_big_sur: "e9a7883db4e4bca222dacfe6576b46318ebe949f4352aa061c8b5e80d6479bea"
    sha256 cellar: :any, catalina:      "b9128e88b58f1afb20092c9478c7fc3d9daf935baeda344a8eae18f01231db4f"
  end

  defconfig <<~EOS
    CT_ARCH_64=y
    CT_ARCH_ARM=y
  EOS
  glibc_version "2.26"
  linux_version "3.10"

  def test_signature(sig)
    assert_match "ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV)", sig
    assert_match "GNU/Linux 3.10.108", sig
  end
end
