#!/bin/bash
set -e

# Install Steam from Valve's official .deb.
# See https://store.steampowered.com/about/
# Steam is a 32-bit application, so i386 multiarch must be enabled first; the
# .deb pulls in the needed 32-bit libraries. The package is a bootstrapper —
# it downloads and updates the real client on first launch.
sudo dpkg --add-architecture i386
cd /tmp
wget -O steam.deb "https://repo.steampowered.com/steam/archive/stable/steam_latest.deb"
sudo apt-get update
sudo apt-get install -y ./steam.deb
rm steam.deb

echo "Steam installed. Launch it once to let it download the latest client."
