#!/bin/bash
set -e

# Install Ollama via the official installer.
# See https://ollama.com/
curl -fsSL https://ollama.com/install.sh | sh

echo "Ollama installed. Try: ollama run llama3.2"
echo "The installer also sets up a systemd service — check with: systemctl status ollama"
