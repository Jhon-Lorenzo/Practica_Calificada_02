#!/usr/bin/env bash
set -euo pipefail

# Variables
PORT="${PORT:-8080}"

# Limpiar procesos previos
trap "echo 'Cerrando servidor...'; exit 0" SIGINT SIGTERM

# Ejecutar servicio
echo "Iniciando servicio en puerto $PORT..."
python3 src/servicio.py
