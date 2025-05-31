#!/bin/bash

# Script de preparación para el nodo relay Tor
# Este script debe ejecutarse antes de iniciar docker-compose

set -e

echo "=== Preparando entorno para Nodo Relay Tor ==="

# Crear directorio de logs si no existe
if [ ! -d "./logs" ]; then
    echo "Creando directorio de logs..."
    mkdir -p ./logs
fi

# Configurar permisos para el usuario toruser (UID 1001, GID 1001)
echo "Configurando permisos de directorios..."
sudo chown -R 1001:1001 ./logs
chmod 755 ./logs

# Verificar que el archivo torrc existe
if [ ! -f "./torrc" ]; then
    echo "Error: El archivo torrc no existe en el directorio actual"
    echo "Asegúrate de tener todos los archivos del proyecto en el directorio actual"
    exit 1
fi

# Verificar permisos del archivo torrc
chmod 644 ./torrc

echo "=== Configuración completada ==="
echo ""
echo "Ahora puedes ejecutar:"
echo "  docker-compose up -d"
echo ""
echo "Para ver logs:"
echo "  docker-compose logs -f"
echo ""
echo "Para monitorear con Nyx:"
echo "  docker exec -it tor-relay-coldav nyx"
echo ""
