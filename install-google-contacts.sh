#!/bin/bash
set -e

# Install Google Contacts as a Chrome "app-mode" launcher.
# Chrome's --install-system-app flag only works on managed Chromebooks, so on
# Linux we just write a .desktop file that opens Chrome in app mode.

if ! command -v google-chrome &>/dev/null; then
    echo "Google Chrome not found. Install it first (./install-chrome.sh)." >&2
    exit 1
fi

APP_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$APP_DIR/google-contacts.desktop"
URL="https://contacts.google.com/"

mkdir -p "$APP_DIR"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Google Contacts
Comment=Google Contacts web app
Exec=google-chrome --app=${URL}
Icon=contact-new
Type=Application
Categories=Office;ContactManagement;
StartupWMClass=contacts.google.com
Terminal=false
EOF

update-desktop-database "$APP_DIR" 2>/dev/null || true
echo "Google Contacts launcher installed at $DESKTOP_FILE"
