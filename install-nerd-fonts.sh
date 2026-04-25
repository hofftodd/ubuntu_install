#!/bin/bash
set -e

# Install a selection of Nerd Fonts. See https://www.nerdfonts.com/
FONTS=(FiraCode JetBrainsMono Hack Meslo)
VERSION="3.2.1"
FONT_DIR="$HOME/.local/share/fonts"

mkdir -p "$FONT_DIR"
cd /tmp

for font in "${FONTS[@]}"; do
    echo "Downloading $font Nerd Font..."
    wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v${VERSION}/${font}.zip"
    unzip -o -q "${font}.zip" -d "$FONT_DIR/${font}NerdFont"
    rm "${font}.zip"
done

# Remove Windows-only and license files
find "$FONT_DIR" -type f \( -name "*Windows*" -o -name "*.txt" -o -name "*.md" \) -delete

# Refresh font cache
fc-cache -f "$FONT_DIR"

echo "Nerd Fonts installed to $FONT_DIR"
