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
    kill $SERVER_PID 2>/dev/null || true
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
