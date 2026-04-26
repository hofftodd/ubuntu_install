#!/bin/bash
set -e

# Install Cursor, the AI code editor, as an AppImage.
# See https://cursor.com/
# The cursor.com API returns the canonical download URL for the latest stable
# Linux x64 build. The legacy downloader.cursor.sh host has been retired.
API_URL="https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable"

INSTALL_DIR="$HOME/Applications"
APPIMAGE_PATH="$INSTALL_DIR/Cursor.AppImage"
DESKTOP_FILE="$HOME/.local/share/applications/cursor.desktop"

# AppImages need libfuse2 on modern Ubuntu (libfuse2t64 on post-t64 releases).
sudo apt-get update
sudo apt-get install -y wget curl jq
if ! sudo apt-get install -y libfuse2 2>/dev/null; then
    sudo apt-get install -y libfuse2t64
fi

mkdir -p "$INSTALL_DIR" "$HOME/.local/share/applications"

echo "Resolving latest Cursor download URL..."
DOWNLOAD_URL="$(curl -fsSL -H 'User-Agent: Mozilla/5.0' "$API_URL" | jq -r '.downloadUrl')"
if [ -z "$DOWNLOAD_URL" ] || [ "$DOWNLOAD_URL" = "null" ]; then
    echo "Could not resolve Cursor download URL from $API_URL" >&2
    exit 1
fi

echo "Downloading Cursor AppImage from $DOWNLOAD_URL..."
wget -O "$APPIMAGE_PATH" "$DOWNLOAD_URL"
chmod +x "$APPIMAGE_PATH"

# Extract the AppImage's embedded icon so the launcher has something to show.
# Every AppImage exposes its icon via .DirIcon (a symlink to the actual file)
# at the root of the extracted AppDir.
ICON_DIR="$HOME/.local/share/icons"
ICON_PATH="$ICON_DIR/cursor.png"
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
Name=Cursor
Exec=${APPIMAGE_PATH} --no-sandbox %F
Icon=${ICON_PATH}
Type=Application
Categories=Development;TextEditor;
MimeType=text/plain;inode/directory;
Terminal=false
StartupWMClass=Cursor
EOF

update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

echo "Cursor installed at $APPIMAGE_PATH"
echo "Launch from your app menu, or run: $APPIMAGE_PATH"
