#!/bin/bash
set -euo pipefail

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Sistema de logging
log_info() { echo -e "${GREEN}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1" >&2; }
log_error() { echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1" >&2; }

# Manejo de limpieza
cleanup_resources() {
    log_info "Ejecutando limpieza de recursos..."
    pkill -P $$ 2>/dev/null || true
}

# Trap para manejo de señales
trap_exit() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        log_error "Script falló con código: $exit_code"
        cleanup_resources
    fi
    exit $exit_code
}

trap trap_exit EXIT INT TERM
