#!/bin/bash
set -euo pipefail

# Lista blanca de variables permitidas
obtener_lista_blanca() {
    echo "PORT RELEASE HOST DEBUG LOG_LEVEL"
}

# Validar variables requeridas
validar_variables_requeridas() {
    local -a requeridas=("PORT")
    local faltantes=()
    
    for var in "${requeridas[@]}"; do
        if [ -z "${!var:-}" ]; then
            faltantes+=("$var")
        fi
    done
    
    if [ ${#faltantes[@]} -gt 0 ]; then
        echo "ERROR: Variables requeridas faltantes: ${faltantes[*]}" >&2
        return 1
    fi
    return 0
}

# Filtrar y mostrar solo variables permitidas
obtener_configuracion() {
    local formato="${1:-texto}"
    local permitidas=($(obtener_lista_blanca))
    
    case "$formato" in
        "json")
            echo "{"
            local first=true
            for var in "${permitidas[@]}"; do
                if [ -n "${!var:-}" ]; then
                    if [ "$first" = false ]; then
                        echo ","
                    fi
                    first=false
                    printf '  "%s": "%s"' "$var" "${!var}"
                fi
            done
            echo -e "\n}"
            ;;
        *)
            # Formato texto plano (default)
            for var in "${permitidas[@]}"; do
                if [ -n "${!var:-}" ]; then
                    echo "${var}=${!var}"
                fi
            done
            ;;
    esac
}
