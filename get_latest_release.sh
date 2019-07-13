get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

# Usage
# $ get_latest_release "creationix/nvm"
# v0.31.4
curl --silent "https://api.github.com/repos/$1/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")'
# https://stackoverflow.com/questions/10649814/get-last-git-tag-from-a-remote-repo-without-cloning/52699078#52699078
curl -fsSLI -o /dev/null -w %{url_effective} https://github.com/hadolint/hadolint/releases/latest && echo
## https://github.com/gohugoio/hugo/releases/tag/v0.55.6


get_latest_release_number() {
  curl --silent "https://github.com/$1/releases/latest" | sed 's#.*tag/\(.*\)\".*#\1#'
}

# See https://stackoverflow.com/questions/10649814/get-last-git-tag-from-a-remote-repo-without-cloning
git ls-remote --tags https://github.com/jgm/pandoc.git | sed -nE 's#.*refs/tags/(v?[0-9]+(\.[0-9]+)*)$#\1#p' | sort -Vr | head -n 1
# https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8
curl --silent "https://api.github.com/repos/USER/REPO/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                                 # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/' |
    xargs -I {} curl -sOL "https://github.com/USER/REPO/archive/"{}'.tar.gz'
# -----------------------------
#!/bin/bash
# Version 0.1.0  8:26 PST, Nov 9, 2018
# see https://discourse.gohugo.io/t/script-to-install-latest-hugo-release-on-macos-and-ubuntu/14774/10
# if you have run into github api anonymous access limits then add user and token here or in environment
# GITHUB_USER=""
# GITHUB_TOKEN=""

DEFAULT_BIN_DIR="/usr/local/bin"
# Single optional argument is directory in which to install hugo
BIN_DIR=${1:-"$DEFAULT_BIN_DIR"}
BIN_PATH="$(which hugo)"
declare -A ARCHES
ARCHES=( ["arm64"]="ARM64" ["aarch64"]="ARM64"  ["x86_64"]="64bit" ["arm32"]="ARM"  ["armhf"]="ARM" )
ARCH=$(arch)

if [ -z "${ARCHES[$ARCH]}" ]; then
  echo  Your machine kernel architecture $ARCH is not supported by this script, aborting
  exit 1
fi


INSTALLED="$(hugo version 2>/dev/null | cut -d'v' -f2 | cut -c 3-5)"
CUR_VERSION=${INSTALLED:-"None"}
NEW_VERSION="$(curl -u $GITHUB_USER:$GITHUB_TOKEN -s https://api.github.com/repos/gohugoio/hugo/releases/latest  \
             | grep tag_name \
             | cut -d'.' -f2 | cut -d'"' -f1)"

echo "Hugo:  Current Version: $CUR_VERSION => New Version: $NEW_VERSION"

if [ -z "$NEW_VERSION" ]; then
  echo  Unable to retrieve new version number - Likely you have reached github anonymous limit
  echo  set environment variable `$GITHUB_USER` and `$GITHUB_TOKEN` and try again
  exit 1
fi

if ! [ $NEW_VERSION = $CUR_VERSION ]; then

  echo "Installing version $NEW_VERSION"
  echo "This machine's architecture is $ARCH"
  echo "Downloading Tarball Linux-${ARCHES[$ARCH]}"

  pushd /tmp/ > /dev/null

  curl -u $GITHUB_USER:$GITHUB_TOKEN -s https://api.github.com/repos/gohugoio/hugo/releases/latest \
  | grep "browser_download_url.*hugo_[^extended].*_Linux-${ARCHES[$ARCH]}\.tar\.gz" \
  | cut -d ":" -f 2,3 \
  | tr -d \" \
  | wget --user=-u $GITHUB_USER --password=$GITHUB_TOKEN -qi -

  TARBALL="$(find . -name "*Linux-${ARCHES[$ARCH]}.tar.gz" 2>/dev/null)"
  echo Expanding Tarball
  tar -xzf $TARBALL

  chmod +x hugo

if [ -w $BIN_DIR ]; then
  echo "Installing hugo to $BIN_DIR"
  mv hugo -f $BIN_DIR
else
    echo "sudo Installing hugo to $BIN_DIR"
    sudo mv -f hugo $BIN_DIR
fi

  popd > /dev/null

  BIN_PATH="$(which hugo)"
  if [ -z "$BIN_PATH" ]; then
  printf "WARNING: Installed Hugo Binary in $BIN_DIR is not in your environment path\nPATH=$PATH\n"
else
  if [ "$BIN_DIR/hugo" != "$BIN_PATH" ]; then
  echo "WARNING: Just installed Hugo binary, $BIN_DIR , conflicts with existing Hugo in $BIN_PATH"
  echo "add $BIN_DIR to path and delete $BIN_PATH"
else
  echo "--- Confirmation ---"
  printf "New Hugo binary version in $BIN_DIR is\n $($BIN_DIR/hugo version)\n"
  fi
fi

else
  echo Latest version already installed in $BIN_PATH
fi
