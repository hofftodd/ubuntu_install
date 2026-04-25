#!/bin/bash
set -e

# Install GitHub CLI from GitHub's official apt repo.
# See https://cli.github.com/
sudo apt-get update
sudo apt-get install -y curl ca-certificates

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod 644 /etc/apt/keyrings/githubcli-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

sudo apt-get update
sudo apt-get install -y gh

echo "GitHub CLI installed: $(gh --version | head -1)"
echo "Run: gh auth login"
