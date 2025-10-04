#!/usr/bin/env bats

setup() {
    export PORT="8080"
    export RELEASE="v1.0.0"
    export LOG_LEVEL="INFO"
}

@test "Validación avanzada de puerto válido" {
    run ./src/generar-config.sh --validar
    [ "$status" -eq 0 ]
}

@test "Validación detecta puerto inválido (texto)" {
    export PORT="ochocientos"
    run ./src/generar-config.sh --validar
    [ "$status" -eq 1 ]
    [[ "$output" == *"PORT debe ser numérico"* ]]
}

@test "Validación detecta puerto inválido (rango)" {
    export PORT="80"
    run ./src/generar-config.sh --validar
    [ "$status" -eq 1 ]
    [[ "$output" == *"PORT debe estar entre 1024-65535"* ]]
}

@test "Validación detecta versión inválida" {
    export RELEASE="version1"
    run ./src/generar-config.sh --validar
    [ "$status" -eq 1 ]
    [[ "$output" == *"RELEASE debe seguir formato vX.Y.Z"* ]]
}

@test "Sistema de backup funciona" {
    run ./src/generar-config.sh --backup
    [ "$status" -eq 0 ]
    [[ "$output" == *"Backup creado"* ]]
    
    # Verificar archivo
    backup_file=$(echo "$output" | grep -o "out/backups/.*")
    [ -f "$backup_file" ]
}

@test "Sanitización remueve caracteres peligrosos" {
    export HOST="example.com; rm -rf /"
    run ./src/generar-config.sh --formato texto
    [ "$status" -eq 0 ]
    [[ "$output" == *"HOST=example.com rm -rf /"* ]]
}
