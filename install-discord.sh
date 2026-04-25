#!/bin/bash
set -e

# Install Discord from the official .deb.
# See https://discord.com/download
cd /tmp
wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt-get update
sudo apt-get install -y ./discord.deb
rm discord.deb

echo "Discord installed."
