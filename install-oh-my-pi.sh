#!/bin/bash
set -e

# Install Oh My Pi, an AI coding agent for the terminal — hash-anchored edits,
# LSP, Python, browser, subagents, etc. (an extension of pi).
# Binary lands at ~/.local/bin/omp.
# See https://github.com/can1357/oh-my-pi
curl -fsSL https://raw.githubusercontent.com/can1357/oh-my-pi/main/scripts/install.sh | sh

if ! grep -q '\.local/bin' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

echo "Oh My Pi installed. Restart your shell or run: source ~/.bashrc"
echo "Then run: omp"
