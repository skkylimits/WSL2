#!/usr/bin/env bash
set -euo pipefail #Maak Bash streng: stop bij fouten, typfouten, of mislukte pipes.

# chmod +x run.sh

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
echo "[>]  Starting setup_tools.sh run"
echo "[>]  Timestamp : $TIMESTAMP"
echo "[>]  Host      : $HOSTNAME"
echo "[>] ------------------------------------------------------------"

# =============================================================
# INIT
# =============================================================
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
APT_PACKAGES=(cmatrix htop curl git wget jq)
CURL_INSTALLERS=(
  "nvm::curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"
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
#  curl
# =============================================================
install_curl() {
  local entries=("$@")
  if [ ${#entries[@]} -eq 0 ]; then
    echo "[i] No curl installers defined."
    return
  fi

  for entry in "${entries[@]}"; do
    # format: "command::install_url_or_script"
    local name="${entry%%::*}"
    local cmd="${entry#*::}"

    if command -v "$name" >/dev/null 2>&1; then
      echo "[#] $name already installed."
      continue
    fi

    echo "[!] Installing $name from curl source..."
    if echo "$cmd" | bash >/dev/null 2>&1; then
      echo "[#] $name installed successfully."
    else
      echo "[x] Failed to install $name."
    fi
  done
}

# -------------------------------------------------------------
# Footer
# -------------------------------------------------------------
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
END_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo
echo "[>] ------------------------------------------------------------"
echo "[>]  setup_tools.sh run finished"
echo "[>]  Duration  : $(printf '%02d:%02d' $((DURATION/60)) $((DURATION%60)))"
echo "[>]  Finished  : $END_TIMESTAMP"
echo "[>] ------------------------------------------------------------"
