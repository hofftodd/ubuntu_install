#!/bin/bash
set -e

# Install Flameshot screenshot tool.
# See https://flameshot.org/
sudo apt-get update
sudo apt-get install -y flameshot

echo "Flameshot installed."
echo "Tip: bind 'flameshot gui' to a keyboard shortcut (e.g. PrtScr) in Settings → Keyboard → Custom Shortcuts."
