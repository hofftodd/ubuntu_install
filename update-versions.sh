#!/bin/bash
set -e

# Look up the latest upstream versions of pinned tools and rewrite the
# defaults in the relevant install-*.sh scripts in place. Run this before
# install-master.sh to avoid stale pins. install-master.sh invokes it
# automatically as its first step.
#
# Sources:
#   Go            — https://go.dev/VERSION?m=text
#   nvm           — github.com/nvm-sh/nvm latest release
#   Python        — endoflife.date API (latest of the most recent stable cycle)
#   Nerd Fonts    — github.com/ryanoasis/nerd-fonts latest release
#
# Skipped (no reliable machine-readable source):
#   LM Studio     — version-pinned AppImage URL; check https://lmstudio.ai/
#   AMD drivers   — check https://www.amd.com/en/support/linux-drivers

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# jq + curl are the only deps.
if ! command -v jq >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y jq curl
fi

update_default() {
    # update_default <file> <var-name> <new-value>
    # Rewrites lines like:  VAR="${VAR:-old}"   →   VAR="${VAR:-new}"
    local file="$1" var="$2" new="$3"
    if [ -z "$new" ] || [ "$new" = "null" ]; then
        echo "  ! could not resolve new version for $var (skipped)"
        return
    fi
    local before
    before="$(grep -E "^${var}=\"\\\$\\{${var}:-" "$file" | head -1 || true)"
    sed -i -E "s|^(${var}=\"\\\$\\{${var}:-)[^\"}]*(\\}\")|\\1${new}\\2|" "$file"
    local after
    after="$(grep -E "^${var}=\"\\\$\\{${var}:-" "$file" | head -1 || true)"
    if [ "$before" = "$after" ]; then
        echo "  = ${var} already at ${new}"
    else
        echo "  ✓ ${var}: $(echo "$before" | sed -E "s/.*:-([^}]*)\\}.*/\\1/") → ${new}"
    fi
}

update_plain() {
    # update_plain <file> <var-name> <new-value>
    # Rewrites lines like:  VAR="old"   →   VAR="new"   (no ${VAR:-…} default)
    local file="$1" var="$2" new="$3"
    if [ -z "$new" ] || [ "$new" = "null" ]; then
        echo "  ! could not resolve new version for $var (skipped)"
        return
    fi
    local before
    before="$(grep -E "^${var}=\"" "$file" | head -1 || true)"
    sed -i -E "s|^(${var}=\")[^\"]*(\")|\\1${new}\\2|" "$file"
    local after
    after="$(grep -E "^${var}=\"" "$file" | head -1 || true)"
    if [ "$before" = "$after" ]; then
        echo "  = ${var} already at ${new}"
    else
        echo "  ✓ ${var}: $(echo "$before" | sed -E 's/.*="([^"]*)".*/\1/') → ${new}"
    fi
}

echo "Resolving latest versions..."

# Go: returns "go1.23.4" — strip leading "go".
GO_LATEST="$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -1 | sed 's/^go//')"
echo "Go:         ${GO_LATEST}"
update_default "${DIR}/install-go.sh" "GO_VERSION" "$GO_LATEST"

# nvm: GitHub releases — tag is like "v0.40.1" (we keep the leading "v").
NVM_LATEST="$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r .tag_name)"
echo "nvm:        ${NVM_LATEST}"
update_default "${DIR}/install-nodejs.sh" "NVM_VERSION" "$NVM_LATEST"

# Python: latest of the most recently released stable cycle.
PY_LATEST="$(curl -fsSL https://endoflife.date/api/python.json | jq -r '[.[] | select(.eol > (now | strftime("%Y-%m-%d")))] | .[0].latest')"
echo "Python:     ${PY_LATEST}"
update_default "${DIR}/install-pyenv.sh" "PYTHON_VERSION" "$PY_LATEST"

# Nerd Fonts: GitHub releases — tag like "v3.2.1", script wants "3.2.1".
NF_LATEST="$(curl -fsSL https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq -r .tag_name | sed 's/^v//')"
echo "Nerd Fonts: ${NF_LATEST}"
update_plain "${DIR}/install-nerd-fonts.sh" "VERSION" "$NF_LATEST"

echo
echo "Skipped (manual check needed):"
echo "  - install-lmstudio.sh    — see https://lmstudio.ai/"
echo "  - install-amd-drivers.sh — see https://www.amd.com/en/support/linux-drivers"
echo
echo "Done."
