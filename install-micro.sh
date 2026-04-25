#!/bin/bash
set -e

# Install the micro terminal text editor.
# See https://micro-editor.github.io/
# The official installer downloads the latest release into the current
# directory; we run it in /tmp and move the binary into ~/.local/bin.
mkdir -p "$HOME/.local/bin"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
cd "$TMP"
curl -fsSL https://getmic.ro | bash

mv micro "$HOME/.local/bin/micro"
chmod +x "$HOME/.local/bin/micro"

# Make sure ~/.local/bin is on PATH.
if ! grep -q '\.local/bin' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

echo "micro installed: $($HOME/.local/bin/micro --version | head -1)"
echo "Restart your shell or run: source ~/.bashrc"
