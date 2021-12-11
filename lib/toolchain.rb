# frozen_string_literal: true

class Toolchain < Formula
  DEFCONFIG = <<~EOF
    <%= defconfig %>
    CT_BINUTILS_GOLD_THREADS=y
    CT_BINUTILS_LD_WRAPPER=y
    CT_BINUTILS_LINKER_LD_GOLD=y
    CT_BINUTILS_PLUGINS=y
    CT_BINUTILS_V_2_37=y
    CT_CC_GCC_BUILD_ID=y
    CT_CC_LANG_CXX=y
    CT_CONFIG_VERSION="3"
    #TODO: remove
    CT_DEBUG_CT=y
    CT_DEBUG_CT_SAVE_STEPS=y
    CT_EXPERIMENTAL=y
    CT_FORBID_DOWNLOAD=y
    CT_GCC_V_11=y
    CT_GETTEXT_V_0_21=y
    CT_GLIBC_V_2_32=y
    CT_GMP_V_6_2=y
    CT_ISL_V_0_24=y
    CT_KERNEL_LINUX=y
    CT_LIBC_GLIBC=y
    CT_LIBICONV_V_1_16=y
    CT_LINUX_V_4_15=y
    CT_LOCAL_TARBALLS_DIR="<%= buildpath %>/tarballs"
    CT_MPC_V_1_2=y
    CT_MPFR_V_4_1=y
    CT_NCURSES_V_6_2=y
    CT_PREFIX_DIR="<%= buildpath %>/mnt/install"
  EOF

  delegate defconfig: :"self.class"

  desc "Appease RuboCop; not used"
  homepage "https://see.above"

  class << self
    attr_rw :defconfig

    def inherited(formula)
      super
      formula.class_eval do
        version "0.1.0"
        homepage "https://github.com/benesch/homebrew-crosstools"
        license ""

        # This disk image was created with the following command:
        #
        #     hdiutil create -type SPARSE -size 100g -fs "Case-sensitive APFS" build
        #
        # The image can't be created on the fly in the sandbox due to
        # permissions errors.
        url "file:///#{HOMEBREW_LIBRARY}/Taps/benesch/homebrew-crosstools/build.sparseimage"
        sha256 "fad43b4aafd01eea47d87af46c37353d7b62eaec9f85a2236be5455807c5730a"

        depends_on "autoconf" => :build
        depends_on "crosstool-ng" => :build
        depends_on "gawk" => :build
        depends_on "xz" => :build

        resource "binutils" do
          url "https://ftp.gnu.org/pub/gnu/binutils/binutils-2.37.tar.xz"
          sha256 "820d9724f020a3e69cb337893a0b63c2db161dadcb0e06fc11dc29eb1e84a32c"
        end

        resource "gcc" do
          url "https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz"
          sha256 "d08edc536b54c372a1010ff6619dd274c0f1603aa49212ba20f7aa2cda36fa8b"
        end

        resource "gettext" do
          url "https://ftp.gnu.org/pub/gnu/gettext/gettext-0.21.tar.xz"
          sha256 "d20fcbb537e02dcf1383197ba05bd0734ef7bf5db06bdb241eb69b7d16b73192"
        end

        resource "glibc" do
          url "https://ftp.gnu.org/pub/gnu/glibc/glibc-2.32.tar.xz"
          sha256 "1627ea54f5a1a8467032563393e0901077626dc66f37f10ee6363bb722222836"
        end

        resource "gmp" do
          url "https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz"
          sha256 "fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2"
        end

        resource "isl" do
          url "https://libisl.sourceforge.io/isl-0.24.tar.xz"
          sha256 "043105cc544f416b48736fff8caf077fb0663a717d06b1113f16e391ac99ebad"
        end

        resource "libiconv" do
          url "https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.16.tar.gz"
          sha256 "e6a1b1b589654277ee790cce3734f07876ac4ccfaecbee8afa0b649cf529cc04"
        end

        resource "linux" do
          url "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.15.18.tar.xz"
          sha256 "3f89cd717e0d497ba4818e145a33002f4c15032e355c1ad6d3d7f31f122caf41"
        end

        resource "mpc" do
          url "http://www.multiprecision.org/downloads/mpc-1.2.0.tar.gz"
          sha256 "e90f2d99553a9c19911abdb4305bf8217106a957e3994436428572c8dfe8fda6"
        end

        resource "mpfr" do
          url "https://www.mpfr.org/mpfr-4.1.0/mpfr-4.1.0.tar.xz"
          sha256 "0c98a3f1732ff6ca4ea690552079da9c597872d30e96ec28414ee23c95558a7f"
        end

        resource "ncurses" do
          url "https://invisible-mirror.net/archives/ncurses/ncurses-6.2.tar.gz"
          sha256 "30306e0c76e0f9f1f0de987cf1c82a5c21e1ce6568b9227f7da5b71cbea86c9d"
        end

        resource "zlib" do
          url "https://downloads.sourceforge.net/projects/libpng/files/zlib/1.2.11/zlib-1.2.11.tar.xz"
          sha256 "4ff941449631ace0d4d203e3483be9dbc9da454084111f97ea0a2114e19bf066"
        end

        def install
          mkdir buildpath/"tarballs" do
            resources.each do |resource|
              cp resource.cached_download, resource.downloader.basename
            end
          end

          system "hdiutil", "attach", "build.sparseimage", "-mountpoint", "mnt"

          mkdir "mnt/build" do
            Pathname.new("defconfig").write(ERB.new(DEFCONFIG).result(binding))
            ENV.delete "CC"
            ENV.delete "CXX"
            system "ct-ng", "defconfig"
            system "ct-ng", "build"
          end

          cp_r "mnt/install/.", prefix
        end
      end
    end
  end
end
