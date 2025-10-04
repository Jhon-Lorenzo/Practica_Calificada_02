.PHONY: all tools build run test clean help robust-test systemd-test monitor logs metrics

# Cargar variables desde .env si existe
ifneq (,$(wildcard .env))
    include .env
    export
endif

# Variables con valores por defecto
PORT ?= 8080
RELEASE ?= v1.0.0

all: tools build test robust-test
	@echo "Proyecto verificado correctamente (Sprint 2)"

tools:
	@echo "Verificando dependencias..."
	@which python3 > /dev/null || (echo "Falta python3" && exit 1)
	@which curl > /dev/null || (echo "Falta curl" && exit 1)
	@which bats > /dev/null || (echo "Falta bats" && exit 1)
	@which ss > /dev/null || (echo "Falta ss" && exit 1)
	@which journalctl > /dev/null || (echo "Falta journalctl" && exit 1)
	@echo "Todas las herramientas están disponibles."

build:
	@echo "Preparando directorios y permisos..."
	@mkdir -p out dist src/utils scripts
	@chmod +x src/iniciar-servicio.sh scripts/*.sh 2>/dev/null || true

run:
	@echo "Ejecutando servicio en puerto $(PORT)"
	@bash src/iniciar-servicio.sh

# TESTS ORIGINALES (Sprint 1)
test: build
	@echo "Ejecutando pruebas Bats básicas..."
	@# Limpiar servicios previos
	@pkill -f "servicio.py" 2>/dev/null || true
	@sleep 1
	@# Iniciar servicio
	@echo "Iniciando servicio HTTP..."
	@PORT=$(PORT) timeout 30s bash src/iniciar-servicio.sh &
	@SERVICE_PID=$$!; \
	sleep 3; \
	@# Verificar que el servicio está vivo
	@if ! curl -s http://localhost:$(PORT)/salud >/dev/null; then \
		echo "ERROR: Servicio no responde"; \
		kill $$SERVICE_PID 2>/dev/null || true; \
		exit 1; \
	fi; \
	@# Ejecutar pruebas
	@echo "Ejecutando pruebas Bats..."; \
	PORT=$(PORT) bats tests/test_salud.bats; \
	TEST_EXIT=$$?; \
	@# Limpiar
	@echo "Finalizando servicio..."; \
	kill $$SERVICE_PID 2>/dev/null || true; \
	pkill -f "servicio.py" 2>/dev/null || true; \
	exit $$TEST_EXIT

# NUEVOS TARGETS SPRINT 2 - AUTOMATIZACIÓN AVANZADA

# Pruebas de robustez y manejo de errores
robust-test: build
	@echo "Ejecutando pruebas de robustez..."
	@# Usar puerto diferente para no interferir
	@PORT=8090 bats tests/test_robustez.bats

# Verificación de configuración systemd
systemd-test: build
	@echo "Verificando configuración systemd..."
	@if command -v systemd-analyze >/dev/null 2>&1; then \
		if [ -f "systemd/servicio-config-echo.service" ]; then \
			systemd-analyze verify systemd/servicio-config-echo.service && \
			echo "Configuración systemd válida"; \
		else \
			echo "Archivo de servicio systemd no encontrado"; \
		fi; \
	else \
		echo "systemd no disponible en este entorno"; \
	fi

# Monitoreo en tiempo real del servicio
monitor:
	@echo "=== MONITOREO DEL SERVICIO ==="
	@# Verificar proceso
	@if pgrep -f "servicio.py" >/dev/null; then \
		echo "Servicio ACTIVO (PID: $$(pgrep -f 'servicio.py'))"; \
	else \
		echo "Servicio INACTIVO"; \
	fi
	@# Verificar puerto
	@if ss -tln | grep ":${PORT:-8080} " >/dev/null; then \
		echo "Puerto ${PORT:-8080} en USO"; \
	else \
		echo "Puerto ${PORT:-8080} LIBRE"; \
	fi
	@# Verificar logs recientes
	@if [ -f "out/servicio.log" ]; then \
		echo "Últimas líneas de log:"; \
		tail -3 out/servicio.log 2>/dev/null | while read line; do echo "   $$line"; done; \
	else \
		echo "No hay archivo de log disponible"; \
	fi

# Visualización de logs
logs:
	@echo "=== LOGS DEL SERVICIO ==="
	@if command -v journalctl >/dev/null 2>&1 && \
	   systemctl is-active servicio-config-echo >/dev/null 2>&1; then \
		echo "Usando journalctl (systemd):"; \
		sudo journalctl -u servicio-config-echo -n 10 -f; \
	elif [ -f "out/servicio.log" ]; then \
		echo "Usando logs locales:"; \
		tail -f out/servicio.log; \
	else \
		echo "No hay logs disponibles. Inicia el servicio primero: make run"; \
	fi

# Métricas de rendimiento
metrics:
	@echo "=== MÉTRICAS DEL SERVICIO ==="
	@if [ -f "scripts/metricas-servicio.sh" ]; then \
		bash scripts/metricas-servicio.sh ${PORT:-8080}; \
	else \
		echo "Script de métricas no disponible aún"; \
		@# Métricas básicas como fallback
		@if pgrep -f "servicio.py" >/dev/null; then \
			echo "Servicio corriendo"; \
			echo "Probando tiempo de respuesta..."; \
			timeout 5 curl -s "http://localhost:${PORT:-8080}/salud" >/dev/null && \
			echo "Servicio respondiendo" || echo "Servicio no responde"; \
		else \
			echo "Servicio no está corriendo"; \
		fi; \
	fi

# Instalación del servicio systemd
install-systemd:
	@echo "Instalando servicio systemd..."
	@if [ -f "scripts/gestion-systemd.sh" ]; then \
		bash scripts/gestion-systemd.sh instalar_servicio; \
	else \
		echo "Script de instalación no disponible"; \
	fi

# Suite completa de pruebas (Sprint 2)
full-test: test robust-test systemd-test
	@echo "Suite completa de pruebas ejecutada"

clean:
	@echo "Limpiando directorios y procesos..."
	@rm -rf out dist
	@pkill -f "servicio.py" 2>/dev/null || true
	@pkill -f "iniciar-servicio.sh" 2>/dev/null || true
	@echo "Limpieza completada"

help:
	@echo "Targets disponibles (Sprint 2):"
	@echo "  all           - Ejecuta tools + build + test + robust-test"
	@echo "  tools         - Verifica dependencias"
	@echo "  build         - Prepara artefactos y permisos"
	@echo "  run           - Ejecuta el servicio en puerto \$${PORT:-8080}"
	@echo "  test          - Pruebas básicas (Sprint 1)"
	@echo "  robust-test   - Pruebas de robustez y errores"
	@echo "  systemd-test  - Verifica configuración systemd"
	@echo "  monitor       - Monitoreo en tiempo real"
	@echo "  logs          - Visualización de logs"
	@echo "  metrics       - Métricas de rendimiento"
	@echo "  install-systemd Instala servicio systemd"
	@echo "  full-test     - Ejecuta suite completa de pruebas"
	@echo "  clean         - Limpia directorios y procesos"
	@echo "  help          - Muestra esta ayuda"
