#!/bin/bash
set -euo pipefail

APP_ID="com.onepassword.OnePassword"

if flatpak list --user --columns=application 2>/dev/null | grep -qx "$APP_ID"; then
    echo "1Password already installed (flatpak --user). Skipping."
    exit 0
fi

flatpak install --user -y https://downloads.1password.com/linux/flatpak/1Password.flatpakref
