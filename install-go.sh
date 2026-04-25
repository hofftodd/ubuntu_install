#!/bin/bash
set -e

# Install Go from the official tarball. See https://go.dev/dl/
# Ubuntu's apt-packaged Go tends to lag, so we install upstream.
GO_VERSION="${GO_VERSION:-1.26.2}"
ARCH="$(dpkg --print-architecture)"   # amd64, arm64, etc.
TARBALL="go${GO_VERSION}.linux-${ARCH}.tar.gz"
URL="https://go.dev/dl/${TARBALL}"

if command -v go >/dev/null 2>&1 && go version | grep -q "go${GO_VERSION}"; then
    echo "Go ${GO_VERSION} already installed — skipping download."
else
    echo "Downloading ${URL}..."
    cd /tmp
    wget -q "$URL"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "$TARBALL"
    rm "$TARBALL"
fi

# Ensure go and $GOPATH/bin are on PATH in ~/.bashrc
if ! grep -q '/usr/local/go/bin' "$HOME/.bashrc"; then
    cat >> "$HOME/.bashrc" <<'EOF'

# Go
export PATH="/usr/local/go/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
EOF
fi

echo "Go installed: $(/usr/local/go/bin/go version)"
echo "Restart your shell or run: source ~/.bashrc"
