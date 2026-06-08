#!/bin/bash
set -e

# Install the Claude desktop app.
#
# Anthropic does not ship an official Claude Desktop for Linux — this uses the
# community project aaddrick/claude-desktop-debian, which repackages the Windows
# app and serves it from an APT repo so it updates with the rest of your system.
# See https://github.com/aaddrick/claude-desktop-debian (unofficial build).

if dpkg -s claude-desktop >/dev/null 2>&1; then
    echo "Claude Desktop already installed. Skipping."
    exit 0
fi

KEYRING="/usr/share/keyrings/claude-desktop.gpg"
SOURCES="/etc/apt/sources.list.d/claude-desktop.list"

sudo apt-get update
sudo apt-get install -y curl gpg

# Add the project's signing key and APT repo (amd64 + arm64 builds available).
curl -fsSL https://pkg.claude-desktop-debian.dev/KEY.gpg | sudo gpg --dearmor -o "$KEYRING"
echo "deb [signed-by=$KEYRING arch=amd64,arm64] https://pkg.claude-desktop-debian.dev stable main" \
    | sudo tee "$SOURCES" >/dev/null

sudo apt-get update
sudo apt-get install -y claude-desktop

echo "Claude Desktop installed. Launch it from your app menu."
echo "Future updates arrive via: sudo apt-get update && sudo apt-get upgrade"
