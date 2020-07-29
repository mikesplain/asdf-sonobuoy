<div align="center">

# asdf-sonobuoy ![Build](https://github.com/mikesplain/asdf-sonobuoy/workflows/Build/badge.svg) ![Lint](https://github.com/mikesplain/asdf-sonobuoy/workflows/Lint/badge.svg)

[sonobuoy](https://github.com/mikesplain/asdf-sonobuoy) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add sonobuoy
# or
asdf plugin add https://github.com/mikesplain/asdf-sonobuoy.git
```

sonobuoy:

```shell
# Show all installable versions
asdf list-all sonobuoy

# Install specific version
asdf install sonobuoy latest

# Set a version globally (on your ~/.tool-versions file)
asdf global sonobuoy latest

# Now sonobuoy commands are available
sonobuoy version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/mikesplain/asdf-sonobuoy/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Mike Splain](https://github.com/mikesplain/)
