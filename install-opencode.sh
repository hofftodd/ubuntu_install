#!/bin/bash
set -e

# Install opencode, an open-source AI coding agent for the terminal.
# See https://opencode.ai/ and https://github.com/sst/opencode
curl -fsSL https://opencode.ai/install | bash

# The installer drops a binary at ~/.local/bin/opencode — ensure PATH.
if ! grep -q '\.local/bin' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

echo "opencode installed. Restart your shell or run: source ~/.bashrc"
echo "Then run: opencode"
