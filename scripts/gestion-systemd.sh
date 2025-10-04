#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/../src/utils/error-handler.sh"

SERVICE_NAME="servicio-config-echo"

instalar_servicio() {
    log_info "Instalando servicio systemd..."
    sudo cp "systemd/${SERVICE_NAME}.service" "/etc/systemd/system/"
    sudo systemctl daemon-reload
    sudo systemctl enable "$SERVICE_NAME"
    log_info "Servicio instalado y habilitado"
}

ver_logs() {
    journalctl -u "$SERVICE_NAME" -f --lines=20
}

estado_servicio() {
    systemctl status "$SERVICE_NAME" --no-pager
}
