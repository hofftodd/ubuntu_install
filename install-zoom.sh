#!/bin/bash
set -e

# Install Zoom from the official .deb.
# See https://zoom.us/download?os=linux
ARCH="$(dpkg --print-architecture)"   # amd64 or arm64
cd /tmp
wget -O zoom.deb "https://zoom.us/client/latest/zoom_${ARCH}.deb"
sudo apt-get update
sudo apt-get install -y ./zoom.deb
rm zoom.deb

echo "Zoom installed."
