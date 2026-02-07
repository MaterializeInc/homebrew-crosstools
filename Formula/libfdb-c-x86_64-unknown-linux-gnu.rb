# frozen_string_literal: true

class LibfdbCX8664UnknownLinuxGnu < Formula
  desc "FoundationDB C client library (x86_64-unknown-linux-gnu)"
  homepage "https://github.com/apple/foundationdb"
  version "7.3.71"
  license "Apache-2.0"

  url "https://github.com/apple/foundationdb/releases/download/7.3.71/libfdb_c.x86_64.so"
  sha256 "be81e795db88e5ab4c51bffbba1dc0ca9f517bb1b9acac7d7bcd539536ed537a"

  keg_only "Linux shared library, not compatible with macOS"

  def install
    lib.install "libfdb_c.x86_64.so" => "libfdb_c.so"
  end

  test do
    assert_predicate lib/"libfdb_c.so", :exist?
  end
end
