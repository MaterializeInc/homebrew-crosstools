# frozen_string_literal: true

TAP_PATH = Pathname.new(__dir__).parent.realpath.freeze

class Toolchain < Formula
  desc "Appease RuboCop; not used"
  homepage "https://see.above"

  DEFCONFIG = <<~EOF
    <%= defconfig %>
    CT_ALLOW_BUILD_AS_ROOT=y
    CT_ALLOW_BUILD_AS_ROOT_SURE=y
    CT_BINUTILS_LINKER_LD_GOLD=y
    CT_BINUTILS_GOLD_THREADS=y
    CT_BINUTILS_LD_WRAPPER=y
    CT_BINUTILS_PLUGINS=y
    CT_BINUTILS_V_2_45=y
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
    CT_GCC_V_15=y
    CT_GLIBC_V_2_35=y
    CT_KERNEL_LINUX=y
    CT_LIBC_GLIBC=y
    CT_LINUX_V_5_10=y
    CT_LOCAL_TARBALLS_DIR="<%= buildpath %>/tarballs"
    CT_LOCAL_PATCH_DIR="<%= buildpath %>/patches"
    # CT_LOG_PROGRESS_BAR is not set
    CT_LOG_TO_FILE=y
    # CT_LOG_FILE_COMPRESS is not set
    CT_NCURSES_PATCH_LOCAL=y
    CT_PATCH_ORDER="bundled,local"
    CT_PATCH_BUNDLED_LOCAL=y
    CT_PATCH_USE_LOCAL=y
    CT_PREFIX_DIR="<%= buildpath %>/mnt/install"
    # CT_SAVE_TARBALLS is not set
  EOF

  delegate defconfig: :"self.class"

  class << self
    sig { params(val: String).returns(T.nilable(String)) }
    def defconfig(val = T.unsafe(nil))
      val.nil? ? @defconfig : @defconfig= T.let(val, T.nilable(String))
    end

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
        url "https://mirror.team-cymru.com/gnu/binutils/binutils-2.45.tar.xz"
        mirror "https://ftpmirror.gnu.org/binutils/binutils-2.45.tar.xz"
        sha256 "c50c0e7f9cb188980e2cc97e4537626b1672441815587f1eab69d2a1bfbef5d2"
      end

      resource "gcc" do
        url "https://mirror.team-cymru.com/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
        mirror "https://ftpmirror.gnu.org/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
        sha256 "438fd996826b0c82485a29da03a72d71d6e3541a83ec702df4271f6fe025d24e"
      end

      resource "gettext" do
        url "https://mirror.team-cymru.com/gnu/gettext/gettext-0.26.tar.xz"
        mirror "https://ftpmirror.gnu.org/gettext/gettext-0.26.tar.xz"
        sha256 "d1fb86e260cfe7da6031f94d2e44c0da55903dbae0a2fa0fae78c91ae1b56f00"
      end

      resource "glibc" do
        url "https://mirror.team-cymru.com/gnu/glibc/glibc-2.35.tar.xz"
        mirror "https://ftpmirror.gnu.org/glibc/glibc-2.35.tar.xz"
        sha256 "5123732f6b67ccd319305efd399971d58592122bcc2a6518a1bd2510dd0cf52e"
      end

      resource "gmp" do
        url "https://mirror.team-cymru.com/gnu/gmp/gmp-6.3.0.tar.xz"
        mirror "https://ftpmirror.gnu.org/gmp/gmp-6.3.0.tar.xz"
        sha256 "a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898"
      end

      resource "isl" do
        url "https://libisl.sourceforge.io/isl-0.27.tar.xz"
        sha256 "6d8babb59e7b672e8cb7870e874f3f7b813b6e00e6af3f8b04f7579965643d5c"
      end

      resource "libiconv" do
        url "https://mirror.team-cymru.com/gnu/libiconv/libiconv-1.18.tar.gz"
        mirror "https://ftpmirror.gnu.org/libiconv/libiconv-1.18.tar.gz"
        sha256 "3b08f5f4f9b4eb82f151a7040bfd6fe6c6fb922efe4b1659c66ea933276965e8"
      end

      resource "linux" do
        url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.10.240.tar.xz"
        sha256 "8d88c3977226d666554b75f480d1e6c5f4e4d2acdf2a3462840c6bac88634d13"
      end

      resource "mpc" do
        url "https://www.multiprecision.org/downloads/mpc-1.3.1.tar.gz"
        sha256 "ab642492f5cf882b74aa0cb730cd410a81edcdbec895183ce930e706c1c759b8"
      end

      resource "mpfr" do
        url "https://www.mpfr.org/mpfr-4.2.2/mpfr-4.2.2.tar.xz"
        sha256 "b67ba0383ef7e8a8563734e2e889ef5ec3c3b898a01d00fa0a6869ad81c6ce01"
      end

      resource "ncurses" do
        url "https://invisible-mirror.net/archives/ncurses/ncurses-6.5.tar.gz"
        sha256 "136d91bc269a9a5785e5f9e980bc76ab57428f604ce3e5a5a90cebc767971cc6"
      end

      resource "zlib" do
        url "https://github.com/madler/zlib/releases/download/v1.3.1/zlib-1.3.1.tar.xz"
        sha256 "38ef96b8dfe510d42707d9c781877914792541133e1870841463bfa73f883e32"
      end

      resource "zstd" do
        url "https://github.com/facebook/zstd/releases/download/v1.5.7/zstd-1.5.7.tar.gz"
        sha256 "eb33e51f49a15e023950cd7825ca74a4a2b43db8354825ac24fc1b7ee09e6fa3"
      end
    end
  end

  def install
    mkdir buildpath/"tarballs" do
      resources.each do |resource|
        cp resource.cached_download, resource.downloader.basename
      end
    end

    mkdir buildpath/"patches"
    cp_r "#{TAP_PATH}/patches/.", buildpath/"patches" if (TAP_PATH/"patches").directory?

    # The sparseimage is a case-sensitive APFS volume — required by
    # ct-ng (it asserts the build dir is case-sensitive at startup) and
    # for the final install dir (Linux kernel headers collide on
    # case-insensitive FS). Mount with ownership disabled.
    system "hdiutil", "attach", "build.sparseimage", "-mountpoint", "mnt", "-owners", "off"

    begin
      mkdir "mnt/build" do
        Pathname.new("defconfig").write(ERB.new(DEFCONFIG).result(binding))
        ENV.delete "CC"
        ENV.delete "CXX"
        ENV.append "LDFLAGS", "-L#{MacOS.sdk_path}/usr/lib"
        system "ct-ng", "defconfig"
        begin
          system "ct-ng", "build"
        ensure
          # Preserve the ct-ng build log for debugging on failure. ct-ng
          # writes it to ${CT_TOP_DIR}/build.log (here: mnt/build) during
          # the build and only copies it to ${CT_PREFIX_DIR}/build.log on
          # success. Copy to /tmp so it survives Homebrew's cleanup.
          log = buildpath/"mnt/build/build.log"
          cp log, "/tmp/ct-ng-#{name}-build.log" if log.exist?
        end
      end

      # Remove the few files that conflict on case-sensitive filesystems.
      # This is suspect logic, but these are netfilter headers that are
      # perhaps not that commonly referenced. I think other cross-compiling
      # toolchains on macOS just throw tar at the problem, which blindly
      # chooses one of the casing options when untarring.
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
      rm_f "mnt/install/build.log"
      rm_f "mnt/install/build.log.bz2"

      chmod_R "+w", "mnt/install/share"
      rm_r "mnt/install/share"

      chmod "+w", "mnt/install/lib"
      chmod_R "+w", "mnt/install/lib/bfd-plugins"
      rm_r "mnt/install/lib/bfd-plugins"
      rm ["mnt/install/lib/libcc1.so", "mnt/install/lib/libcc1.0.so"]
      chmod "-w", "mnt/install/lib"
      mkdir "mnt/install/bin"

      cp_r "mnt/install/.", prefix
    ensure
      # Detach the sparseimage. Best-effort.
      system "hdiutil", "detach", "#{buildpath}/mnt"
    end
  end

  test do
    (testpath/"test.c").write("int main() { return 0; }")
    system bin/"#{name}-cc", "test.c"
    test_signature shell_output("file a.out")
  end
end
