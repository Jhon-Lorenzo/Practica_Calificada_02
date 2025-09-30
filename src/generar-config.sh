#!/bin/bash
set -euo pipefail

# Cargar funciones
source "$(dirname "$0")/funciones-config.sh"

# Validar configuración básica
if ! validar_variables_requeridas; then
    exit 1
fi

# Determinar formato de salida
formato="${FORMATO_SALIDA:-texto}"
if [ "$formato" != "texto" ] && [ "$formato" != "json" ]; then
    echo "ERROR: FORMATO_SALIDA debe ser 'texto' o 'json'" >&2
    exit 1
fi

# Generar configuración
obtener_configuracion "$formato"
