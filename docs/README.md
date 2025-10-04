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
