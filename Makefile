.PHONY: all tools build run test clean help

# Cargar variables desde .env si existe
ifneq (,$(wildcard .env))
    include .env
    export
endif

# Variables con valores por defecto
PORT ?= 8080
RELEASE ?= v1.0.0

all: tools build test
	@echo "Proyecto verificado correctamente"

tools:
	@echo "Verificando dependencias..."
	@which python3 > /dev/null || (echo "Falta python3" && exit 1)
	@which curl > /dev/null || (echo "Falta curl" && exit 1)
	@which bats > /dev/null || (echo "Falta bats" && exit 1)
	@echo "Todas las herramientas están disponibles."

build:
	@echo "Preparando directorios..."
	mkdir -p out dist
	chmod +x src/iniciar-servicio.sh

run:
	@echo "Ejecutando servicio en puerto $(PORT)"
	@bash src/iniciar-servicio.sh

test:
	@echo "Ejecutando pruebas Bats..."
	PORT=$(PORT) bats tests/

clean:
	@echo "Limpiando directorios..."
	rm -rf out dist
	@pkill -f "servicio.py" 2>/dev/null || true

help:
	@echo "Targets disponibles:"
	@echo "  all   - Ejecuta tools + build + test"
	@echo "  tools - Verifica dependencias"
	@echo "  build - Prepara artefactos"
	@echo "  run   - Ejecuta el servicio en puerto $(PORT)"
	@echo "  test  - Corre pruebas"
	@echo "  clean - Limpia directorios"
	@echo "  help  - Muestra esta ayuda"
