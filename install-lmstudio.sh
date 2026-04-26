#!/bin/bash
set -e

# Install LM Studio as an AppImage. See https://lmstudio.ai/
# AppImage URLs are version-pinned. There is no machine-readable "latest"
# endpoint, so when this 404s, grab the current version from
# https://lmstudio.ai/download (look for the Linux x64 .AppImage URL) and
# either bump the default below or run with LMSTUDIO_VERSION=<x.y.z-n>.
LMSTUDIO_VERSION="${LMSTUDIO_VERSION:-0.4.12-1}"
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
if ! wget -O "$APPIMAGE_PATH" "$APPIMAGE_URL"; then
    rm -f "$APPIMAGE_PATH"
    echo
    echo "Download failed for LM Studio ${LMSTUDIO_VERSION}." >&2
    echo "The pinned version is likely stale. Find the current version at" >&2
    echo "  https://lmstudio.ai/download" >&2
    echo "and re-run with: LMSTUDIO_VERSION=<x.y.z-n> $0" >&2
    exit 1
fi
chmod +x "$APPIMAGE_PATH"

# Extract the AppImage's embedded icon so the launcher has something to show.
# Every AppImage exposes its icon via .DirIcon (a symlink to the actual file)
# at the root of the extracted AppDir.
ICON_DIR="$HOME/.local/share/icons"
ICON_PATH="$ICON_DIR/lmstudio.png"
mkdir -p "$ICON_DIR"
EXTRACT_TMP="$(mktemp -d)"
(
    cd "$EXTRACT_TMP"
    "$APPIMAGE_PATH" --appimage-extract .DirIcon >/dev/null
)
if [ -f "$EXTRACT_TMP/squashfs-root/.DirIcon" ]; then
    cp -L "$EXTRACT_TMP/squashfs-root/.DirIcon" "$ICON_PATH"
fi
rm -rf "$EXTRACT_TMP"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=LM Studio
Exec=${APPIMAGE_PATH}
Icon=${ICON_PATH}
Type=Application
Categories=Development;Utility;
Terminal=false
EOF

update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

echo "LM Studio installed at $APPIMAGE_PATH"
echo "Launch from your app menu, or run: $APPIMAGE_PATH"
