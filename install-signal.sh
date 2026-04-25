#!/bin/bash
set -e

# Install Signal Desktop from the official Signal apt repo.
# See https://signal.org/download/linux/
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://updates.signal.org/desktop/apt/keys.asc \
    | gpg --dearmor \
    | sudo tee /etc/apt/keyrings/signal-desktop-keyring.gpg > /dev/null
sudo chmod 644 /etc/apt/keyrings/signal-desktop-keyring.gpg

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" \
    | sudo tee /etc/apt/sources.list.d/signal-xenial.list > /dev/null

sudo apt-get update
sudo apt-get install -y signal-desktop

echo "Signal Desktop installed."
