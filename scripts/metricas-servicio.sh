#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/../src/utils/error-handler.sh"

obtener_metricas() {
    local puerto=${1:-8080}
    
    log_info "Recolectando métricas..."
    
    # Tiempo de respuesta
    local start_time=$(date +%s%N)
    if curl -s "http://localhost:$puerto/salud" >/dev/null; then
        local end_time=$(date +%s%N)
        local response_time=$(( (end_time - start_time) / 1000000 ))
        echo "Tiempo respuesta: ${response_time}ms"
    else
        echo "Servicio no responde"
    fi
    
    # Estado del puerto
    if ss -tln | grep -q ":$puerto "; then
        echo "Estado: ACTIVO"
    else
        echo "Estado: INACTIVO"
    fi
}

obtener_metricas "$@"
