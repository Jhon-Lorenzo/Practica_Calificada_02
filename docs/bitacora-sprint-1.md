# Bitácora Sprint 01
- Implementación de Makefile con 6 targets funcionales
- Creación de pruebas Bats para endpoint /salud
- Configuración de variables de entorno via .env
- Integración con scripts de servicio HTTP
## Comandos ejecutados del Makefile
```bash
make tools    # Verificar python3, curl, bats
make build    # Preparar estructura
make test     # Ejecutar pruebas bats
make run      # Lanzar servicio manualmente
```
## Pruebas con Bats
- Creado `tests/salud.bats` con metodología AAA/RGR
- Prueba: "GET /salud retorna 200"
- Prueba: "GET /salud contiene OK"

## Configuración

### Tareas completadas:
- [x] Crear funciones-config.sh con lista blanca
- [x] Implementar validación de variables requeridas
- [x] Soporte para formatos texto y JSON
- [x] Crear script generar-config.sh
- [x] Documentar variables en README.md

### Comandos ejecutados:
```bash

chmod +x src/funciones-config.sh src/generar-config.sh
export PORT=8080 RELEASE=v1.0.0
./src/generar-config.sh
```
### Salidas de prueba:
```bash
PORT=8080
RELEASE=v1.0.0
```

### Decisiones técnicas:
- [x]Variables requeridas: PORT
- [x]Lista blanca inicial: PORT, RELEASE, HOST, DEBUG, LOG_LEVEL
- [x]Se implementó sanitización básica con tr y sed
