#!/bin/bash
set -e

# Install Cursor, the AI code editor, as an AppImage.
# See https://cursor.com/
# Cursor is distributed as a self-updating AppImage on Linux; the URL below
# always redirects to the latest x64 build.
DOWNLOAD_URL="https://downloader.cursor.sh/linux/appImage/x64"

INSTALL_DIR="$HOME/Applications"
APPIMAGE_PATH="$INSTALL_DIR/Cursor.AppImage"
DESKTOP_FILE="$HOME/.local/share/applications/cursor.desktop"

# AppImages need libfuse2 on modern Ubuntu (libfuse2t64 on post-t64 releases).
sudo apt-get update
sudo apt-get install -y wget
if ! sudo apt-get install -y libfuse2 2>/dev/null; then
    sudo apt-get install -y libfuse2t64
fi

mkdir -p "$INSTALL_DIR" "$HOME/.local/share/applications"

echo "Downloading latest Cursor AppImage..."
wget -O "$APPIMAGE_PATH" "$DOWNLOAD_URL"
chmod +x "$APPIMAGE_PATH"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Cursor
Exec=${APPIMAGE_PATH} --no-sandbox %F
Icon=cursor
Type=Application
Categories=Development;TextEditor;
MimeType=text/plain;inode/directory;
Terminal=false
StartupWMClass=Cursor
EOF

echo "Cursor installed at $APPIMAGE_PATH"
echo "Launch from your app menu, or run: $APPIMAGE_PATH"
