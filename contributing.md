# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin test sonobuoy https://github.com/mikesplain/asdf-sonobuoy.git "sonobuoy version"
```

Tests are automatically run in GitHub Actions on push and PR.
