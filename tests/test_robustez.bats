#!/usr/bin/env bats

setup_file() {
    export PORT=8090
}

teardown_file() {
    pkill -f "servicio.py" 2>/dev/null || true
}

@test "Servicio maneja puerto ocupado correctamente" {
    # Ocupar puerto
    python3 -m http.server $PORT &
    local blocker_pid=$!
    sleep 2
    
    run ./src/iniciar-servicio.sh
    [ "$status" -ne 0 ]
    
    kill $blocker_pid
}

@test "Servicio sobrevive a requests concurrentes" {
    ./src/iniciar-servicio.sh &
    local pid=$!
    sleep 3
    
    # Múltiples requests
    for i in {1..3}; do
        curl -s "http://localhost:$PORT/salud" &
    done
    wait
    
    run curl -s -o /dev/null -w "%{http_code}" "http://localhost:$PORT/salud"
    [ "$output" -eq 200 ]
    
    kill $pid
}
