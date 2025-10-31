# GEMINI.md

This file provides guidance to Gemini (Google's AI assistant) when working with code in this repository.

## Repository Overview

This is a WSL2 (Windows Subsystem for Linux) development environment setup repository. It contains automated installation scripts for bootstrapping a fresh Ubuntu WSL2 instance with development tools, package managers, and runtime environments.

## Core Setup Scripts

### Primary Installation Script: `src/run.sh`

This is the main automated setup script that provisions a complete development environment.

**Usage:**
```bash
chmod +x src/run.sh
./src/run.sh
```

**What it installs:**
- Shell configuration files (.bashrc, .bash_aliases, .bash_logout) from https://github.com/skkylimits/.bashrc
- APT packages: cmatrix, htop, curl, git, wget, jq, nmap, net-tools, pipx
- Version managers via curl:
  - nvm (Node Version Manager)
  - pnpm (Node package manager)
  - pyenv (Python version manager)
- Python LTS (3.12.6) via pyenv with build dependencies
- Docker Engine (CLI-only, no Docker Desktop)
- pip packages: pipenv, requests, pipx

**Key features:**
- Uses strict mode (`set -euo pipefail`)
- Silent installation with clean logging ([i] info, [#] success, [!] warning, [x] error)
- Automatic dependency resolution for pyenv
- Idempotent - safe to run multiple times
- Timed execution with summary

**Docker post-install:**
After running the script, the user needs to:
- Log out and back in OR run `newgrp docker` to activate docker group membership
- Run `docker login` manually if needed

### Modular Installation Framework: `src/setup.sh`

A refactored, function-based installer framework with separate functions for each package manager.

**Available functions:**
- `install_apt()` - APT package installation
- `install_pip()` - Python pip packages (user-level with --user flag)
- `install_go()` - Go modules via `go install`
- `install_cargo()` - Rust crates via `cargo install`
- `install_npm()` - npm global packages
- `install_bin()` - Generic binary installer with custom commands
- `install_gitrepos()` - Git repository cloner

**Usage pattern:**
```bash
# Define arrays at top of script
APT_PACKAGES=(curl git wget)
PIP_PACKAGES=(requests)
GO_PACKAGES=(github.com/example/tool@latest)

# Call installer functions
install_apt "${APT_PACKAGES[@]}"
install_pip "${PIP_PACKAGES[@]}"
install_go "${GO_PACKAGES[@]}"
```

## Installation Directory Structure

The repository follows a clean separation between system-managed and user-managed tools:

| Tool Type | Installation Path | Managed By |
|-----------|-------------------|------------|
| APT packages | `/usr/bin` | apt (system) |
| pip (user) | `~/.local/bin` | pip3 --user |
| npm (global) | `/usr/local/bin` | npm (root) or `~/.npm-global/bin` (user) |
| pyenv | `~/.pyenv/` | pyenv |
| nvm | `~/.nvm/` | nvm |
| pnpm | Configured in shell | pnpm |
| go binaries | `~/go/bin` | go install |
| cargo binaries | `~/.cargo/bin` | cargo install |
| docker | `/usr/bin` | apt (system) |
| custom tools | `/opt/tools/<tool>` | manual (with symlinks to `/usr/local/bin`) |
| git repos | `/opt/repos/<repo>` | manual clones |

**PATH order (as expected in .bashrc):**
```bash
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:/opt/tools/bin:$PATH"
```

## Python Environment Management

This repository uses **pyenv** for Python version management, NOT system Python.

**Key points:**
- System Python (`/usr/bin/python3`) is never removed (WSL depends on it)
- pyenv Python is installed to `~/.pyenv/versions/`
- Default Python version: 3.12.6 (set via `pyenv global 3.12.6`)
- pip packages installed with `--user` flag to `~/.local/bin`
- pipx installed via pyenv Python, NOT system apt

**Switching Python versions:**
```bash
pyenv shell <version>   # Current shell only
pyenv local <version>   # Current directory (creates .python-version)
pyenv global <version>  # System-wide default
```

**Verifying setup:**
```bash
which python    # Should show ~/.pyenv/shims/python
python --version
pyenv versions
```

## Node.js Environment

Uses **nvm** (Node Version Manager) for Node.js version management.

**Installation of Node LTS:**
```bash
nvm install --lts
```

**Package manager:**
- Primary: **pnpm** (installed via curl, removes auto-appended .bashrc code)
- Available: npm (comes with Node)

**Creating new projects:**
```bash
pnpm create vite      # Vite projects
pnpm install nuxi@latest && pnpx nuxi init  # Nuxt projects
```

## Docker

Docker is installed **without Docker Desktop** - CLI only via Docker Engine.

**Installation includes:**
- docker-ce, docker-ce-cli
- containerd.io
- docker-buildx-plugin, docker-compose-plugin

**User setup:**
- User is added to docker group: `sudo usermod -aG docker $USER`
- Requires logout/login or `newgrp docker` to take effect
- Manual `docker login` may be needed

## Common Commands Reference

See the **"Useful Commands Reference"** section in `README.md` for comprehensive CLI commands:

**Network diagnostics:**
```bash
netstat -tulpn | grep LISTEN  # List open ports
```

**Process management:**
```bash
pidof <appname>      # Find process ID
kill -9 <pid>        # Force kill by PID
killall -9 <appname> # Force kill by name
```

**Node.js cleanup:**
```bash
npx npkill  # Interactive removal of node_modules directories
```

**Run last command with sudo:**
```bash
sudo!!
```

## Development Workflow

1. **Initial Setup:**
   ```bash
   git clone <this-repo>
   cd WSL2
   chmod +x src/run.sh
   ./src/run.sh
   ```

2. **Shell Configuration:**
   - After setup, restart terminal or: `source ~/.bashrc`
   - Custom aliases available from .bash_aliases

3. **Post-Installation:**
   - Verify installations: `docker --version`, `python --version`, `node --version`
   - Activate docker group: `newgrp docker` or logout/login
   - Set global Python: `pyenv global 3.12.6`

## Modifying Installation Scripts

When adding new tools to `src/run.sh`:

1. Add to appropriate array (APT_PACKAGES, CURL_INSTALLERS, PIP_PACKAGES)
2. For curl installers with dependencies, add to CURL_DEPENDENCIES array:
   ```bash
   CURL_DEPENDENCIES=(
     "toolname::pkg1 pkg2 pkg3"
   )
   ```
3. Format for CURL_INSTALLERS: `"command::install_script"`

When using `src/setup.sh` functions:
- Define arrays at the top
- Call installer functions in main()
- Use `install_bin()` for tools requiring custom install commands

## Important Notes

- All scripts use `set -euo pipefail` for strict error handling
- Installations are idempotent (safe to re-run)
- System Python is never removed (WSL dependency)
- pipx must be installed via pyenv Python, not apt
- pnpm install script automatically cleans up .bashrc additions
- Docker requires group activation after installation

## Project Meta-Documentation

This repository follows the **Meta-Proof workflow** inspired by NetworkChuck's AI project management system.

**Key Documentation Files:**
- `session-summary.md` — Technical summary of current development session
- `working-outline.md` — Project structure and component overview
- `README.md` — User-facing project documentation
- `src/AI/HOW-TO-SUPERPOWER.md` — Meta-Proof workflow explanation

**Context Synchronization:**
- This file (`GEMINI.md`) is synchronized with `CLAUDE.md` and `AGENTS.md`
- All three files contain identical content for cross-AI consistency
- Updates to one should be mirrored to all others

**Session Workflow:**
1. Development session with changes
2. Run `wsl-project-update` agent at session end
3. Agent updates: session-summary.md, working-outline.md, context files, README.md
4. Agent creates Git commit with session summary
5. Agent pushes to remote repository

## Current Project Status

**Version:** v0.4 — Meta-Proof Infrastructure
**Last Updated:** 2025-10-28
**Branch:** main
**Remote:** https://github.com/skkylimits/WSL2.git

**Recent Accomplishments:**
- AI context synchronization system implemented (CLAUDE.md, AGENTS.md, GEMINI.md)
- Meta-Proof workflow documentation added (`src/AI/` directory)
- Session management agent created (`wsl-project-update`)
- Nested virtualization support documented (for Docker-in-VM scenarios)

**Installation Script Status:**
- `src/run.sh` — Fully functional and tested
- Installs: shell configs, APT packages, nvm, pnpm, pyenv, Python 3.12.6, Docker, pip packages
- All installations are idempotent and silent with clean logging

**Next Steps:**
- Implement brutal-critic agent for automated script review
- Add CI/CD testing pipeline
- Create comprehensive README.md for end users
- Test complete session-closer workflow
