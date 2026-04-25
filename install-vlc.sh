#!/bin/bash
set -e

# Install VLC media player.
sudo apt-get update
sudo apt-get install -y vlc

echo "VLC installed: $(vlc --version 2>/dev/null | head -1)"
