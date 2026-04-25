#!/bin/bash
set -e

# Install pyenv and a recent Python via pyenv. See https://github.com/pyenv/pyenv
PYTHON_VERSION="${PYTHON_VERSION:-3.14.4}"

# Build dependencies for compiling Python. See:
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
sudo apt-get update
sudo apt-get install -y \
    build-essential curl git \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    libncurses-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Install pyenv via the official installer.
if [ -d "$HOME/.pyenv" ]; then
    echo "pyenv already installed at $HOME/.pyenv — updating."
    (cd "$HOME/.pyenv" && git pull --ff-only) || true
else
    curl -fsSL https://pyenv.run | bash
fi

# Ensure pyenv is initialized in ~/.bashrc
if ! grep -q 'PYENV_ROOT' "$HOME/.bashrc"; then
    cat >> "$HOME/.bashrc" <<'EOF'

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
eval "$(pyenv virtualenv-init -)"
EOF
fi

# Make pyenv available in this script for the install/global step.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

if ! pyenv versions --bare | grep -qx "$PYTHON_VERSION"; then
    echo "Installing Python $PYTHON_VERSION via pyenv (this can take a few minutes)..."
    pyenv install "$PYTHON_VERSION"
fi

pyenv global "$PYTHON_VERSION"

echo "pyenv installed. Restart your shell or run: source ~/.bashrc"
echo "Active Python: $(pyenv version)"
