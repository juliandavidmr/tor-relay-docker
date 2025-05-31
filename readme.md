# Nodo Relay Tor - relaycoldav

Este proyecto configura un nodo relay Tor usando Docker Compose con las siguientes características:

## Especificaciones

- **Nombre del nodo**: `relaycoldav`
- **Email de contacto**: `email@email.com`
- **Puertos**: 9001 (OR), 9030 (Dir), 9051 (Control)
- **Ancho de banda limitado**: 512 KB/s sostenido, 1 MB/s burst
- **Herramientas incluidas**: Nyx para monitoreo interno

## Estructura del proyecto

```
tor-relay/
├── docker-compose.yml    # Configuración de Docker Compose
├── Dockerfile           # Imagen personalizada con Tor y Nyx
├── torrc               # Configuración del relay Tor
├── start-tor.sh        # Script de inicio
├── setup.sh            # Script de preparación del entorno
├── logs/               # Directorio para logs (se crea automáticamente)
└── README.md           # Este archivo
```

## Instalación y uso

### 1. Clonar o crear el proyecto

```bash
mkdir tor-relay && cd tor-relay
# Copiar todos los archivos proporcionados
```

### 2. Preparar el entorno

```bash
# Ejecutar script de preparación (requiere sudo)
chmod +x setup.sh
./setup.sh
```

### 3. Construir y ejecutar

```bash
# Construir e iniciar el contenedor
docker-compose up -d

# Ver logs en tiempo real
docker-compose logs -f
```

### 3. Monitoreo con Nyx

```bash
# Acceder al contenedor y ejecutar Nyx
docker exec -it tor-relay-coldav nyx
```

### 4. Verificar el estado del relay

```bash
# Ver logs del relay
docker exec -it tor-relay-coldav tail -f /var/log/tor/notices.log

# Verificar conectividad
docker exec -it tor-relay-coldav curl -s https://check.torproject.org/
```

## Configuración de ancho de banda

El relay está configurado con límites de ancho de banda bajos para minimizar el uso de recursos:

- **RelayBandwidthRate**: 512 KB/s (velocidad sostenida)
- **RelayBandwidthBurst**: 1 MB/s (velocidad máxima temporal)
- **AccountingMax**: 10 GB por mes

## Comandos útiles

### Gestión del contenedor

```bash
# Iniciar el relay
docker-compose up -d

# Detener el relay
docker-compose down

# Reiniciar el relay
docker-compose restart

# Ver estado
docker-compose ps
```

### Monitoreo y logs

```bash
# Ejecutar Nyx (monitor interactivo)
docker exec -it tor-relay-coldav nyx

# Ver logs de Tor
docker exec -it tor-relay-coldav tail -f /var/log/tor/notices.log

# Ver información del sistema
docker exec -it tor-relay-coldav ps aux
```

### Verificación externa

```bash
# Buscar tu relay en la red Tor (después de unas horas)
curl -s "https://metrics.torproject.org/rs.html#search/relaycoldav"
```

## Configuración de firewall

Asegúrate de que los puertos estén abiertos en tu firewall:

```bash
# Para Ubuntu/Debian con ufw
sudo ufw allow 9001
sudo ufw allow 9030

# Para CentOS/RHEL con firewalld
sudo firewall-cmd --permanent --add-port=9001/tcp
sudo firewall-cmd --permanent --add-port=9030/tcp
sudo firewall-cmd --reload
```

## Seguridad

- El contenedor ejecuta con usuario no privilegiado
- Configuración de solo lectura en el sistema de archivos
- Políticas de seguridad aplicadas (no-new-privileges)
- Exit policy configurada para rechazar todo el tráfico de salida

## Notas importantes

1. **Tiempo de activación**: Los nuevos relays pueden tardar algunas horas o días en aparecer en el consenso de la red Tor.

2. **Responsabilidad legal**: Ejecutar un relay Tor es legal en la mayoría de jurisdicciones, pero asegúrate de cumplir con las leyes locales.

3. **Recursos**: Aunque está limitado el ancho de banda, el relay seguirá consumiendo CPU y memoria según el tráfico.

4. **Actualizaciones**: Mantén actualizada la imagen de Tor para recibir parches de seguridad.

## Troubleshooting

### Error "no se puede escribir en /var/lib/tor"

Este error indica problemas de permisos. Soluciones:

```bash
# Detener el contenedor si está corriendo
docker-compose down

# Ejecutar el script de preparación
./setup.sh

# O configurar manualmente los permisos
sudo chown -R 1001:1001 ./logs
chmod 755 ./logs

# Reiniciar el contenedor
docker-compose up -d
```

### El relay no aparece en la red

- Verifica que los puertos estén abiertos y accesibles desde Internet
- Revisa los logs para errores de configuración
- Asegúrate de que la hora del sistema sea correcta

### Problemas de conectividad

```bash
# Verificar conectividad de puertos
docker exec -it tor-relay-coldav netstat -tlnp

# Probar conectividad externa
docker exec -it tor-relay-coldav curl -s https://check.torproject.org/
```

### Logs con errores

```bash
# Ver logs detallados
docker exec -it tor-relay-coldav tail -f /var/log/tor/info.log

# Verificar configuración
docker exec -it tor-relay-coldav tor --verify-config -f /etc/tor/torrc
```

## Contribución

Para contribuir al proyecto:
1. Realiza un fork del repositorio
2. Crea una rama para tu feature
3. Realiza tus cambios
4. Envía un pull request

## Licencia

Este proyecto está bajo la licencia MIT. Tor está bajo la licencia BSD de 3 cláusulas.
