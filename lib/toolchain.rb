# frozen_string_literal: true

TAP_PATH = (HOMEBREW_TAP_DIRECTORY/"def-"/"homebrew-crosstools").freeze

class Toolchain < Formula
  desc "Appease RuboCop; not used"
  homepage "https://see.above"

  DEFCONFIG = <<~EOF
    <%= defconfig %>
    CT_ALLOW_BUILD_AS_ROOT=y
    CT_ALLOW_BUILD_AS_ROOT_SURE=y
    CT_ARCH_ARM=y
    CT_ARCH_64=y
    CT_BINUTILS_LINKER_LD_GOLD=y
    CT_BINUTILS_GOLD_THREADS=y
    CT_BINUTILS_LD_WRAPPER=y
    CT_BINUTILS_PLUGINS=y
    CT_CC_GCC_BUILD_ID=y
    CT_CC_LANG_CXX=y
    # CT_COMP_TOOLS_AUTOCONF is not set
    # CT_COMP_TOOLS_AUTOMAKE is not set
    CT_CONFIG_VERSION="3"
    <% if Context.current.debug? %>
    CT_DEBUG_CT=y
    CT_DEBUG_CT_SAVE_STEPS=y
    <% end %>
    CT_EXPERIMENTAL=y
    CT_GLIBC_V_2_35=y
    CT_KERNEL_LINUX=y
    CT_LIBC_GLIBC=y
    CT_LINUX_V_5_10=y
    CT_LOCAL_TARBALLS_DIR="<%= buildpath %>/tarballs"
    CT_LOCAL_PATCH_DIR="<%= buildpath %>/patches"
    # CT_LOG_PROGRESS_BAR is not set
    # CT_LOG_TO_FILE is not set
    CT_PATCH_ORDER="bundled,local"
    CT_PATCH_BUNDLED_LOCAL=y
    CT_PATCH_USE_LOCAL=y
    CT_PREFIX_DIR="<%= buildpath %>/mnt/install"
    CT_PREFIX_DIR="${CT_PREFIX:-/opt/x-tools}/${CT_HOST:+HOST-${CT_HOST}/}${CT_TARGET}"
    # CT_SAVE_TARBALLS is not set
  EOF

  delegate defconfig: :"self.class"

  class << self
    attr_rw :defconfig

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
      depends_on "zstd"

      resource "binutils" do
        url "https://ftp.gnu.org/pub/gnu/binutils/binutils-2.40.tar.xz"
        sha256 "0f8a4c272d7f17f369ded10a4aca28b8e304828e95526da482b0ccc4dfc9d8e1"
      end

      resource "gcc" do
        url "https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
        sha256 "e275e76442a6067341a27f04c5c6b83d8613144004c0413528863dc6b5c743da"
      end

      resource "gettext" do
        url "https://ftp.gnu.org/pub/gnu/gettext/gettext-0.21.tar.xz"
        sha256 "d20fcbb537e02dcf1383197ba05bd0734ef7bf5db06bdb241eb69b7d16b73192"
      end

      resource "glibc" do
        url "https://ftp.gnu.org/pub/gnu/glibc/glibc-2.35.tar.xz"
        sha256 "5123732f6b67ccd319305efd399971d58592122bcc2a6518a1bd2510dd0cf52e"
      end

      resource "gmp" do
        url "https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz"
        sha256 "fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2"
      end

      resource "isl" do
        url "https://libisl.sourceforge.io/isl-0.26.tar.xz"
        sha256 "a0b5cb06d24f9fa9e77b55fabbe9a3c94a336190345c2555f9915bb38e976504"
      end

      resource "libiconv" do
        url "https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.16.tar.gz"
        sha256 "e6a1b1b589654277ee790cce3734f07876ac4ccfaecbee8afa0b649cf529cc04"
      end

      resource "linux" do
        url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.10.185.tar.xz"
        sha256 "280662ec8dc8738cf947ad66e748141abd58cbe3b5ed66b7f2b153222b7c7090"
      end

      resource "mpc" do
        url "https://www.multiprecision.org/downloads/mpc-1.2.1.tar.gz"
        sha256 "17503d2c395dfcf106b622dc142683c1199431d095367c6aacba6eec30340459"
      end

      resource "mpfr" do
        url "https://www.mpfr.org/mpfr-4.2.1/mpfr-4.2.1.tar.xz"
        sha256 "277807353a6726978996945af13e52829e3abd7a9a5b7fb2793894e18f1fcbb2"
      end

      resource "ncurses" do
        url "https://invisible-mirror.net/archives/ncurses/ncurses-6.4.tar.gz"
        sha256 "6931283d9ac87c5073f30b6290c4c75f21632bb4fc3603ac8100812bed248159"
      end

      resource "zlib" do
        url "https://github.com/madler/zlib/releases/download/v1.2.13/zlib-1.2.13.tar.xz"
        sha256 "d14c38e313afc35a9a8760dadf26042f51ea0f5d154b0630a31da0540107fb98"
      end

      resource "zstd" do
        url "https://github.com/facebook/zstd/releases/download/v1.5.5/zstd-1.5.5.tar.gz"
        sha256 "9c4396cc829cfae319a6e2615202e82aad41372073482fce286fac78646d3ee4"
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
    mkdir "mnt/install/bin"

    cp_r "mnt/install/.", prefix
  end

  test do
    (testpath/"test.c").write("int main() { return 0; }")
    system bin/"#{name}-cc", "test.c"
    test_signature shell_output("file a.out")
  end
end
