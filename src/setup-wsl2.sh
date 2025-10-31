# ────────────────────────────────
# 🧩 Basic ASCII logger helpers
# ────────────────────────────────
log_info()  { echo "[i] $*"; }
log_warn()  { echo "[!] $*"; }
log_ok()    { echo "[#] $*"; }
log_fail()  { echo "[x] $*" >&2; }



sudo apt update && sudo apt upgrade -y

curl -o ~/.bashrc https://raw.githubusercontent.com/skkylimits/.bashrc/main/.bashrc && curl -o ~/.bash_aliases https://raw.githubusercontent.com/skkylimits/.bashrc/main/.bash_aliases && curl -o ~/.bash_logout https://raw.githubusercontent.com/skkylimits/.bashrc/main/.bash_logout && echo "Settings downloaded! Restart your terminal or source ~/.bashrc" &&

exec bash


#!/usr/bin/env bash
set -euo pipefail

# ────────────────────────────────
# 🧩 Basic ASCII logger helpers
# ────────────────────────────────
log_info()  { echo "[i] $*"; }
log_warn()  { echo "[!] $*"; }
log_ok()    { echo "[#] $*"; }
log_fail()  { echo "[x] $*" >&2; }

# ────────────────────────────────
# 🧩 Tool installer
# ────────────────────────────────
install_tools() {
    local packages=("$@")

    log_info "Checking required packages..."
    for pkg in "${packages[@]}"; do
        if ! dpkg -s "$pkg" >/dev/null 2>&1; then
            log_warn "$pkg not found, installing..."
            if sudo apt-get install -y "$pkg" >/dev/null 2>&1; then
                log_ok "$pkg installed successfully."
            else
                log_fail "Failed to install $pkg"
            fi
        else
            log_ok "$pkg already installed."
        fi
    done
}

# ────────────────────────────────
# 🧩 Example usage
# ────────────────────────────────
install_tools cmatrix htop curl git


Ja — precies 👏
De `install_tools()`-aanpak met `dpkg -s` werkt **alleen voor pakketten die via `apt` (of `apt-get`) geïnstalleerd zijn**,
dus tools die in de **Debian-package-database** staan.

---

## 🧩 Waar het **wel** voor werkt

Alles wat `apt`, `apt-get` of `dpkg` beheert, bijvoorbeeld:

```
sudo apt install -y git curl htop python3 cmatrix nmap
```

Je kunt die checken met:

```bash
dpkg -s <pakketnaam>
```

Dat werkt ook als ze indirect via een andere package kwamen (apt weet dat).

---

## 🧩 Waar het **niet** voor werkt

Dingen die **buiten apt** om worden geïnstalleerd:

| Type                           | Voorbeeld                               | Waarom `dpkg -s` faalt                 |
| ------------------------------ | --------------------------------------- | -------------------------------------- |
| 🧱 **Handmatig binaire tools** | `/usr/local/bin/mytool` of `go install` | Niet in apt-database                   |
| 🧩 **Python modules (pip)**    | `pip install pwntools`                  | Worden door `pip`, niet `apt`, beheerd |
| 🧰 **Rust / Go / npm / cargo** | `cargo install ripgrep`                 | Zelfstandige package managers          |
| 🧪 **Source builds**           | `make install`                          | Geen dpkg-registratie                  |
| 🧼 **Custom scripts**          | `/opt/tools/my_custom_tool.sh`          | Gewoon een bestand op schijf           |

---

## ⚙️ Hoe los je dat netjes op

Voor elke “tool-familie” gebruik je een **eigen check-functie** in dezelfde logging-stijl.

### 🔹 Voor apt (heb je al)

```bash
if ! dpkg -s "$pkg" >/dev/null 2>&1; then
  sudo apt install -y "$pkg"
fi
```

### 🔹 Voor pip-tools

```bash
if ! pip show pwntools >/dev/null 2>&1; then
  pip install pwntools
fi
```

### 🔹 Voor binaries (zoals Go of handmatig gedownloade tools)

```bash
if ! command -v gobuster >/dev/null 2>&1; then
  echo "[!] gobuster not found, installing..."
  go install github.com/OJ/gobuster/v3@latest
  echo "[#] gobuster installed."
fi
```

### 🔹 Voor bestanden of scripts

```bash
if [ ! -f /opt/tools/mytool.sh ]; then
  echo "[!] mytool.sh missing, cloning..."
  git clone https://github.com/user/mytool /opt/tools/mytool
  echo "[#] mytool.sh installed."
fi
```

---

## 🧱 Tip: alles uniform houden

Je kunt in je `setup.sh` dit patroon volgen:

```bash
check_apt()   { dpkg -s "$1" >/dev/null 2>&1; }
check_pip()   { pip show "$1" >/dev/null 2>&1; }
check_bin()   { command -v "$1" >/dev/null 2>&1; }

log_info "[i] Installing base packages..."
for pkg in git curl htop; do
  check_apt "$pkg" || sudo apt install -y "$pkg"
done

log_info "[i] Installing Python tools..."
check_pip pwntools || pip install pwntools
```

Zo blijft je `[i] [!] [#]`-stijl uniform voor **alle install-types**.

---

💡 **Kort antwoord:**

> Juist, de `dpkg -s`-methode werkt alleen voor `apt`-tools.
> Voor `pip`, `cargo`, `npm` of zelfgebouwde tools gebruik je een `command -v`-check of hun eigen package-manager-check.

