#!/usr/bin/env bash
set -euo pipefail #Maak Bash streng: stop bij fouten, typfouten, of mislukte pipes.

# =============================================================
#  setup_tools.sh
#  Author : skkylimits
#  Purpose: Install baseline tools (APT, pip, go, cargo, npm, git)
# =============================================================

START_TIME=$(date +%s)
HOSTNAME=$(hostname)
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# -------------------------------------------------------------
# Header
# -------------------------------------------------------------
echo "[>] ------------------------------------------------------------"
echo "[>]  Starting setup_tools run"
echo "[>]  Timestamp : $TIMESTAMP"
echo "[>]  Host      : $HOSTNAME"
echo "[>] ------------------------------------------------------------"

# -----------------------
# Config – add your tools here
# -----------------------
APT_PACKAGES=(cmatrix htop curl git)
PIP_PACKAGES=(pwntools requests)
GO_PACKAGES=(github.com/project/cooltool@latest)
CARGO_PACKAGES=(ripgrep)
NPM_PACKAGES=(http-server)
BIN_INSTALL_CMDS=(
  "gobuster::go install github.com/OJ/gobuster/v3@latest"
  "ffuf::go install github.com/ffuf/ffuf@latest"
)
GIT_REPOS=(
  "https://github.com/example/tool.git:/opt/tools/tool"
)

# =============================================================
#  APT
# =============================================================
echo "[i] Updating apt cache..."
sudo apt-get update -y >/dev/null 2>&1 || echo "[!] apt update failed (continuing)"

for pkg in "${APT_PACKAGES[@]}"; do
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    echo "[#] $pkg already installed."
  else
    echo "[!] Installing $pkg..."
    if sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$pkg" >/dev/null 2>&1; then
      echo "[#] $pkg installed."
    else
      echo "[x] Failed to install $pkg"
    fi
  fi
done

# =============================================================
#  pip
# =============================================================
if ! command -v pip3 >/dev/null 2>&1; then
  echo "[!] pip3 not found, installing python3-pip..."
  sudo apt-get install -y python3-pip >/dev/null 2>&1 || echo "[x] Failed to install python3-pip"
fi

for pkg in "${PIP_PACKAGES[@]}"; do
  if pip3 show "$pkg" >/dev/null 2>&1; then
    echo "[#] pip: $pkg already installed."
  else
    echo "[!] Installing pip package: $pkg..."
    if pip3 install --user "$pkg" >/dev/null 2>&1; then
      echo "[#] pip: $pkg installed."
    else
      echo "[x] pip: failed $pkg"
    fi
  fi
done

# =============================================================
#  Go
# =============================================================
if ! command -v go >/dev/null 2>&1; then
  echo "[!] go not found, installing golang-go..."
  sudo apt-get install -y golang-go >/dev/null 2>&1 || echo "[x] Failed to install go"
fi

for mod in "${GO_PACKAGES[@]}"; do
  binname=$(basename "${mod%%@*}")
  if command -v "$binname" >/dev/null 2>&1; then
    echo "[#] go: $binname already present."
  else
    echo "[!] Installing go module: $mod..."
    if go install "$mod" >/dev/null 2>&1; then
      echo "[#] go: $mod installed."
    else
      echo "[x] go: failed $mod"
    fi
  fi
done

# =============================================================
#  Cargo
# =============================================================
if ! command -v cargo >/dev/null 2>&1; then
  echo "[!] cargo not found, installing via apt..."
  sudo apt-get install -y cargo >/dev/null 2>&1 || echo "[x] Failed to install cargo"
fi

for crate in "${CARGO_PACKAGES[@]}"; do
  binname=$(basename "$crate")
  if command -v "$binname" >/dev/null 2>&1; then
    echo "[#] cargo: $binname already present."
  else
    echo "[!] Installing cargo crate: $crate..."
    if cargo install "$crate" >/dev/null 2>&1; then
      echo "[#] cargo: $crate installed."
    else
      echo "[x] cargo: failed $crate"
    fi
  fi
done

# =============================================================
#  npm
# =============================================================
if ! command -v npm >/dev/null 2>&1; then
  echo "[!] npm not found, installing nodejs & npm..."
  sudo apt-get install -y nodejs npm >/dev/null 2>&1 || echo "[x] Failed to install npm"
fi

for pkg in "${NPM_PACKAGES[@]}"; do
  binname=$(basename "$pkg")
  if command -v "$binname" >/dev/null 2>&1; then
    echo "[#] npm: $binname already present."
  else
    echo "[!] Installing npm package: $pkg..."
    if sudo npm install -g "$pkg" >/dev/null 2>&1; then
      echo "[#] npm: $pkg installed."
    else
      echo "[x] npm: failed $pkg"
    fi
  fi
done

# =============================================================
#  Custom binaries
# =============================================================
for pair in "${BIN_INSTALL_CMDS[@]}"; do
  bin="${pair%%::*}"
  cmd="${pair#*::}"

  if command -v "$bin" >/dev/null 2>&1; then
    echo "[#] bin: $bin already present."
  else
    echo "[!] Installing binary: $bin..."
    if eval "$cmd" >/dev/null 2>&1; then
      echo "[#] bin: $bin installed."
    else
      echo "[x] bin: failed $bin"
    fi
  fi
done

# =============================================================
#  Git repositories
# =============================================================
for entry in "${GIT_REPOS[@]}"; do
  IFS=':' read -r repo dest <<<"$entry"
  if [ -d "$dest" ]; then
    echo "[#] gitrepo: $dest already exists."
  else
    echo "[!] Cloning $repo -> $dest ..."
    sudo mkdir -p "$(dirname "$dest")" >/dev/null 2>&1
    if sudo git clone --depth 1 "$repo" "$dest" >/dev/null 2>&1; then
      echo "[#] gitrepo: cloned."
    else
      echo "[x] gitrepo: failed to clone $repo"
    fi
  fi
done

# -------------------------------------------------------------
# Footer
# -------------------------------------------------------------
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
END_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo
echo "[>] ------------------------------------------------------------"
echo "[>]  Setup_tools run finished"
echo "[>]  Duration  : $(printf '%02d:%02d' $((DURATION/60)) $((DURATION%60)))"
echo "[>]  Finished  : $END_TIMESTAMP"
echo "[>] ------------------------------------------------------------"
