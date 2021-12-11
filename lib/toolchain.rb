# frozen_string_literal: true

TAP_PATH = (Tap::TAP_DIRECTORY/"MaterializeInc"/"homebrew-crosstools").freeze

class Toolchain < Formula
  desc "Appease RuboCop; not used"
  homepage "https://see.above"

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
    CT_EXPERIMENTAL=y
    CT_FORBID_DOWNLOAD=y
    CT_GCC_V_11=y
    CT_GETTEXT_V_0_21=y
    CT_GLIBC_V_<%= glibc_version.gsub(".", "_") %>=y
    # CT_GLIBC_ENABLE_OBSOLETE_RPC is not set
    CT_GMP_V_6_2=y
    CT_ISL_V_0_24=y
    CT_KERNEL_LINUX=y
    CT_LIBC_GLIBC=yCT_DEBUG_CT=y
    CT_LIBICONV_V_1_16=y
    CT_LINUX_V_<%= linux_version.gsub(".", "_") %>=y
    CT_LOCAL_TARBALLS_DIR="<%= buildpath %>/tarballs"
    CT_LOCAL_PATCH_DIR="<%= buildpath %>/patches"
    # CT_LOG_PROGRESS_BAR is not set
    CT_MPC_V_1_2=y
    CT_MPFR_V_4_1=y
    CT_NCURSES_V_6_2=y
    CT_PATCH_BUNDLED_LOCAL=y
    CT_PREFIX_DIR="<%= buildpath %>/mnt/install"
    <% if Context.current.debug? %>
    CT_DEBUG_CT=y
    CT_DEBUG_CT_SAVE_STEPS=y
    <% end %>
  EOF

  delegate defconfig: :"self.class"
  delegate glibc_version: :"self.class"
  delegate linux_version: :"self.class"

  class << self
    attr_rw :defconfig
    attr_rw :glibc_version
    attr_rw :linux_version

    def inherited(formula)
      super
      TracePoint.trace(:end) do |t|
        t.disable
        formula.class_eval { inject }
      end
    end

    def inject
      homepage "https://github.com/MaterializeInc/homebrew-crosstools"
      license :cannot_represent

      # This disk image was created with the following command:
      #
      #     hdiutil create -type SPARSE -size 100g -fs "Case-sensitive APFS" build
      #
      # The image can't be created on the fly in the sandbox due to
      # permissions errors.
      url "file:///#{TAP_PATH}/build.sparseimage"
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

      case glibc_version
      when "2.12.1"
        resource "glibc" do
          url "https://ftp.gnu.org/pub/gnu/glibc/glibc-2.12.1.tar.xz"
          sha256 "9e633fb278b411a90636cc1c4bf1ffddcc8b0d214f5bacd74bfcdaac81d6035e"
        end
      when "2.26"
        resource "glibc" do
          url "https://ftp.gnu.org/pub/gnu/glibc/glibc-2.26.tar.xz"
          sha256 "e54e0a934cd2bc94429be79da5e9385898d2306b9eaf3c92d5a77af96190f6bd"
        end
      else
        raise "unsupported glibc version #{glibc_version}"
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

      case linux_version
      when "2.6.32"
        resource "linux" do
          url "https://cdn.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/linux-2.6.32.71.tar.xz"
          sha256 "60a5ffe0206a0ea8997c29ccc595aa7dae55f6cb20c7d92aab88029ca4fef598"
        end
      when "3.10"
        resource "linux" do
          url "https://cdn.kernel.org/pub/linux/kernel/v3.x/linux-3.10.108.tar.xz"
          sha256 "3849ea8119517f605f9d53c57dd6c539af8d584c2f1d9031f4f56283af3409a5"
        end
      else
        raise "unsupported linux version #{linux_version}"
      end

      resource "mpc" do
        url "https://www.multiprecision.org/downloads/mpc-1.2.0.tar.gz"
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
        url "https://downloads.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.xz"
        sha256 "4ff941449631ace0d4d203e3483be9dbc9da454084111f97ea0a2114e19bf066"
      end
    end
  end

  def install
    mkdir buildpath/"tarballs" do
      resources.each do |resource|
        cp resource.cached_download, resource.downloader.basename
      end
    end

    cp_r TAP_PATH/"patches", buildpath/"patches"

    system "hdiutil", "attach", "build.sparseimage", "-mountpoint", "mnt"

    mkdir "mnt/build" do
      Pathname.new("defconfig").write(ERB.new(DEFCONFIG).result(binding))
      ENV.delete "CC"
      ENV.delete "CXX"
      system "ct-ng", "defconfig"
      system "ct-ng", "build"
    end

    # Remove the few files that conflict on case-sensitive filesystems. This is
    # suspect logic, but these are netfilter headers that are perhaps not that
    # commonly referenced. I think other cross-compiling toolchains on macOS
    # just throw tar at the problem, which blindly chooses one of the casing
    # options when untarring.
    duplicates = Dir.glob("mnt/install/**/*")
                    .group_by(&:downcase)
                    .values
                    .filter { |paths| paths.size > 1 }
                    .flatten
    parents = duplicates.map { |path| Pathname.new(path).parent }.uniq
    chmod "+w", parents
    rm duplicates
    chmod "-w", parents

    chmod "+w", "mnt/install"
    rm "mnt/install/build.log.bz2"

    chmod_R "+w", "mnt/install/share"
    rm_r "mnt/install/share"

    chmod "+w", "mnt/install/lib"
    chmod_R "+w", "mnt/install/lib/bfd-plugins"
    rm_r "mnt/install/lib/bfd-plugins"
    rm ["mnt/install/lib/libcc1.so", "mnt/install/lib/libcc1.0.so"]
    chmod "-w", "mnt/install/lib"

    cp_r "mnt/install/.", prefix
  end

  test do
    (testpath/"test.c").write("int main() { return 0; }")
    system bin/"#{name}-cc", "test.c"
    test_signature shell_output("file a.out")
  end
end
