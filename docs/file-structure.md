# Repository File Structure

This document describes the complete file structure of the WSL2 setup repository.

## Overview

```
WSL2/
├── 📄 Configuration Files (Root)
├── 📁 docs/              # All documentation
├── 📁 scripts/           # All executable scripts
│   ├── install/          # Installation scripts
│   └── wsl/              # WSL management scripts
├── 📁 tests/             # Test scripts
├── 📁 .github/           # GitHub workflows and CI/CD
└── 📁 trash/             # Deprecated/archived files
```

---

## Root Directory

### Core Files
- `README.md` — Main project documentation and user guide
- `package.json` — npm/pnpm scripts for testing and development
- `pnpm-lock.yaml` — pnpm dependency lock file
- `Dockerfile` — Multi-stage Docker build for testing

### Git Configuration
- `GIT_REMOTE` — Remote repository URL tracker

### AI Context Files
- `CLAUDE.md` — Context file for Claude Code AI assistant
- `AGENTS.md` — Generic context file for AI agents
- `GEMINI.md` — Context file for Gemini AI

All three AI context files contain identical content and are synchronized to ensure cross-AI consistency.

### Docker Configuration
- `.dockerignore` — Files to exclude from Docker builds
- `.actrc` — Configuration for `act` (local GitHub Actions runner)
- `.giminiignore` — Gemini-specific exclusions

---

## 📁 `docs/` — Documentation

Centralized location for all project documentation.

### User Documentation
- `QUICKSTART.md` — Fast-track installation guide
- `TESTING.md` — Testing workflow and methodologies
- `setup-guide.md` — Detailed setup instructions
- `checklist.md` — Installation verification checklist

### Developer Documentation
- `file-structure.md` — This file
- `session-summary.md` — Technical summary of development sessions
- `working-outline.md` — Project structure and component overview

---

## 📁 `scripts/` — Executable Scripts

All executable scripts organized by purpose.

### `scripts/install/` — Installation Scripts

**Primary installer:**
- `run.sh` — Main automated setup script
  - Installs: shell configs, APT packages, nvm, pnpm, pyenv, Python, Docker, pip packages
  - Silent execution with clean logging
  - Idempotent (safe to re-run)
  - Usage: `chmod +x scripts/install/run.sh && ./scripts/install/run.sh`

**Modular framework:**
- `setup.sh` — Function-based installer library
  - Available functions: `install_apt()`, `install_pip()`, `install_go()`, `install_cargo()`, `install_npm()`, `install_bin()`, `install_gitrepos()`
  - Designed for custom installation scripts
  - Source with: `source scripts/install/setup.sh`

### `scripts/wsl/` — WSL Management

Scripts for managing WSL2 instances on Windows.

- `setup-wsl2.sh` — WSL2 instance configuration script
- `again.sh` — WSL instance re-initialization/reset helper
- `reset-wsl2.ps1` — PowerShell script to reset WSL2 from tarball
  - Unregisters and re-imports Ubuntu from clean backup
  - Usage: Run in PowerShell as Administrator

---

## 📁 `tests/` — Testing Scripts

Scripts for validating installations locally and in CI.

### Docker-based Tests
- `test-local.sh` — Local Docker testing with layer caching
  - Quick mode: Test only APT packages (~10 seconds)
  - Full mode: Test complete setup (~50 seconds)
  - Usage: `./tests/test-local.sh [stage] [quick]`
  - Examples:
    - `./tests/test-local.sh apt-packages quick` — Quick test
    - `./tests/test-local.sh final` — Full test

### GitHub Actions Local Testing
- `test-with-act.sh` — Local CI simulation with `act`
  - Requires `act` installed: `curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash`
  - Modes: `quick`, `full`, `list`
  - Usage: `./tests/test-with-act.sh [mode]`
  - Examples:
    - `./tests/test-with-act.sh quick` — Quick test
    - `./tests/test-with-act.sh full` — Full CI simulation

---

## 📁 `.github/` — GitHub Configuration

GitHub-specific configuration and workflows.

### Workflows
- `workflows/test.yml` — CI/CD pipeline for automated testing
  - Jobs:
    - `test-setup` — Full installation test with caching
    - `quick-test` — Fast test for new packages only
  - Caching strategies: APT, pyenv, nvm, pnpm
  - Triggers: push, pull_request, workflow_dispatch

---

## 📁 `trash/` — Archived Files

Deprecated or superseded files kept for reference.

- `commandful.md` — Old command reference (merged into README.md)
- `trash.md` — General deprecated content
- `old-build-workflow.yml` — Superseded GitHub Actions workflow

---

## File Naming Conventions

### Scripts (`.sh`)
- **Kebab-case:** `setup-wsl2.sh`, `test-local.sh`
- **Executable:** All shell scripts should have executable permissions
- **Strict mode:** All scripts use `set -euo pipefail`

### Documentation (`.md`)
- **UPPERCASE:** Root-level primary docs (`README.md`, `CLAUDE.md`)
- **kebab-case:** Subdirectory docs (`file-structure.md`, `setup-guide.md`)
- **PascalCase:** Avoid (legacy only)

### Configuration Files
- **Dotfiles:** `.dockerignore`, `.actrc`, `.giminiignore`
- **Standard:** `package.json`, `Dockerfile`, `GIT_REMOTE`

---

## Directory Structure Rationale

### Why `scripts/install/` and `scripts/wsl/`?
- **Clear separation:** Installation vs. WSL management
- **Scalability:** Easy to add new script categories (e.g., `scripts/maintenance/`)
- **Professional:** Industry-standard organization

### Why centralize docs in `docs/`?
- **Single source of truth:** All documentation in one place
- **Easy to navigate:** No scattered README files
- **Git-friendly:** Clear history for documentation changes

### Why separate `tests/` folder?
- **CI/CD clarity:** Tests are distinct from production scripts
- **Isolation:** Test dependencies don't pollute main scripts
- **Modularity:** Easy to add new test types

---

## Installation Paths (Runtime)

After running `scripts/install/run.sh`, tools are installed to:

| Tool Type | Installation Path | Managed By |
|-----------|-------------------|------------|
| APT packages | `/usr/bin` | apt (system) |
| pip (user) | `~/.local/bin` | pip3 --user |
| npm (global) | `~/.npm-global/bin` | npm (user) |
| pyenv | `~/.pyenv/` | pyenv |
| nvm | `~/.nvm/` | nvm |
| pnpm | Configured in shell | pnpm |
| go binaries | `~/go/bin` | go install |
| cargo binaries | `~/.cargo/bin` | cargo install |
| docker | `/usr/bin` | apt (system) |

**Expected PATH order:**
```bash
$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:/opt/tools/bin:$PATH
```

---

## Development Workflow Mapping

### New User Setup
1. Clone repo
2. Read `README.md` (overview) → `docs/QUICKSTART.md` (fast start)
3. Run `scripts/install/run.sh`
4. Verify with `docs/checklist.md`

### Development Testing
1. Quick iteration: `pnpm test` (uses `tests/test-local.sh`)
2. Full validation: `pnpm test:full`
3. CI simulation: `pnpm run act`

### Adding New Tools
1. Edit `scripts/install/run.sh` (add to arrays)
2. Test with `pnpm test`
3. Update `README.md` and `CLAUDE.md`
4. Commit changes

### Documentation Updates
1. Edit relevant file in `docs/`
2. Keep AI context files synchronized (`CLAUDE.md`, `AGENTS.md`, `GEMINI.md`)
3. Update `docs/session-summary.md` if significant

---

## Cross-References

### Related Documentation
- **Installation guide:** `README.md` (sections: Quick Start, Architecture)
- **AI context:** `CLAUDE.md`, `AGENTS.md`, `GEMINI.md` (identical content)
- **Testing:** `docs/TESTING.md`
- **Meta-workflow:** Look for `src/AI/HOW-TO-SUPERPOWER.md` (if exists)

### Script Dependencies
- `scripts/install/run.sh` → Standalone (no dependencies)
- `scripts/install/setup.sh` → Sourced by custom scripts
- `tests/test-local.sh` → Requires Docker
- `tests/test-with-act.sh` → Requires `act` installed

---

## Maintenance Notes

### When Renaming/Moving Files
1. Update all references in:
   - `README.md`
   - `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`
   - `package.json` (scripts section)
   - `.github/workflows/test.yml`
   - `Dockerfile`
2. Update this file (`docs/file-structure.md`)
3. Test with `pnpm test` and `pnpm run act`

### When Adding New Directories
1. Update this document
2. Add glob patterns to `package.json` (lint/setup scripts)
3. Consider `.dockerignore` impact

---

**Last Updated:** 2025-11-01
**Repository Structure Version:** v1.0 (Post-Reorganization)
