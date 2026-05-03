#!/bin/bash
set -e

# Bootstrap a fresh Ubuntu machine: install git+ssh, configure git identity,
# generate an SSH key (if needed), wait for you to add it to GitHub, then
# clone the ubuntu-install repo. After this finishes you can run
# ./install-master.sh inside the cloned repo.
#
# This script is intentionally NOT part of install-master.sh — it's the
# chicken-and-egg "how do I even get the install scripts onto the machine"
# step. To run on a fresh box:
#
#   curl -fsSL https://raw.githubusercontent.com/hofftodd/ubuntu-install/main/bootstrap.sh | bash
#
# Override defaults via env vars (otherwise you'll be prompted):
#   GIT_USER_NAME, GIT_USER_EMAIL, SSH_KEY, SSH_KEY_COMMENT, REPO_URL, CLONE_DIR

GIT_USER_NAME="${GIT_USER_NAME:-}"
GIT_USER_EMAIL="${GIT_USER_EMAIL:-}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_ed25519}"
REPO_URL="${REPO_URL:-git@github.com:hofftodd/ubuntu-install.git}"
CLONE_DIR="${CLONE_DIR:-$HOME/ubuntu-install}"

echo "═══════════════════════════════════════════════════════════"
echo "  Ubuntu workstation bootstrap"
echo "═══════════════════════════════════════════════════════════"

# Prompt for any unset identity values. Read from /dev/tty so this works
# even when the script is piped through bash (curl ... | bash leaves stdin
# attached to the curl stream, not the terminal).
if [ -z "$GIT_USER_NAME" ]; then
    read -r -p "Git user name (e.g. 'Jane Doe'): " GIT_USER_NAME < /dev/tty
fi
if [ -z "$GIT_USER_EMAIL" ]; then
    read -r -p "Git user email (e.g. 'jane@example.com'): " GIT_USER_EMAIL < /dev/tty
fi
if [ -z "$GIT_USER_NAME" ] || [ -z "$GIT_USER_EMAIL" ]; then
    echo "Name and email are required." >&2
    exit 1
fi

SSH_KEY_COMMENT="${SSH_KEY_COMMENT:-$GIT_USER_EMAIL}"

echo
echo "  Git user:  ${GIT_USER_NAME} <${GIT_USER_EMAIL}>"
echo "  SSH key:   ${SSH_KEY}"
echo "  Repo:      ${REPO_URL}"
echo "  Clone to:  ${CLONE_DIR}"
echo

# ---- 1. Install git + ssh ---------------------------------------------------
echo "[1/5] Installing git and openssh-client..."
sudo apt-get update
sudo apt-get install -y git openssh-client curl

# glow is used by install-master.sh to render this repo's README from inside
# the TUI menu. It's not in default Ubuntu repos — pull it from Charm's apt
# repo. Skip if already installed (e.g. user added it manually).
if ! command -v glow >/dev/null 2>&1; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key \
        | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" \
        | sudo tee /etc/apt/sources.list.d/charm.list >/dev/null
    sudo apt-get update
    sudo apt-get install -y glow
fi

# ---- 2. Configure git identity + sensible defaults --------------------------
echo
echo "[2/5] Configuring git..."
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global push.autoSetupRemote true
git config --global fetch.prune true
git config --global rebase.autoStash true
git config --global rerere.enabled true
git config --global merge.conflictStyle zdiff3

# ---- 3. Generate SSH key (if missing) ---------------------------------------
echo
echo "[3/5] SSH key..."
if [ -f "$SSH_KEY" ]; then
    echo "  Existing key found at $SSH_KEY — reusing."
else
    mkdir -p "$(dirname "$SSH_KEY")"
    chmod 700 "$(dirname "$SSH_KEY")"
    ssh-keygen -t ed25519 -C "$SSH_KEY_COMMENT" -f "$SSH_KEY" -N ""
fi

# Make sure ssh-agent is running and the key is loaded.
if [ -z "${SSH_AUTH_SOCK:-}" ] || ! ssh-add -l >/dev/null 2>&1; then
    eval "$(ssh-agent -s)" >/dev/null
fi
ssh-add "$SSH_KEY" 2>/dev/null || true

# ---- 4. Pause for user to register the key with GitHub ----------------------
echo
echo "═══════════════════════════════════════════════════════════"
echo "  ADD THIS PUBLIC KEY TO GITHUB"
echo "═══════════════════════════════════════════════════════════"
cat "${SSH_KEY}.pub"
echo "═══════════════════════════════════════════════════════════"
echo
echo "  → Open: https://github.com/settings/ssh/new"
echo "  → Paste the line above and save."
echo

read -r -p "Press ENTER once you've added the key to GitHub..." < /dev/tty

# Add github.com to known_hosts non-interactively, then verify auth.
echo
echo "[4/5] Verifying SSH access to GitHub..."
touch "$HOME/.ssh/known_hosts"
chmod 600 "$HOME/.ssh/known_hosts"
ssh-keyscan -t rsa,ecdsa,ed25519 github.com >> "$HOME/.ssh/known_hosts" 2>/dev/null || true
sort -u "$HOME/.ssh/known_hosts" -o "$HOME/.ssh/known_hosts"

# `ssh -T git@github.com` exits 1 even on success ("you have successfully
# authenticated, but GitHub does not provide shell access"), so check the
# message body. Capture into a variable instead of piping to grep — piping
# to `grep -q` lets grep exit on first match and leaves ssh to die from
# SIGPIPE, which on some setups stalls long enough to look like a hang.
ssh_output="$(ssh -T \
    -o BatchMode=yes \
    -o StrictHostKeyChecking=accept-new \
    -o ConnectTimeout=10 \
    git@github.com 2>&1 || true)"

if printf '%s\n' "$ssh_output" | grep -q "successfully authenticated"; then
    echo "  ✓ GitHub SSH auth working."
else
    echo "  ✗ Could not authenticate to GitHub via SSH." >&2
    echo "    ssh said:" >&2
    printf '      %s\n' "$ssh_output" >&2
    echo "    Confirm the key was added at https://github.com/settings/keys" >&2
    echo "    then re-run this script." >&2
    exit 1
fi

# ---- 5. Clone the repo ------------------------------------------------------
echo
echo "[5/5] Cloning ${REPO_URL} → ${CLONE_DIR}..."
if [ -d "$CLONE_DIR/.git" ]; then
    echo "  $CLONE_DIR already exists — pulling latest."
    git -C "$CLONE_DIR" pull --ff-only
else
    git clone "$REPO_URL" "$CLONE_DIR"
fi

echo
echo "═══════════════════════════════════════════════════════════"
echo "  Bootstrap complete."
echo "═══════════════════════════════════════════════════════════"
echo "  Next:  cd ${CLONE_DIR} && ./install-master.sh"
echo
