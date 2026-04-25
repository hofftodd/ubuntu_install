#!/bin/bash
set -e

# Install Starship prompt. See https://starship.rs/
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Ensure starship init is in ~/.bashrc
if ! grep -q 'starship init bash' "$HOME/.bashrc"; then
    echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
fi

# Apply the Gruvbox Rainbow preset
mkdir -p "$HOME/.config"
starship preset gruvbox-rainbow -o "$HOME/.config/starship.toml"

echo "Starship installed with Gruvbox Rainbow preset. Restart your shell or run: source ~/.bashrc"
