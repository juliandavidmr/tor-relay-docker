FROM debian:bullseye-slim

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    tor \
    tor-geoipdb \
    nyx \
    python3 \
    python3-pip \
    procps \
    curl \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario y grupo tor (usar IDs disponibles)
RUN groupadd -g 1001 toruser && \
    useradd -u 1001 -g 1001 -d /var/lib/tor -s /bin/false toruser

# Crear directorios necesarios con permisos correctos
RUN mkdir -p /var/lib/tor /var/log/tor /run/tor && \
    chown -R 1001:1001 /var/lib/tor /var/log/tor /run/tor && \
    chmod 755 /var/lib/tor /var/log/tor && \
    chmod 700 /run/tor

# Copiar configuración personalizada
COPY torrc /etc/tor/torrc
RUN chown root:root /etc/tor/torrc && chmod 644 /etc/tor/torrc

# Crear script de inicio
COPY start-tor.sh /usr/local/bin/start-tor.sh
RUN chmod +x /usr/local/bin/start-tor.sh

# Exponer puertos
EXPOSE 9001 9030

# Cambiar al usuario toruser
USER toruser

# Punto de entrada
ENTRYPOINT ["/usr/local/bin/start-tor.sh"]
