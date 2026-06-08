#!/bin/bash
set -euo pipefail

# Unison: bidirectional file synchronizer. https://www.cis.upenn.edu/~bcpierce/unison/
sudo apt-get update
sudo apt-get install -y unison

echo "Unison installed: $(unison -version | head -1)"
