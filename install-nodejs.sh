#!/bin/bash
set -e

# Install Node.js via nvm (Node Version Manager).
# See https://github.com/nvm-sh/nvm
NVM_VERSION="${NVM_VERSION:-v0.40.4}"
NODE_VERSION="${NODE_VERSION:---lts}"   # e.g. "22", "20.18.0", or "--lts"

# Install nvm via the official installer (idempotent — re-running upgrades).
export PROFILE=/dev/null   # prevent the installer from editing rc files; we manage that below
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
unset PROFILE

# Ensure nvm is initialized in ~/.bashrc
if ! grep -q 'NVM_DIR' "$HOME/.bashrc"; then
    cat >> "$HOME/.bashrc" <<'EOF'

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
fi

# Make nvm available in this script for the install step.
export NVM_DIR="$HOME/.nvm"
\. "$NVM_DIR/nvm.sh"

nvm install "$NODE_VERSION"
nvm alias default "$NODE_VERSION"
nvm use default

echo "Node installed: $(node --version)"
echo "npm: $(npm --version)"
echo "Restart your shell or run: source ~/.bashrc"
