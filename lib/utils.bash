#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/vmware-tanzu/sonobuoy"

fail() {
  echo -e "asdf-sonobuoy: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if sonobuoy is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  # Change this function if sonobuoy has other means of determining installable versions.
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  local platform
  [ "Linux" = "$(uname)" ] && platform="linux" || platform="darwin"
  local arch
  [ "x86_64" = "$(uname -m)" ] && arch="amd64" || arch="386"

  url="$GH_REPO/releases/download/v${version}/sonobuoy_${version}_${platform}_${arch}.tar.gz"
  echo "* Downloading sonobuoy release $version..."
  echo "* URL: $url"
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  local platform
  [ "Linux" = "$(uname)" ] && platform="linux" || platform="darwin"
  local arch
  [ "x86_64" = "$(uname -m)" ] && arch="amd64" || arch="386"

  if [ "$install_type" != "version" ]; then
    fail "asdf-sonobuoy supports release installs only"
  fi

  local release_file="$install_path/sonobuoy_${version}_${platform}_${arch}.tar.gz"
  echo releasefile: $release_file

  (
    mkdir -p "$install_path"
    download_release "$version" "$release_file"
    tar -xzf "$release_file" -C "$install_path" || fail "Could not extract $release_file"
    mkdir -p "$install_path/bin"
    mv "$install_path/sonobuoy" ""$install_path/bin/sonobuoy
    rm "$release_file"

    local tool_cmd
    tool_cmd="sonobuoy"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "sonobuoy $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing sonobuoy $version."
    echo fail
  )
}
