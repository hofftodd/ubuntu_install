#!/bin/bash
set -e

# Install Syncthing from the official apt repo.
# See https://docs.syncthing.net/users/autostart.html#using-systemd
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
sudo chmod 644 /etc/apt/keyrings/syncthing-archive-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" \
    | sudo tee /etc/apt/sources.list.d/syncthing.list > /dev/null

sudo apt-get update
sudo apt-get install -y syncthing

# Enable and start the per-user systemd service so Syncthing runs at login.
systemctl --user enable syncthing.service
systemctl --user start syncthing.service || true

echo "Syncthing installed and enabled as a per-user service."
echo "Web UI (after first start): http://localhost:8384"
