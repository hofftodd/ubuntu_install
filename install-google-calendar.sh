#!/bin/bash
set -e

# Install Google Calendar as a Chrome "app-mode" launcher.
# Chrome's --install-system-app flag only works on managed Chromebooks, so on
# Linux we just write a .desktop file that opens Chrome in app mode.

if ! command -v google-chrome &>/dev/null; then
    echo "Google Chrome not found. Install it first (./install-chrome.sh)." >&2
    exit 1
fi

APP_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$APP_DIR/google-calendar.desktop"
URL="https://calendar.google.com/"

mkdir -p "$APP_DIR"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Google Calendar
Comment=Google Calendar web app
Exec=google-chrome --app=${URL}
Icon=x-office-calendar
Type=Application
Categories=Office;Calendar;
StartupWMClass=chrome-calendar.google.com__-Default
Terminal=false
EOF

update-desktop-database "$APP_DIR" 2>/dev/null || true
echo "Google Calendar launcher installed at $DESKTOP_FILE"
