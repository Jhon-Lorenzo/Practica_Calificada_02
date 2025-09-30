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
