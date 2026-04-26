#!/bin/bash
set -e

# Install Gmail as a Chrome "app-mode" launcher.
# Chrome's --install-system-app flag only works on managed Chromebooks, so on
# Linux we just write a .desktop file that opens Chrome in app mode.

if ! command -v google-chrome &>/dev/null; then
    echo "Google Chrome not found. Install it first (./install-chrome.sh)." >&2
    exit 1
fi

APP_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$APP_DIR/gmail.desktop"
URL="https://mail.google.com/mail/u/0/"

mkdir -p "$APP_DIR"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Gmail
Comment=Gmail web app
Exec=google-chrome --app=${URL}
Icon=mail-message-new
Type=Application
Categories=Network;Email;
StartupWMClass=mail.google.com__mail_u_0
Terminal=false
EOF

update-desktop-database "$APP_DIR" 2>/dev/null || true
echo "Gmail launcher installed at $DESKTOP_FILE"
