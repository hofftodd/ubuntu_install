#!/bin/bash
set -e

# Install amdgpu_top. See https://github.com/Umio-Yasuno/amdgpu_top
# Fetches the latest .deb release from GitHub.
TMP=$(mktemp -d)
cd "$TMP"

DEB_URL=$(curl -s https://api.github.com/repos/Umio-Yasuno/amdgpu_top/releases/latest \
    | grep "browser_download_url.*amd64.deb" \
    | grep -v "without_gui" \
    | head -n1 \
    | cut -d '"' -f 4)

if [ -z "$DEB_URL" ]; then
    echo "Could not find latest amdgpu_top .deb release."
    exit 1
fi

echo "Downloading $DEB_URL..."
curl -L -O "$DEB_URL"
sudo apt install -y ./*.deb

cd -
rm -rf "$TMP"
