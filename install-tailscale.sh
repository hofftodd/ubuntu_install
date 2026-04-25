#!/bin/bash
set -e

# Install Tailscale via the official installer.
# See https://tailscale.com/download/linux
curl -fsSL https://tailscale.com/install.sh | sh

echo "Tailscale installed."
echo "Run: sudo tailscale up   (this opens a browser to authenticate)"
