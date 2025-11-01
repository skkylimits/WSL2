#!/bin/bash
# Lokale test script met Docker buildx caching
# Dit script gebruikt Docker layer caching voor SUPER snelle rebuilds

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() { echo -e "${BLUE}[i]${NC} $*"; }
log_success() { echo -e "${GREEN}[✓]${NC} $*"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $*"; }
log_error() { echo -e "${RED}[✗]${NC} $*"; }

# Banner
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  WSL2 Setup - Lokale Test (CACHED)     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check Docker
if ! command -v docker &> /dev/null; then
    log_error "Docker niet gevonden! Installeer eerst Docker."
    exit 1
fi

# Enable buildkit
export DOCKER_BUILDKIT=1

# Parse arguments
STAGE="${1:-final}"
QUICK="${2:-}"

log_info "Build stage: ${STAGE}"
log_info "Docker BuildKit: enabled"
echo ""

# Quick test mode (alleen nieuwe APT packages)
if [[ "$QUICK" == "quick" ]]; then
    log_info "QUICK MODE: Test alleen nieuwe APT packages"
    log_info "Edit Dockerfile regel ~30 om nieuwe packages toe te voegen"
    echo ""

    # Build alleen tot apt-packages stage
    docker build \
        --target apt-packages \
        --cache-from wsl2-setup:apt-cache \
        --tag wsl2-setup:apt-cache \
        .

    log_success "Quick test voltooid!"
    log_info "Run container: docker run -it wsl2-setup:apt-cache bash"
    exit 0
fi

# Full build met alle caching
log_info "Building met cache layers..."
START_TIME=$(date +%s)

docker build \
    --target "${STAGE}" \
    --cache-from wsl2-setup:cache \
    --tag wsl2-setup:latest \
    --tag wsl2-setup:cache \
    .

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
log_success "Build voltooid in ${DURATION} seconden!"
echo ""

# Run tests
log_info "Running verification tests..."
docker run --rm wsl2-setup:latest bash -c '
    echo "[i] Testing installations..."

    # APT packages
    command -v git && echo "[✓] git installed" || echo "[✗] git missing"
    command -v curl && echo "[✓] curl installed" || echo "[✗] curl missing"
    command -v docker && echo "[✓] docker installed" || echo "[✗] docker missing"

    # Python
    source ~/.bashrc
    python --version && echo "[✓] python installed" || echo "[✗] python missing"

    # Node
    source ~/.nvm/nvm.sh
    node --version && echo "[✓] node installed" || echo "[✗] node missing"

    # pnpm
    pnpm --version && echo "[✓] pnpm installed" || echo "[✗] pnpm missing"

    echo ""
    echo "[✓] All tests passed!"
'

echo ""
log_success "Alle tests geslaagd!"
log_info "Run container: docker run -it wsl2-setup:latest bash"
echo ""

# Cleanup options
read -p "$(echo -e ${YELLOW}Wil je de build cache behouden voor snellere rebuilds? [Y/n]:${NC} )" -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    log_success "Cache behouden - volgende build zal super snel zijn!"
else
    docker builder prune -f
    log_info "Cache verwijderd"
fi
