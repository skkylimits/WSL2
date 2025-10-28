# Working Outline — WSL2 Development Environment Setup

**Project:** WSL2 Automated Installation & Configuration System
**Repository:** https://github.com/skkylimits/WSL2.git
**Current Phase:** v0.4 — Meta-Proof Workflow & Project Infrastructure
**Last Updated:** 2025-10-28

---

## Project Directory Structure

```
WSL2/
├── src/
│   ├── AI/                          # AI workflow documentation
│   │   ├── HOW-TO-SUPERPOWER.md     # NetworkChuck Meta-Proof workflow
│   │   ├── HOW-TO-CLAUDE.md         # Claude context
│   │   ├── HOW-TO-GEMINI.mD         # Gemini context
│   │   └── HOW-TO-GPT.md            # GPT/Codex context
│   ├── run.sh                       # Primary installation script (idempotent)
│   └── setup.sh                     # Modular installation framework
│
├── trash/                           # Deprecated/archived content
│   └── trash.md
│
├── CLAUDE.md                        # Claude Code context file
├── AGENTS.md                        # Generic AI agents context file
├── GEMINI.md                        # Gemini context file
├── .giminiignore                    # Gemini ignore patterns
├── commandful.md                    # CLI command reference
├── session-summary.md               # Current session technical summary
├── working-outline.md               # This file - project structure overview
├── README.md                        # Project documentation (to be created)
└── GIT_REMOTE                       # Git remote configuration (to be created)
```

---

## Core Components

### 1. Installation Scripts

#### `src/run.sh` (Primary Script)
**Purpose:** Automated WSL2 development environment provisioning
**Execution Mode:** Idempotent (safe to re-run)
**Logging Style:** Silent with status indicators

**Installation Pipeline:**
```
1. Shell configuration (.bashrc, .bash_aliases, .bash_logout)
2. APT packages (cmatrix, htop, curl, git, wget, jq, nmap, net-tools)
3. Version managers (nvm, pnpm, pyenv)
4. Python LTS (3.12.6 via pyenv)
5. Docker Engine (CLI-only)
6. Python packages (pipenv, requests, pipx)
```

**Key Features:**
- Strict error handling (`set -euo pipefail`)
- Automatic pyenv dependency resolution
- Clean logging format: `[i]` info, `[#]` success, `[!]` warning, `[x]` error
- Timed execution with summary

#### `src/setup.sh` (Modular Framework)
**Purpose:** Function-based installer library
**Usage:** Import functions for custom installation scripts

**Available Functions:**
- `install_apt()` — APT package installation
- `install_pip()` — Python pip packages (user-level)
- `install_go()` — Go modules
- `install_cargo()` — Rust crates
- `install_npm()` — npm global packages
- `install_bin()` — Generic binary installer (custom commands)
- `install_gitrepos()` — Git repository cloner

---

### 2. Context Files (AI Synchronization)

All three context files (`CLAUDE.md`, `AGENTS.md`, `GEMINI.md`) contain **identical** content to ensure cross-AI consistency.

**Content Sections:**
1. Repository Overview
2. Core Setup Scripts
3. Installation Directory Structure
4. Python Environment Management
5. Node.js Environment
6. Docker Configuration
7. Common Commands Reference
8. Development Workflow
9. Modifying Installation Scripts
10. Important Notes

**Purpose:** Enable any AI assistant to understand project architecture without context drift.

---

### 3. Documentation Files

#### `commandful.md`
**Purpose:** Quick reference for useful CLI commands

**Categories:**
- Network diagnostics (`netstat`, port scanning)
- Process management (`pidof`, `kill`, `killall`)
- Node.js cleanup (`npx npkill`)
- WSL2 VM configuration (nested virtualization)
- Sudo shortcuts (`sudo!!`)

#### `session-summary.md`
**Purpose:** Technical summary of current development session

**Content:**
- Session activities (what was done)
- Technical decisions (why it was done)
- Current project status
- Outstanding actions
- Learned lessons
- Session metrics

#### `working-outline.md` (This File)
**Purpose:** Project structure overview and component documentation

---

### 4. AI Workflow System

#### Meta-Proof Workflow (Inspired by NetworkChuck)
**Concept:** Self-managing project with AI-driven synchronization

**Components:**
1. **Session Closer Agent** — End-of-session sync & Git commit
2. **Context Sync** — CLAUDE.md ↔ AGENTS.md ↔ GEMINI.md
3. **Brutal Critic** — Self-review agent for quality assurance (planned)
4. **Git Versioning** — All changes, ideas, and conversations tracked

**Current Implementation:**
- `wsl-project-update` agent (Claude native)
- 6-phase update protocol (see agent instructions)

---

## Installation Paths Reference

| Tool Type | Installation Path | Manager |
|-----------|-------------------|---------|
| APT packages | `/usr/bin` | apt (system) |
| pip (user) | `~/.local/bin` | pip3 --user |
| npm (global) | `/usr/local/bin` or `~/.npm-global/bin` | npm |
| pyenv | `~/.pyenv/` | pyenv |
| nvm | `~/.nvm/` | nvm |
| pnpm | Shell configured | pnpm |
| go binaries | `~/go/bin` | go install |
| cargo binaries | `~/.cargo/bin` | cargo install |
| docker | `/usr/bin` | apt (system) |
| custom tools | `/opt/tools/<tool>` | manual + symlinks |
| git repos | `/opt/repos/<repo>` | git clone |

**Expected PATH order:**
```bash
$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:/opt/tools/bin:$PATH
```

---

## Development Workflow

### Phase 1: Initial Setup
```bash
git clone https://github.com/skkylimits/WSL2.git
cd WSL2
chmod +x src/run.sh
./src/run.sh
```

### Phase 2: Post-Installation
```bash
# Restart terminal or reload shell
source ~/.bashrc

# Activate Docker group (choose one)
newgrp docker          # Immediate activation
# OR
logout && login        # Permanent activation

# Verify installations
docker --version
python --version       # Should show pyenv version
node --version
```

### Phase 3: Development Session
```bash
# Make changes to scripts or documentation
# Use AI assistants with context files (CLAUDE.md, GEMINI.md, etc.)
# Test changes
# Commit regularly
```

### Phase 4: Session Close
```bash
# Run session closer agent (future automation)
# OR manually:
# 1. Update session-summary.md
# 2. Update working-outline.md
# 3. Sync context files
# 4. Create README.md
# 5. Git commit & push
```

---

## Version History

### v0.4 (Current) — Meta-Proof Infrastructure
- Added AI context synchronization (CLAUDE.md, AGENTS.md, GEMINI.md)
- Created `src/AI/` documentation directory
- Implemented `wsl-project-update` agent
- Added session-summary workflow
- Enhanced commandful.md with VM nested virtualization

### v0.3 — Python & Docker
- Implemented Python LTS installation via pyenv
- Added Docker Engine installation (CLI-only)
- Resolved pyenv dependency auto-installation

### v0.2 — Version Managers
- Added nvm installation
- Added pnpm installation with .bashrc cleanup
- Implemented pyenv support

### v0.1 — Foundation
- Created `src/run.sh` with APT packages
- Implemented shell configuration sync from github.com/skkylimits/.bashrc
- Basic logging and error handling

---

## Known Issues & Limitations

### Docker
- Requires logout/login or `newgrp docker` after installation
- No Docker Desktop support (CLI-only by design)
- Nested virtualization must be enabled in Hyper-V for VM scenarios

### Python
- System Python (`/usr/bin/python3`) must remain (WSL dependency)
- pipx must be installed via pyenv Python, NOT system apt
- pyenv shims must be in PATH before system Python

### pnpm
- Auto-appends code to .bashrc during installation
- `run.sh` automatically removes these additions (custom implementation)

---

## Future Roadmap

### Short-term (v0.5)
- [ ] Implement brutal-critic agent for script review
- [ ] Test complete session-closer workflow
- [ ] Create comprehensive README.md
- [ ] Add CI/CD testing (GitHub Actions)

### Mid-term (v0.6)
- [ ] Implement multi-environment support (detect Ubuntu/Debian/etc.)
- [ ] Add rollback functionality
- [ ] Create installation profile system (minimal, standard, full)
- [ ] Automated testing suite

### Long-term (v1.0)
- [ ] GUI installer option
- [ ] Windows Terminal integration
- [ ] Dotfiles management system
- [ ] Plugin architecture for custom installers

---

## References

- **Repository:** https://github.com/skkylimits/WSL2
- **Shell configs:** https://github.com/skkylimits/.bashrc
- **Meta-Proof inspiration:** NetworkChuck's AI workflow system
- **WSL2 docs:** https://learn.microsoft.com/en-us/windows/wsl/

---

**Maintained by:** skkylimits
**Last Session:** 2025-10-28
**Status:** Active development
