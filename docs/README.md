
## Configuración

### Variables de Entorno

| Variable | Descripción | Valor por defecto | Requerido |
|----------|-------------|-------------------|-----------|
| PORT | Puerto del servicio HTTP | 8080 | **Sí** |
| RELEASE | Versión de la aplicación | v1.0.0 | No |
| HOST | Host del servicio | localhost | No |
| DEBUG | Modo depuración | 0 | No |
| LOG_LEVEL | Nivel de logs | INFO | No |

### Formatos de Salida

El endpoint `/config` soporta dos formatos:

**Texto plano (default):**
 PORT=8080
 RELEASE=v1.0.0

**JSON:**
```json
{
  "PORT": "8080",
  "RELEASE": "v1.0.0"
}

## Sprint 2 - Sistema Avanzado de Configuración

### Nuevas Funcionalidades

##### Validación Avanzada

```bash
# Validar configuración completa
./src/generar-config.sh --validar

# Validaciones implementadas:
# - Formato de puerto (1024-65535)
# - Versión semver (vX.Y.Z) 
# - Niveles de log válidos
# - Sanitización de seguridad
```

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

## Configuración de variables de entorno

| Variable | Descripción | Valor por defecto | Requerido |
|----------|-------------|-------------------|-----------|
| PORT | Puerto del servicio HTTP | 8080 | **Sí** |
| RELEASE | Versión de la aplicación | v1.0.0 | No |
| HOST | Host del servicio | localhost | No |
| DEBUG | Modo depuración | 0 | No |
| LOG_LEVEL | Nivel de logs | INFO | No |

### Formatos de Salida

El endpoint `/config` soporta dos formatos:

**Texto plano (default):**
 PORT=8080
 RELEASE=v1.0.0

**JSON:**
```json
{
  "PORT": "8080",
  "RELEASE": "v1.0.0"
}


