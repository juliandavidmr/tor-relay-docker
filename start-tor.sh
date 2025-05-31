#!/bin/bash

# Script de inicio para el relay Tor con Nyx

set -e

echo "=== Iniciando Nodo Relay Tor ==="
echo "Nombre del nodo: relaycoldav"
echo "Puertos: 9001 (OR), 9030 (Dir), 9051 (Control)"
echo "================================="

# Verificar permisos de directorios
echo "Verificando permisos de directorios..."
if [ ! -w /var/lib/tor ]; then
    echo "Error: No se puede escribir en /var/lib/tor"
    exit 1
fi

if [ ! -w /var/log/tor ]; then
    echo "Error: No se puede escribir en /var/log/tor"
    exit 1
fi

# Crear archivos de log si no existen
touch /var/log/tor/notices.log
touch /var/log/tor/info.log

# Verificar configuración de Tor
echo "Verificando configuración de Tor..."
tor --verify-config -f /etc/tor/torrc

# Función para manejar señales
cleanup() {
    echo "Recibida señal de terminación. Cerrando Tor..."
    kill -TERM "$TOR_PID" 2>/dev/null || true
    wait "$TOR_PID" 2>/dev/null || true
    echo "Tor cerrado correctamente."
    exit 0
}

# Configurar manejo de señales
trap cleanup TERM INT

# Iniciar Tor en background
echo "Iniciando servicio Tor..."
tor -f /etc/tor/torrc &
TOR_PID=$!

# Esperar a que Tor se inicie completamente
echo "Esperando a que Tor se inicie completamente..."
sleep 10

# Verificar que Tor está funcionando
if ! kill -0 "$TOR_PID" 2>/dev/null; then
    echo "Error: Tor no se pudo iniciar correctamente"
    exit 1
fi

echo "Tor iniciado correctamente (PID: $TOR_PID)"
echo ""
echo "=== Información del Relay ==="
echo "Para monitorear el relay, puedes usar:"
echo "  docker exec -it tor-relay-coldav nyx"
echo ""
echo "Para ver los logs:"
echo "  docker exec -it tor-relay-coldav tail -f /var/log/tor/notices.log"
echo ""
echo "Para verificar el estado del relay:"
echo "  curl -s https://metrics.torproject.org/rs.html#search/relaycoldav"
echo "============================"

# Mantener el script corriendo y mostrar logs
tail -f /var/log/tor/notices.log &

# Esperar a que Tor termine
wait "$TOR_PID"
