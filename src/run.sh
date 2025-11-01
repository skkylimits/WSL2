#!/usr/bin/env bash
set -euo pipefail #Maak Bash streng: stop bij fouten, typfouten, of mislukte pipes.

# chmod +x run.sh

# =============================================================
#  run.sh
#  Author : skkylimits
#  Purpose: Install baseline tools (APT, pip, go, cargo, npm, git)
# =============================================================

START_TIME=$(date +%s)
HOSTNAME=$(hostname)
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# -------------------------------------------------------------
# Header
# -------------------------------------------------------------
echo "[>] ---------------------------------------------------------"
echo "[>]  Starting run.sh"
echo "[>]  Timestamp : $TIMESTAMP"
echo "[>]  Host      : $HOSTNAME"
echo "[>] ---------------------------------------------------------"

# =============================================================
# INIT
# =============================================================
echo
echo "============================================================="
echo "[>] INIT"
echo "============================================================="

echo "[i] Downloading shell configuration..."
curl -fsSL -o ~/.bashrc        https://raw.githubusercontent.com/skkylimits/.bashrc/main/.bashrc
curl -fsSL -o ~/.bash_aliases  https://raw.githubusercontent.com/skkylimits/.bashrc/main/.bash_aliases
curl -fsSL -o ~/.bash_logout   https://raw.githubusercontent.com/skkylimits/.bashrc/main/.bash_logout
echo "[#] Settings downloaded."
echo "[i] Run 'source ~/.bashrc' or restart your terminal to apply."

# =============================================================
#  Flag
# =============================================================
if [ ! -f ~/.sudo_as_admin_successful ]; then
    touch ~/.sudo_as_admin_successful
    echo "[#] sudo_as_admin_successful aangemaakt."
else
    echo "[i] sudo_as_admin_successful bestaat al, overslaan."
fi

# -----------------------
# Config – add your tools here
# -----------------------
APT_PACKAGES=(cmatrix htop curl git wget jq nmap net-tools pipx proxychains4)
CURL_INSTALLERS=(
  "nvm::curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"
  "pnpm::bash -c 'curl -fsSL https://get.pnpm.io/install.sh | sh - && sh - && sed -i \"/# pnpm/,/# pnpm end/d\" ~/.bashrc && sed -i \"/^$/d;\${/^$/d;}\" ~/.bashrc'"
  "pyenv::curl -fsSL https://pyenv.run | bash"
)
PIP_PACKAGES=(pipenv requests pipx)
PNPM_PACKAGES=(@google/generative-ai-cli @anthropic-ai/claude-code @openai/codex@latest
)


# =============================================================
#  BUILD DEPENDENCIES (per tool)
# =============================================================
CURL_DEPENDENCIES=(
  "pyenv::build-essential libssl-dev zlib1g-dev libbz2-dev \
   libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils \
   tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev"
)

install_apt_group() {
  local group_name="$1"
  shift
  local pkgs=("$@")

  echo
  echo "============================================================="
  echo "[>] Installing $group_name dependencies"
  echo "============================================================="

  for pkg in "${pkgs[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
      echo "[#] $pkg already installed."
    else
      echo "[!] Installing $pkg..."
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$pkg" >/dev/null 2>&1 \
        && echo "[#] $pkg installed." \
        || echo "[x] Failed to install $pkg"
    fi
  done
}

install_curl_dependencies() {
  local tool="$1"
  for mapping in "${CURL_DEPENDENCIES[@]}"; do
    local name="${mapping%%::*}"
    local deps="${mapping#*::}"
    if [[ "$name" == "$tool" ]]; then
      echo "[i] Checking dependencies for $tool..."
      install_apt_group "$tool" $deps
      return
    fi
  done
}

# =============================================================
#  APT
# =============================================================
echo
echo "============================================================="
echo "[>] APT PACKAGE INSTALLATION"
echo "============================================================="

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
#  curl
# =============================================================
echo
echo "============================================================="
echo "[>] CURL-BASED INSTALLERS"
echo "============================================================="

if [ ${#CURL_INSTALLERS[@]} -eq 0 ]; then
  echo "[i] No curl installers defined."
else
  for entry in "${CURL_INSTALLERS[@]}"; do
    # format: "command::install_url_or_script"
    name="${entry%%::*}"
    cmd="${entry#*::}"

    # Dependencies first (if any)
    install_curl_dependencies "$name"

    if command -v "$name" >/dev/null 2>&1; then
      echo "[#] $name already installed."
      continue
    fi

    echo "[!] Installing $name from curl source..."
    if eval "$cmd" >/dev/null 2>&1; then
      echo "[#] $name installed successfully."
    else
      echo "[x] Failed to install $name."
    fi
  done
fi

# =============================================================
#  PYTHON LTS INSTALLATION (via pyenv)
# =============================================================
PYTHON_LTS_VERSION="3.12.6"

if pyenv versions --bare | grep -q "^${PYTHON_LTS_VERSION}$"; then
  echo "[#] Python ${PYTHON_LTS_VERSION} already installed."
else
  echo "[i] Installing Python ${PYTHON_LTS_VERSION}..."
  if pyenv install "${PYTHON_LTS_VERSION}" >/dev/null 2>&1; then
    echo "[#] Python ${PYTHON_LTS_VERSION} installed successfully."
  else
    echo "[x] Failed to install Python ${PYTHON_LTS_VERSION}."
  fi
fi

# Set as global default
echo "[i] Setting Python ${PYTHON_LTS_VERSION} as global version..."
if pyenv global "${PYTHON_LTS_VERSION}" >/dev/null 2>&1; then
  echo "[#] Python ${PYTHON_LTS_VERSION} set as global."
else
  echo "[x] Failed to set global Python version."
fi

# Verify setup
echo "[i] Verifying Python installation..."
PYTHON_PATH=$(which python || true)
PYTHON_VER=$(python --version 2>/dev/null || echo "unknown")
echo "[#] Python binary : $PYTHON_PATH"
echo "[#] Python version: $PYTHON_VER"
echo "[!] Never remove default python. WSL depends on this package"

echo
echo "-------------------------------------------------------------"
echo "[i] Python version management tips:"
echo "-------------------------------------------------------------"
echo "[#] Use the following commands to switch Python versions:"
echo "[i]   pyenv shell <version>   → use version for current shell"
echo "[i]   pyenv local <version>   → use version for current folder"
echo "[i]   pyenv global <version>  → set version as global default"
echo
echo "[#] Example:"
echo "[i]   pyenv shell 3.12.6"
echo "[i]   pyenv global 3.12.6"
echo "[i]   python --version"
echo "[i]   which python"
echo "-------------------------------------------------------------"

# =============================================================
#  NODE LTS INSTALLATION (via nvm)
# =============================================================
echo
echo "============================================================="
echo "[>] NODE LTS INSTALLATION"
echo "============================================================="

if command -v nvm >/dev/null 2>&1; then
  # Check if Node LTS is already installed
  if nvm ls lts/* >/dev/null 2>&1 && nvm ls | grep -q "lts"; then
    echo "[#] Node LTS already installed."
  else
    echo "[i] Installing Node LTS via nvm..."
    if nvm install --lts >/dev/null 2>&1; then
      echo "[#] Node LTS installed successfully."
    else
      echo "[x] Failed to install Node LTS."
    fi
  fi

  # Set LTS as default
  echo "[i] Setting Node LTS as default..."
  if nvm alias default 'lts/*' >/dev/null 2>&1; then
    echo "[#] Node LTS set as default."
  else
    echo "[x] Failed to set default Node version."
  fi

  # Verify setup
  echo "[i] Verifying Node installation..."
  NODE_PATH=$(command -v node || echo "not found")
  NODE_VER=$(node --version 2>/dev/null || echo "unknown")
  NPM_VER=$(npm --version 2>/dev/null || echo "unknown")
  echo "[#] Node binary : $NODE_PATH"
  echo "[#] Node version: $NODE_VER"
  echo "[#] npm version : $NPM_VER"

  echo
  echo "-------------------------------------------------------------"
  echo "[i] Node version management tips:"
  echo "-------------------------------------------------------------"
  echo "[#] Use the following commands to switch Node versions:"
  echo "[i]   nvm install <version>  → install specific version"
  echo "[i]   nvm use <version>      → use version for current shell"
  echo "[i]   nvm alias default <v>  → set version as default"
  echo
  echo "[#] Example:"
  echo "[i]   nvm install --lts"
  echo "[i]   nvm use --lts"
  echo "[i]   node --version"
  echo "[i]   which node"
  echo "-------------------------------------------------------------"
else
  echo "[!] nvm not found, skipping Node LTS installation."
  echo "[!] pnpm packages may fail without Node.js installed."
fi

# =============================================================
#  PIP PACKAGE INSTALLATION
# =============================================================
echo
echo "============================================================="
echo "[>] PIP PACKAGE INSTALLATION"
echo "============================================================="

# Zorg dat pip beschikbaar is
if ! command -v pip3 >/dev/null 2>&1; then
  echo "[!] pip3 not found, installing via apt..."
  sudo apt-get update -y >/dev/null 2>&1
  sudo apt-get install -y python3-pip >/dev/null 2>&1 \
    && echo "[#] pip3 installed." \
    || echo "[x] Failed to install pip3."
fi

for pkg in "${PIP_PACKAGES[@]}"; do
  if pip3 show "$pkg" >/dev/null 2>&1; then
    echo "[#] pip: $pkg already installed."
  else
    echo "[!] Installing pip package: $pkg..."
    if pip3 install --user "$pkg" >/dev/null 2>&1; then
      echo "[#] pip: $pkg installed."
    else
      echo "[x] pip: Failed to install $pkg."
    fi
  fi
done

echo
echo "-------------------------------------------------------------"
echo "[i] Listing all globally installed Python packages:"
echo "-------------------------------------------------------------"
pip3 freeze || echo "[!] Failed to list pip packages."
echo "-------------------------------------------------------------"

# =============================================================
#  PNPM PACKAGE INSTALLATION
# =============================================================
echo
echo "============================================================="
echo "[>] PNPM PACKAGE INSTALLATION"
echo "============================================================="

# Reload shell environment to get pnpm in PATH
export PNPM_HOME="/home/skkylimits/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

if ! command -v pnpm >/dev/null 2>&1; then
  echo "[!] pnpm not found, skipping pnpm package installation."
else
  for pkg in "${PNPM_PACKAGES[@]}"; do
    if pnpm list -g | grep -q "$pkg"; then
      echo "[#] pnpm: $pkg already installed."
    else
      echo "[!] Installing pnpm package: $pkg..."
      if pnpm install -g "$pkg" >/dev/null 2>&1; then
        echo "[#] pnpm: $pkg installed."
      else
        echo "[x] pnpm: Failed to install $pkg."
      fi
    fi
  done
fi

# =============================================================
#  Docker
# =============================================================
echo
echo "============================================================="
echo "[>] DOCKER INSTALLATION"
echo "============================================================="

if command -v docker >/dev/null 2>&1; then
  echo "[#] Docker already installed."
else
  echo "[i] Setting up Docker apt repository..."
  sudo apt-get update -y >/dev/null 2>&1
  sudo apt-get install -y ca-certificates curl gnupg >/dev/null 2>&1

  sudo install -m 0755 -d /etc/apt/keyrings >/dev/null 2>&1
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo "[i] Adding Docker repository..."
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

  sudo apt-get update -y >/dev/null 2>&1

  echo "[i] Installing Docker Engine packages..."
  if sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >/dev/null 2>&1; then
    echo "[#] Docker packages installed."
  else
    echo "[x] Failed to install Docker packages."
  fi

  echo "[i] Adding current user to docker group..."
  if sudo usermod -aG docker "$USER"; then
    echo "[#] User '$USER' added to docker group."
  else
    echo "[x] Failed to add user to docker group."
  fi

  echo "[i] Verifying Docker installation..."
  if sudo docker run --rm hello-world >/dev/null 2>&1; then
    echo "[#] Docker installation verified successfully."
  else
    echo "[!] Docker verification failed or hello-world image could not run."
  fi

  echo "[i] Applying new group membership..."
  echo "[i] Group change will take effect after you log out or restart your shell."
  echo "[i] To apply immediately, run: newgrp docker"
fi

# -------------------------------------------------------------
# Footer
# -------------------------------------------------------------
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
END_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo
echo "[>] ---------------------------------------------------------"
echo "[>]  run.sh run finished"
echo "[>]  Duration  : $(printf '%02d:%02d' $((DURATION/60)) $((DURATION%60)))"
echo "[>]  Finished  : $END_TIMESTAMP"
echo "[>] ---------------------------------------------------------"
