# Bitácora Sprint 01
- Implementación de Makefile con 6 targets funcionales
- Creación de pruebas Bats para endpoint /salud
- Configuración de variables de entorno via .env
- Integración con scripts de servicio HTTP
### Comandos ejecutados del Makefile
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
