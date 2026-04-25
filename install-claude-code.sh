#!/bin/bash
set -e

# Install Claude Code, Anthropic's official CLI.
# See https://docs.claude.com/en/docs/claude-code/setup
curl -fsSL https://claude.ai/install.sh | bash

# The installer drops the binary at ~/.local/bin/claude — make sure that's on PATH.
if ! grep -q '\.local/bin' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

echo "Claude Code installed. Restart your shell or run: source ~/.bashrc"
echo "Then run: claude   (first launch will prompt you to authenticate)"
