#!/bin/bash
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
mkdir downloads
curl -# -L -o /home/thoffman/install/downloads/docker-desktop-amd64.deb https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64&_gl=1*l6frei*_gcl_au*MTA2ODQ2MjQxNS4xNzY3ODUxMjMy*_ga*MjEwMjE1NTEzNi4xNzY3ODUwOTIw*_ga_XJWPQMJYHQ*czE3Njc4NTA5MTkkbzEkZzEkdDE3Njc4NTEyNzgkajE0JGwwJGgw
sudo apt-get update
sudo apt-get install ./downloads/docker-desktop-amd64.deb


