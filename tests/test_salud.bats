#!/usr/bin/env bats

setup() {
    # Cargar variables de entorno del test
    export PORT=${PORT:-8080}
    
    # Iniciar servicio antes de las pruebas
    ./src/iniciar-servicio.sh &
    export SERVER_PID=$!
    sleep 2
}

teardown() {
    # Terminar procesos por nombre y puerto
    pkill -f "python3 src/servicio.py" 2>/dev/null || true
    pkill -f "src/iniciar-servicio.sh" 2>/dev/null || true
    
    # Esperar y forzar terminación si es necesario
    sleep 1
    pkill -9 -f "python3 src/servicio.py" 2>/dev/null || true
    
    # Liberar el puerto por si queda bloqueado
    fuser -k "${PORT}/tcp" 2>/dev/null || true
}

@test "GET /salud retorna 200" {
    run curl -s -o /dev/null -w "%{http_code}" "http://localhost:${PORT}/salud"
    [ "$status" -eq 0 ]
    [ "$output" -eq 200 ]
}

@test "GET /salud contiene OK" {
    run curl -s "http://localhost:${PORT}/salud"
    [ "$status" -eq 0 ]
    [ "$output" = "OK" ]
}
