#!/bin/bash
set -e

# Install Docker Desktop for Linux.
# See https://docs.docker.com/desktop/install/linux-install/

# 1. Add Docker's official apt repo (provides docker-ce dependencies that
#    docker-desktop relies on).
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt-get update

# 2. Download and install the Docker Desktop .deb.
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
cd "$TMP"

curl -# -L -o docker-desktop-amd64.deb \
    "https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb"

sudo apt-get install -y ./docker-desktop-amd64.deb

echo "Docker Desktop installed. Launch it from your app menu, then run: docker --version"
