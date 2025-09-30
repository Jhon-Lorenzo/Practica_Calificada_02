# Sprint 01
## Configuración del Makefile
|Target|Función|
|------|-------|
|`tools`|Verifica dependencias|
|`build`|Prepara artefactos|
|`test`|Ejecutar suite Bats|
|`run`|Lanzar servicio|
|`clean`|Limpieza|
|`help`|Documentación|

Ademá logramos definir un `.env` donde en el Makefile se valida en caso exista , sino utilizará el puerto 8080 por defecto.

## Crear archivo `.env`:
```bash
# Ejecutar en la raíz del proyecto:
echo "PORT=8080" > .env
echo "RELEASE=v1.0.0" >> .env

# O crear manualmente el archivo .env con:
PORT=8080
RELEASE=v1.0.0
```