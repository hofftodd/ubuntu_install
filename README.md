# ubuntu_install

A collection of small, idempotent install scripts for setting up a fresh Ubuntu workstation. Each script handles one tool; `install-master.sh` runs them in a sensible order.

## Usage

Run a single script:

```bash
./install-vscode.sh
```

Or run everything in order:

```bash
./install-master.sh
```

`install-master.sh` runs every script and **continues past failures**, capturing per-script logs in a temp directory and printing a punch list at the end. It exits non-zero if anything failed, so you can re-run individual scripts after diagnosing.

Refresh the pinned version defaults (Go, nvm, Python, Nerd Fonts) from upstream before installing:

```bash
./update-versions.sh
```

`install-master.sh` runs this automatically as its first step.

Most scripts that download a pinned version also expose an env var override, e.g.:

```bash
PYTHON_VERSION=3.13.0 ./install-pyenv.sh
GO_VERSION=1.24.0     ./install-go.sh
NODE_VERSION=22       ./install-nodejs.sh
BACKEND=hip           ./install-llamacpp.sh
USECASE=graphics      ./install-amd-drivers.sh
```

## What's included

### System / drivers
- `install-amd-drivers.sh` — AMD GPU drivers + ROCm via the official `amdgpu-install` package. Adds you to `render` and `video` groups (logout required).
- `install-flatpak.sh` — Flatpak + Flathub remote.

### Git / GitHub
- `install-git-config.sh` — Sets `user.name`/`user.email` (override with `GIT_USER_NAME`/`GIT_USER_EMAIL`), modern defaults (rebase pulls, autoSetupRemote, zdiff3, rerere), and aliases. Auto-wires `git-delta` as the pager if installed.
- `install-gh.sh` — GitHub CLI (`gh`).

### GUI apps
- `install-chrome.sh` — Google Chrome (.deb)
- `install-1password.sh` — 1Password desktop client
- `install-vscode.sh` — Visual Studio Code
- `install-cursor.sh` — Cursor AI code editor (AppImage)
- `install-intellij.sh` — JetBrains IntelliJ IDEA
- `install-micro.sh` — micro, modern terminal text editor
- `install-claude-code.sh` — Claude Code CLI (Anthropic's official agentic coding tool)
- `install-opencode.sh` — opencode, open-source terminal coding agent
- `install-pi.sh` — pi (pi.dev), minimal terminal coding agent (npm; depends on Node)
- `install-obsidian.sh` — Obsidian
- `install-docker-desktop.sh` — Docker Desktop
- `install-gmail.sh`, `install-google-calendar.sh`, `install-google-contacts.sh` — Google web-app shortcuts
- `install-mission-center.sh` — Mission Center system monitor
- `install-vlc.sh` — VLC media player
- `install-flameshot.sh` — screenshot tool

### Comms
- `install-slack.sh`, `install-discord.sh`, `install-zoom.sh`, `install-signal.sh`

### Networking / sync
- `install-tailscale.sh` — Tailscale mesh VPN
- `install-syncthing.sh` — Syncthing (enabled as a per-user systemd service)

### Databases
- `install-postgres.sh` — PostgreSQL + `postgresql-contrib` + `pgcli`. Creates a Postgres role and DB matching your Linux user.

### Languages & runtimes
- `install-python.sh` — System Python 3 + pip + venv (apt)
- `install-pyenv.sh` — pyenv + a pinned Python build (default 3.12.7)
- `install-uv.sh` — uv: fast Python package/project manager (recommended for new projects)
- `install-sdkman.sh` — SDKMAN! for managing JDKs/Gradle/Maven/etc.
- `install-go.sh` — Go from the official tarball (default 1.23.4)
- `install-nodejs.sh` — Node.js via nvm (default LTS)

### Local LLMs
- `install-ollama.sh` — Ollama (CLI + systemd service)
- `install-lmstudio.sh` — LM Studio AppImage + desktop launcher
- `install-llamacpp.sh` — llama.cpp built from source. Default backend is **Vulkan** (`BACKEND=vulkan`); also supports `cpu`, `cuda`, `hip`. Symlinks `llama-cli` / `llama-server` / etc. into `~/.local/bin`.

### Terminal / shell
- `install-modern-cli.sh` — bundle: ripgrep, fd, bat, eza, fzf, zoxide, git-delta, jq, yq, tree, htop, ncdu. Adds aliases (`fd`, `bat`) and zoxide init to `~/.bashrc`.
- `install-starship.sh` — Starship prompt with the Gruvbox Rainbow preset; sets CaskaydiaCove Nerd Font Mono as the GNOME Terminal default font.
- `install-nerd-fonts.sh` — FiraCode, JetBrainsMono, Hack, Meslo, CascadiaCode (Nerd Fonts)
- `install-btop.sh` — btop process/resource monitor

### GPU monitoring
- `install-nvtop.sh` — nvtop (NVIDIA + AMD)
- `install-radeontop.sh` — radeontop (AMD)
- `install-amdgpu-top.sh` — amdgpu-top (AMD)

## Notes

- Scripts assume Ubuntu and use `apt-get`. They use `sudo` where needed.
- Most scripts append shell-init blocks to `~/.bashrc` (pyenv, sdkman, nvm, go, uv). Open a new shell or `source ~/.bashrc` after running.
- Pinned-version downloads (LM Studio, Go, AMD drivers) **will go stale** — check the upstream source and override the version env var when needed. `update-versions.sh` automates this for Go, nvm, Python, and Nerd Fonts; LM Studio and AMD drivers are still manual.
- `install-amd-drivers.sh` installs ROCm by default (`USECASE=graphics,rocm`). If you only want graphics, use `USECASE=graphics`.
- On a brand-new Ubuntu LTS release, `install-amd-drivers.sh` and `install-docker-desktop.sh` may fail until AMD/Docker publish packages for the new codename.
