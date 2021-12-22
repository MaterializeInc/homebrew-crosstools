# homebrew-crosstools

A collection of bottled cross-compiling toolchains for macOS.

The idea is derived from [SergioBenitez/homebrew-osxct], but the toolchains
here are newer and automatically bottled by CI.

## Installation

With [Homebrew] installed, run:

```
brew install MaterializeInc/crosstools/<toolchain>
```

## Available toolchains

Target                        | Binutils | GCC     | Kernel   | Glibc
------------------------------|----------|---------|----------|-------
[`x86_64-unknown-linux-gnu`]  | 2.37     | 11.2.0  | 2.6.32   | 2.12.1


## Contributing

PRs that add additional toolchains are encouraged! Use one of the existing
toolchain files as a guide.

[`x86_64-unknown-linux-gnu`]: Formula/x86_64-unknown-linux-gnu.rb
[Homebrew]: https://brew.sh
[SergioBenitez/homebrew-osxct]: https://github.com/SergioBenitez/homebrew-osxct
