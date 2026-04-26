#!/bin/bash
set -e

# Install HandBrake (GUI + CLI) video transcoder.
# See https://handbrake.fr/
sudo apt-get update
sudo apt-get install -y handbrake handbrake-cli

echo "HandBrake installed: $(HandBrakeCLI --version 2>/dev/null | head -1)"
