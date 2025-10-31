#!/bin/bash
# Test met act (GitHub Actions lokaal)
# Gebruik dit voor het testen van de volledige CI pipeline

set -euo pipefail

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[i]${NC} $*"; }
log_success() { echo -e "${GREEN}[✓]${NC} $*"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $*"; }

# Banner
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  GitHub Actions - Lokale Test (act)   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check act
if ! command -v act &> /dev/null; then
    log_warning "act niet gevonden!"
    log_info "Installeer met: curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash"
    exit 1
fi

# Parse mode
MODE="${1:-full}"

case "$MODE" in
    quick)
        log_info "QUICK MODE: Test alleen nieuwe packages"
        log_info "Dit runt de 'quick-test' job"
        echo ""
        act -j quick-test
        ;;
    full)
        log_info "FULL MODE: Test complete setup"
        log_info "Dit runt de 'test-setup' job"
        echo ""
        act -j test-setup
        ;;
    list)
        log_info "Beschikbare jobs:"
        act -l
        ;;
    *)
        log_warning "Onbekende mode: $MODE"
        echo ""
        echo "Gebruik:"
        echo "  ./test-with-act.sh quick    - Test alleen nieuwe packages (snel)"
        echo "  ./test-with-act.sh full     - Test complete setup"
        echo "  ./test-with-act.sh list     - Toon alle jobs"
        exit 1
        ;;
esac

echo ""
log_success "act test voltooid!"
