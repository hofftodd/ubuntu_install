#!/bin/bash
set -e

# Install uv, the fast Python package & project manager.
# See https://docs.astral.sh/uv/
curl -LsSf https://astral.sh/uv/install.sh | sh

# The installer drops a binary at ~/.local/bin/uv and handles PATH for most
# shells, but make sure ~/.local/bin is on PATH in ~/.bashrc just in case.
if ! grep -q '\.local/bin' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

echo "uv installed. Restart your shell or run: source ~/.bashrc"
echo "Then verify with: uv --version"
