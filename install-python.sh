#!/bin/bash
set -e

# Install Ubuntu's system Python 3 along with pip and venv support.
sudo apt-get update
sudo apt-get install -y python3 python3-pip python3-venv python3-dev

echo "System Python installed: $(python3 --version)"
echo "pip: $(pip3 --version)"
