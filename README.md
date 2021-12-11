# homebrew-crosstools

A collection of bottled cross-compiling toolchains for macOS and Linux.

The idea is derived from [SergioBenitez/homebrew-osxct], but the toolchains
here are newer and automatically bottled.

## Installation

With [Homebrew] installed, run:

```
brew install benesch/crosstools/<toolchain>
```

## Available toolchains

Target                        | Binutils | GCC     | Kernel  | Glibc
------------------------------|----------|---------|---------|-------
[`x86_64-unknown-linux-gnu`]  | 2.37     | 11.2.0  | 4.15.18 | 2.32
[`aarch64-unknown-linux-gnu`] | 2.37     | 11.2.0  | 4.15.18 | 2.32

## Contributing

PRs that add additional toolchains are encouraged! Use one of the existing
toolchain files as a guide. You'll need to supply a `defconfig` block

[`aarch64-unknown-linux-gnu`]: Formula/aarch64-unknown-linux-gnu.rb
[`x86_64-unknown-linux-gnu`]: Formula/x86_64-unknown-linux-gnu.rb
[Homebrew]: https://brew.sh
[SergioBenitez/homebrew-osxct]: https://github.com/SergioBenitez/homebrew-osxct
