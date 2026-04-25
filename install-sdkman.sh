#!/bin/bash
set -e

# Install SDKMAN! See https://sdkman.io/
# Required dependencies for the installer.
sudo apt-get update
sudo apt-get install -y curl zip unzip

if [ -d "$HOME/.sdkman" ]; then
    echo "SDKMAN! already installed at $HOME/.sdkman — skipping."
else
    curl -s "https://get.sdkman.io?rcupdate=false" | bash
fi

# Ensure SDKMAN! is initialized in ~/.bashrc
if ! grep -q 'sdkman-init.sh' "$HOME/.bashrc"; then
    cat >> "$HOME/.bashrc" <<'EOF'

# SDKMAN!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
EOF
fi

echo "SDKMAN! installed. Restart your shell or run: source ~/.bashrc"
echo "Then verify with: sdk version"
