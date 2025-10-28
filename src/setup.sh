#!/usr/bin/env bash
set -euo pipefail

# -----------------------
# ASCII logger (no emoji)
# -----------------------
log_info()  { echo "[i] $*"; }
log_warn()  { echo "[!] $*"; }
log_ok()    { echo "[#] $*"; }
log_fail()  { echo "[x] $*" >&2; }

# -----------------------
# Helpers
# -----------------------
run_quiet() { "$@" >/dev/null 2>&1; }   # helper to suppress noisy output

# -----------------------
# APT installer
# -----------------------
install_apt() {
  local pkgs=("$@")
  if [ ${#pkgs[@]} -eq 0 ]; then
    log_info "No APT packages to install."
    return
  fi

  log_info "Ensuring apt cache is up-to-date..."
  sudo apt-get update -y >/dev/null 2>&1 || { log_warn "apt-get update failed (continuing)"; }

  for pkg in "${pkgs[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
      log_ok "APT: $pkg already installed."
    else
      log_info "APT: Installing $pkg ..."
      if sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$pkg" >/dev/null 2>&1; then
        log_ok "APT: $pkg installed."
      else
        log_fail "APT: Failed to install $pkg"
      fi
    fi
  done
}

# -----------------------
# pip installer (user)
# -----------------------
install_pip() {
  local pkgs=("$@")
  if [ ${#pkgs[@]} -eq 0 ]; then
    log_info "No pip packages to install."
    return
  fi

  # Prefer pip3
  local PIP_CMD="pip3"
  if ! command -v "$PIP_CMD" >/dev/null 2>&1; then
    log_warn "pip3 not found, attempting to install python3-pip via apt..."
    sudo apt-get update -y >/dev/null 2>&1 || true
    sudo apt-get install -y python3-pip >/dev/null 2>&1 || { log_fail "Could not install python3-pip"; return 1; }
  fi

  for pkg in "${pkgs[@]}"; do
    if "$PIP_CMD" show "$pkg" >/dev/null 2>&1; then
      log_ok "pip: $pkg already installed."
    else
      log_info "pip: Installing $pkg ..."
      if "$PIP_CMD" install --user "$pkg" >/dev/null 2>&1; then
        log_ok "pip: $pkg installed (user)."
      else
        log_fail "pip: Failed to install $pkg"
      fi
    fi
  done
}

# -----------------------
# go installer (go install pkg@ver)
# -----------------------
install_go() {
  local pkgs=("$@")
  if [ ${#pkgs[@]} -eq 0 ]; then
    log_info "No Go packages to install."
    return
  fi

  if ! command -v go >/dev/null 2>&1; then
    log_warn "go not found. Attempt apt-get install golang? Installing golang-go..."
    sudo apt-get update -y >/dev/null 2>&1 || true
    sudo apt-get install -y golang-go >/dev/null 2>&1 || { log_fail "Could not install golang-go"; return 1; }
  fi

  for mod in "${pkgs[@]}"; do
    # Extract binary name guess from module path (last path element)
    local binname
    binname="$(basename "${mod%%@*}")"

    if command -v "$binname" >/dev/null 2>&1; then
      log_ok "go: $binname already present."
      continue
    fi

    log_info "go: Installing $mod ..."
    if go install "$mod" >/dev/null 2>&1; then
      log_ok "go: $mod installed (bin: $binname)."
    else
      log_fail "go: Failed to install $mod"
    fi
  done
}

# -----------------------
# cargo installer
# -----------------------
install_cargo() {
  local pkgs=("$@")
  if [ ${#pkgs[@]} -eq 0 ]; then
    log_info "No Cargo packages to install."
    return
  fi

  if ! command -v cargo >/dev/null 2>&1; then
    log_warn "cargo not found. Attempting to install via apt (rustc & cargo)..."
    sudo apt-get update -y >/dev/null 2>&1 || true
    sudo apt-get install -y cargo >/dev/null 2>&1 || { log_fail "Could not install cargo"; return 1; }
  fi

  for crate in "${pkgs[@]}"; do
    local binname
    binname="$(basename "$crate")"
    if command -v "$binname" >/dev/null 2>&1; then
      log_ok "cargo: $binname already present."
      continue
    fi

    log_info "cargo: Installing $crate ..."
    if cargo install "$crate" >/dev/null 2>&1; then
      log_ok "cargo: $crate installed."
    else
      log_fail "cargo: Failed to install $crate"
    fi
  done
}

# -----------------------
# npm installer (global)
# -----------------------
install_npm() {
  local pkgs=("$@")
  if [ ${#pkgs[@]} -eq 0 ]; then
    log_info "No npm packages to install."
    return
  fi

  if ! command -v npm >/dev/null 2>&1; then
    log_warn "npm not found, installing nodejs & npm..."
    sudo apt-get update -y >/dev/null 2>&1 || true
    sudo apt-get install -y nodejs npm >/dev/null 2>&1 || { log_fail "Could not install npm"; return 1; }
  fi

  for pkg in "${pkgs[@]}"; do
    # binary check: try package name as binary
    local binname
    binname="$(basename "$pkg")"
    if command -v "$binname" >/dev/null 2>&1; then
      log_ok "npm: $binname already present."
      continue
    fi

    log_info "npm: Installing $pkg globally..."
    if sudo npm install -g "$pkg" >/dev/null 2>&1; then
      log_ok "npm: $pkg installed."
    else
      log_fail "npm: Failed to install $pkg"
    fi
  done
}

# -----------------------
# Generic binary installer via 'command -v' plus optional install command
# -----------------------
# usage: install_bin "binaryname" "install-cmd (string to eval if missing)"
install_bin() {
  local binname="$1"; shift
  local install_cmd="${*:-}"

  if command -v "$binname" >/dev/null 2>&1; then
    log_ok "bin: $binname already present."
    return
  fi

  if [ -z "$install_cmd" ]; then
    log_fail "bin: $binname missing and no install command provided."
    return 1
  fi

  log_info "bin: Installing $binname ..."
  # shellcheck disable=SC2086
  if eval "$install_cmd" >/dev/null 2>&1; then
    log_ok "bin: $binname installed."
  else
    log_fail "bin: Failed to install $binname"
  fi
}

# -----------------------
# Git clone installer
# -----------------------
# repo entries as "https://github.com/user/repo.git:/opt/tools/repo"
install_gitrepos() {
  local entries=("$@")
  for e in "${entries[@]}"; do
    IFS=':' read -r repo dest <<<"$e"
    if [ -z "$repo" ] || [ -z "$dest" ]; then
      log_warn "gitrepo: invalid entry '$e' (expected repo:dest)"
      continue
    fi

    if [ -d "$dest" ]; then
      log_ok "gitrepo: $dest already exists."
      continue
    fi

    log_info "gitrepo: Cloning $repo -> $dest ..."
    if sudo mkdir -p "$(dirname "$dest")" >/dev/null 2>&1; then
      if sudo git clone --depth 1 "$repo" "$dest" >/dev/null 2>&1; then
        log_ok "gitrepo: Cloned $repo"
      else
        log_fail "gitrepo: Failed to clone $repo"
      fi
    else
      log_fail "gitrepo: Could not create parent dir for $dest"
    fi
  done
}

# -----------------------
# -----------------------
# Dummy arrays (fill these with your real tools later)
# -----------------------
APT_PACKAGES=(cmatrix htop curl git wget)
PIP_PACKAGES=(pwntools requests)                           # pip package names
GO_PACKAGES=(github.com/project/cooltool@latest)          # modules for `go install`
CARGO_PACKAGES=(ripgrep)                                  # crates for `cargo install`
NPM_PACKAGES=(http-server)                                # npm package names
BIN_COMMANDS=(gobuster)                                   # binaries name(s) to check
# For binaries that need a specific install command, use associative-like pairs below
# Format: "binaryname::install command"
BIN_INSTALL_CMDS=(
  "gobuster::go install github.com/OJ/gobuster/v3@latest"
  "ffuf::go install github.com/ffuf/ffuf@latest"
)
# Git repos to clone (format: repo-url:destination-folder)
GIT_REPOS=(
  "https://github.com/example/tool.git:/opt/tools/tool"
)

# -----------------------
# Runner: apply installs
# -----------------------
main() {
  log_info "Starting tool installation run."

  # APT packages
  install_apt "${APT_PACKAGES[@]}"

  # pip packages
  install_pip "${PIP_PACKAGES[@]}"

  # go modules
  install_go "${GO_PACKAGES[@]}"

  # cargo crates
  install_cargo "${CARGO_PACKAGES[@]}"

  # npm packages
  install_npm "${NPM_PACKAGES[@]}"

  # Generic binaries with simple command - if exist, skip
  for b in "${BIN_COMMANDS[@]}"; do
    if command -v "$b" >/dev/null 2>&1; then
      log_ok "bin list: $b already present."
    else
      # find install command in BIN_INSTALL_CMDS
      local found=""
      for pair in "${BIN_INSTALL_CMDS[@]}"; do
        if [[ "$pair" == "$b::*" ]] || [[ "$pair" == "$b::"* ]]; then
          found="${pair#*::}"
          break
        fi
      done

      if [ -n "$found" ]; then
        install_bin "$b" "$found"
      else
        log_warn "bin list: $b missing and no install command configured."
      fi
    fi
  done

  # git repos
  install_gitrepos "${GIT_REPOS[@]}"

  log_info "Tool installation run finished."
}

# If script executed directly, run main
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  main "$@"
fi



section() {
  local title="$1"
  echo
  echo "============================================================="
  echo "[>] $title"
  echo "============================================================="
}

# Gebruik:
section "APT PACKAGE INSTALLATION"
section "CURL-BASED INSTALLERS"
echo
echo "-------------------------------------------------------------"
echo "[>] INSTALLATION SUMMARY"
echo "-------------------------------------------------------------"
echo "[#] APT packages installed: ${#APT_PACKAGES[@]}"
echo "[#] Curl installers run: ${#CURL_INSTALLERS[@]}"
