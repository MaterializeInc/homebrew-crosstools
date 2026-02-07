# frozen_string_literal: true

class LibfdbCAarch64UnknownLinuxGnu < Formula
  desc "FoundationDB C client library (aarch64-unknown-linux-gnu)"
  homepage "https://github.com/apple/foundationdb"
  version "7.3.71"
  license "Apache-2.0"

  url "https://github.com/apple/foundationdb/releases/download/7.3.71/libfdb_c.aarch64.so"
  sha256 "8cd372dbb0fec23bf50b96e6251d6db6bc3c473afc6e1f781c35e10976e2805d"

  keg_only "Linux shared library, not compatible with macOS"

  def install
    lib.install "libfdb_c.aarch64.so" => "libfdb_c.so"
  end

  test do
    assert_predicate lib/"libfdb_c.so", :exist?
  end
end
