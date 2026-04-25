#!/bin/bash
set -e

# Install LM Studio as an AppImage. See https://lmstudio.ai/
# AppImage URLs are version-pinned; override LMSTUDIO_VERSION as needed.
LMSTUDIO_VERSION="${LMSTUDIO_VERSION:-0.3.5-2}"
APPIMAGE_URL="https://installers.lmstudio.ai/linux/x64/${LMSTUDIO_VERSION}/LM-Studio-${LMSTUDIO_VERSION}-x64.AppImage"

INSTALL_DIR="$HOME/Applications"
APPIMAGE_PATH="$INSTALL_DIR/LM-Studio.AppImage"
DESKTOP_FILE="$HOME/.local/share/applications/lmstudio.desktop"

# AppImages need libfuse2 on modern Ubuntu. Newer Ubuntu releases
# (post t64 ABI transition) ship it as libfuse2t64 — try that as a fallback.
sudo apt-get update
sudo apt-get install -y wget
if ! sudo apt-get install -y libfuse2 2>/dev/null; then
    sudo apt-get install -y libfuse2t64
fi

mkdir -p "$INSTALL_DIR" "$HOME/.local/share/applications"

echo "Downloading LM Studio ${LMSTUDIO_VERSION}..."
wget -O "$APPIMAGE_PATH" "$APPIMAGE_URL"
chmod +x "$APPIMAGE_PATH"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=LM Studio
Exec=${APPIMAGE_PATH}
Icon=lmstudio
Type=Application
Categories=Development;Utility;
Terminal=false
EOF

echo "LM Studio installed at $APPIMAGE_PATH"
echo "Launch from your app menu, or run: $APPIMAGE_PATH"
