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
