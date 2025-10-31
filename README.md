# WSL2 Development Environment Setup

Automated installation and configuration system for bootstrapping a complete Ubuntu WSL2 development environment.

---

## Overview

This repository contains production-ready scripts for transforming a fresh WSL2 Ubuntu installation into a fully-configured development environment with modern tooling, version managers, and runtime environments.

**Current Version:** v0.4 — Meta-Proof Infrastructure
**Status:** Active Development
**Idempotence:** Safe to re-run all scripts

---

## Quick Start

```bash
# Clone the repository
git clone https://github.com/skkylimits/WSL2.git
cd WSL2

# Install pnpm dependencies and setup
pnpm install
pnpm run setup

# Run the automated setup
./src/run.sh
```

**Post-installation:**
```bash
# Reload your shell configuration
source ~/.bashrc

# Activate Docker group (choose one)
newgrp docker          # Immediate activation
# OR logout and login   # Permanent activation

# Verify installations
docker --version
python --version
node --version
```

---

## Development Scripts (pnpm)

All test and development commands are available via `pnpm run`:

### Testing (Quick Iteration)
```bash
pnpm test              # Quick test (10 seconds with cache!)
pnpm run test:quick    # Same as above
pnpm run test:full     # Full Docker test (~50 seconds)
pnpm run test:python   # Test up to Python stage
pnpm run test:node     # Test up to Node stage
```

### GitHub Actions (Local CI)
```bash
pnpm run act           # Quick CI test (~30 seconds)
pnpm run act:quick     # Same as above
pnpm run act:full      # Full CI simulation (~2 minutes)
pnpm run act:list      # List all available jobs
pnpm run act:ci        # Run specific test-setup job
```

### Docker Management
```bash
pnpm run build         # Build full image
pnpm run build:quick   # Build only APT packages (fast!)
pnpm run build:cache   # Build with cache optimization
pnpm run run           # Run container interactively
pnpm run run:mount     # Run with workspace mounted
```

### Linting
```bash
pnpm run lint          # Lint all shell scripts
pnpm run lint:shell    # Lint bash scripts with shellcheck
pnpm run lint:docker   # Lint Dockerfile with hadolint
pnpm run lint:fix      # Show lint fix suggestions
```

### Cleanup
```bash
pnpm run clean         # Clean Docker system
pnpm run clean:cache   # Clear Docker build cache
pnpm run clean:volumes # Remove act cache volumes
pnpm run clean:all     # Nuclear option (all caches)
```

### Utilities
```bash
pnpm run docker:stats  # Show Docker disk usage
pnpm run docker:images # List WSL2 setup images
pnpm run help          # List all available commands
```

**Pro tip:** Use `pnpm test` for 90% of your development. It's cached and takes only ~10 seconds!

---

## What Gets Installed

### Shell Configuration
- `.bashrc`, `.bash_aliases`, `.bash_logout` from [skkylimits/.bashrc](https://github.com/skkylimits/.bashrc)

### System Packages (APT)
- **Utilities:** cmatrix, htop, curl, git, wget, jq
- **Network:** nmap, net-tools

### Version Managers
- **nvm** — Node Version Manager
- **pnpm** — Fast, disk-efficient package manager
- **pyenv** — Python version manager

### Runtimes
- **Python 3.12.6** (via pyenv, with all build dependencies)
- **Node.js LTS** (installed via nvm)

### Container Platform
- **Docker Engine** (CLI-only, no Docker Desktop)
  - docker-ce, docker-ce-cli
  - containerd.io
  - docker-buildx-plugin, docker-compose-plugin

### Python Packages
- pipenv, requests, pipx

---

## Features

- **Idempotent Installations** — Safe to run multiple times, skips already-installed tools
- **Clean Logging** — Silent execution with clear status indicators:
  - `[i]` Information
  - `[#]` Success
  - `[!]` Warning
  - `[x]` Error
- **Strict Error Handling** — Scripts use `set -euo pipefail` for reliability
- **Automatic Dependencies** — pyenv build dependencies resolved automatically
- **Timed Execution** — Summary with total installation time

---

## Architecture

### Primary Script: `src/run.sh`
Complete automated installation pipeline for all tools and configurations.

### Modular Framework: `src/setup.sh`
Function-based installer library for custom installation scripts.

**Available Functions:**
- `install_apt()` — APT package installation
- `install_pip()` — Python pip packages (user-level)
- `install_go()` — Go modules
- `install_cargo()` — Rust crates
- `install_npm()` — npm global packages
- `install_bin()` — Generic binary installer with custom commands
- `install_gitrepos()` — Git repository cloner

---

## Installation Paths

| Tool Type | Installation Path | Managed By |
|-----------|-------------------|------------|
| APT packages | `/usr/bin` | apt (system) |
| pip (user) | `~/.local/bin` | pip3 --user |
| npm (global) | `~/.npm-global/bin` | npm (user) |
| pyenv | `~/.pyenv/` | pyenv |
| nvm | `~/.nvm/` | nvm |
| go binaries | `~/go/bin` | go install |
| cargo binaries | `~/.cargo/bin` | cargo install |
| docker | `/usr/bin` | apt (system) |

**Expected PATH order:**
```bash
$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:/opt/tools/bin:$PATH
```

---

## Python Environment

This setup uses **pyenv** for Python version management, NOT system Python.

**Key Points:**
- System Python (`/usr/bin/python3`) remains untouched (WSL dependency)
- pyenv Python installed to `~/.pyenv/versions/`
- Default version: Python 3.12.6
- pip packages installed with `--user` flag to `~/.local/bin`

**Switching Python Versions:**
```bash
pyenv shell <version>   # Current shell only
pyenv local <version>   # Current directory (.python-version file)
pyenv global <version>  # System-wide default
```

**Verify Setup:**
```bash
which python           # Should show ~/.pyenv/shims/python
python --version       # Should show 3.12.6
pyenv versions         # List all installed versions
```

---

## Docker Configuration

Docker is installed **without Docker Desktop** — CLI-only via Docker Engine.

**Post-Installation Requirements:**
- User is added to docker group automatically
- **Action required:** Logout/login OR run `newgrp docker` to activate group membership
- Manual `docker login` may be needed for private registries

**Verify Docker:**
```bash
docker --version
docker run hello-world
```

**For Nested Virtualization (VM scenarios):**
```powershell
# Run in PowerShell as Administrator (on Windows host)
Set-VMProcessor -VMName "YOUR-VM-NAME" -ExposeVirtualizationExtensions $true
```

---

## Node.js Environment

**Version Manager:** nvm (Node Version Manager)

**Install Node LTS:**
```bash
nvm install --lts
```

**Package Managers:**
- **Primary:** pnpm (fast, disk-efficient)
- **Available:** npm (bundled with Node)

**Create New Projects:**
```bash
pnpm create vite                               # Vite project
pnpm install nuxi@latest && pnpx nuxi init     # Nuxt project
```

---

## Project Management

This repository follows the **Meta-Proof workflow** inspired by NetworkChuck's AI project management system.

**Documentation Files:**
- `docs/session-summary.md` — Technical summary of current development session
- `docs/working-outline.md` — Project structure and component overview
- `src/AI/HOW-TO-SUPERPOWER.md` — Meta-Proof workflow explanation

**AI Context Files:**
- `CLAUDE.md` — Claude Code context
- `AGENTS.md` — Generic AI agents context
- `GEMINI.md` — Gemini context

All context files are synchronized and contain identical content for cross-AI consistency.

---

## Useful Commands Reference

### Network & Ports

**Check port services:**
```bash
cat /etc/services
grep -w '80/tcp' /etc/services
grep -w '443/tcp' /etc/services
grep -E -w '22/(tcp|udp)' /etc/services
```

**List open ports:**
```bash
netstat -tulpn
sudo netstat -tulpn | grep LISTEN
```

### Process Management

**Find process ID:**
```bash
pidof appname
```

**Kill process by PID:**
```bash
kill -9 <pid>
```

**Kill process by name:**
```bash
killall -9 appname
```

### Node.js Development

**Remove all node_modules recursively (interactive):**
```bash
npx npkill
```

### Shell Shortcuts

**Run last command with sudo:**
```bash
sudo!!
```

**Drag and drop file/folder to paste path:**
Simply drag a file or folder into your terminal to paste its full path.

### Docker (WSL2/VM)

**Enable nested virtualization (PowerShell as Admin on Windows host):**
```powershell
Set-VMProcessor -VMName "YOUR-VM-NAME" -ExposeVirtualizationExtensions $true
```

---

## Customization

### Adding Tools to `src/run.sh`

**1. APT Packages:**
```bash
APT_PACKAGES=(
    curl git wget
    your-new-package    # Add here
)
```

**2. Curl Installers:**
```bash
CURL_INSTALLERS=(
    "command::install_script_url"
)
```

**3. With Dependencies:**
```bash
CURL_DEPENDENCIES=(
    "toolname::dep1 dep2 dep3"
)
```

### Using `src/setup.sh` Functions

```bash
#!/bin/bash
source src/setup.sh

# Define packages
APT_PACKAGES=(htop vim)
PIP_PACKAGES=(requests flask)
GO_PACKAGES=(github.com/example/tool@latest)

# Install
install_apt "${APT_PACKAGES[@]}"
install_pip "${PIP_PACKAGES[@]}"
install_go "${GO_PACKAGES[@]}"
```

---

## Known Limitations

### Docker
- Requires logout/login or `newgrp docker` after installation
- No Docker Desktop support (CLI-only by design)
- Nested virtualization must be enabled for VM scenarios

### Python
- System Python must remain (WSL system dependency)
- pipx must be installed via pyenv Python, NOT system apt
- pyenv shims must be in PATH before system Python

### pnpm
- Installation auto-appends code to `.bashrc`
- `run.sh` automatically removes these additions

---

## Troubleshooting

### Docker "Permission Denied"
```bash
# Solution 1: Activate docker group
newgrp docker

# Solution 2: Logout and login again

# Verify group membership
groups | grep docker
```

### Python Version Not Switching
```bash
# Verify pyenv in PATH
echo $PATH | grep pyenv

# Reload shell configuration
source ~/.bashrc

# Check pyenv versions
pyenv versions
pyenv global 3.12.6
```

### Command Not Found After Installation
```bash
# Reload shell configuration
source ~/.bashrc

# Verify PATH
echo $PATH

# Check installation location
which <command>
```

---

## Contributing

Contributions are welcome! Please ensure:
- Scripts remain idempotent
- Use strict error handling (`set -euo pipefail`)
- Follow existing logging format
- Test on fresh WSL2 Ubuntu installation
- Update documentation (CLAUDE.md, AGENTS.md, GEMINI.md)

---

## Version History

### v0.4 (Current) — Meta-Proof Infrastructure
- AI context synchronization system (CLAUDE.md, AGENTS.md, GEMINI.md)
- Meta-Proof workflow documentation (`src/AI/` directory)
- Session management agent (`wsl-project-update`)
- Nested virtualization documentation

### v0.3 — Python & Docker
- Python LTS installation via pyenv
- Docker Engine installation (CLI-only)
- pyenv dependency auto-resolution

### v0.2 — Version Managers
- nvm installation
- pnpm installation with .bashrc cleanup
- pyenv support

### v0.1 — Foundation
- `src/run.sh` with APT packages
- Shell configuration sync
- Basic logging and error handling

---

## Resources

- **Repository:** https://github.com/skkylimits/WSL2
- **Shell Configs:** https://github.com/skkylimits/.bashrc
- **WSL2 Documentation:** https://learn.microsoft.com/en-us/windows/wsl/
- **Meta-Proof Workflow:** See `src/AI/HOW-TO-SUPERPOWER.md`

---

## License

MIT License — See LICENSE file for details.

---

## Maintainer

**skkylimits**
GitHub: [@skkylimits](https://github.com/skkylimits)

---

**Last Updated:** 2025-10-28
**Current Phase:** Active Development — v0.4
