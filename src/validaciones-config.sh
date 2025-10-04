#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/utils/error-handler.sh"

# Validar formato de puerto
validar_puerto() {
    local puerto="$1"
    
    if ! [[ "$puerto" =~ ^[0-9]+$ ]]; then
        log_error "PORT debe ser numérico: $puerto"
        return 1
    fi
    
    if [ "$puerto" -lt 1024 ] || [ "$puerto" -gt 65535 ]; then
        log_error "PORT debe estar entre 1024-65535: $puerto"
        return 1
    fi
    
    # Verificar si el puerto está disponible
    if ss -tln | grep -q ":$puerto "; then
        log_warn "Puerto $puerto puede estar ocupado"
    fi
    
    return 0
}

# Validar formato de versión
validar_version() {
    local version="${1:-}"
    if [ -n "$version" ] && ! [[ "$version" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        log_error "RELEASE debe seguir formato vX.Y.Z: $version"
        return 1
    fi
    return 0
}

# Validar nivel de log
validar_log_level() {
    local nivel="${1:-}"
    local niveles_validos=("DEBUG" "INFO" "WARN" "ERROR")
    
    if [ -n "$nivel" ] && [[ ! " ${niveles_validos[*]} " =~ " ${nivel} " ]]; then
        log_error "LOG_LEVEL debe ser: ${niveles_validos[*]}"
        return 1
    fi
    return 0
}

# Validación completa
validar_configuracion_completa() {
    log_info "Validando configuración completa..."
    
    # Validar requeridos
    if ! validar_variables_requeridas; then
        return 1
    fi
    
    # Validar formatos
    validar_puerto "${PORT:-}" || return 1
    validar_version "${RELEASE:-}" || return 1
    validar_log_level "${LOG_LEVEL:-}" || return 1
    
    log_info "✓ Configuración válida"
    return 0
}
