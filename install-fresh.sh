#!/bin/bash
set -e

# Install the Fresh terminal text editor (https://getfresh.dev/).
# Pulls the latest .deb for the host architecture from the GitHub release
# at sinelaw/fresh and installs it via dpkg.

sudo apt-get update
sudo apt-get install -y curl jq ca-certificates

ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
    amd64|arm64) ;;
    *)
        echo "No prebuilt fresh-editor .deb for arch '$ARCH'." >&2
        exit 1
        ;;
esac

DEB_URL="$(curl -fsSL https://api.github.com/repos/sinelaw/fresh/releases/latest \
    | jq -r --arg arch "$ARCH" '.assets[] | select(.name | endswith("_" + $arch + ".deb")) | .browser_download_url' \
    | head -1)"

if [ -z "$DEB_URL" ]; then
    echo "Could not find a fresh-editor .deb for $ARCH in the latest release." >&2
    exit 1
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
DEB="$TMP/fresh-editor.deb"

curl -fsSL "$DEB_URL" -o "$DEB"
sudo apt-get install -y "$DEB"

echo "Fresh installed: $(fresh --version 2>/dev/null | head -1)"
