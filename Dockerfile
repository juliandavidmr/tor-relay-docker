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

# Crear usuario tor si no existe
RUN groupadd -r tor || true && \
    useradd -r -g tor -d /var/lib/tor -s /bin/false tor || true

# Crear directorios necesarios
RUN mkdir -p /var/lib/tor /var/log/tor /run/tor && \
    chown -R tor:tor /var/lib/tor /var/log/tor /run/tor && \
    chmod 700 /var/lib/tor

# Copiar configuración personalizada
COPY torrc /etc/tor/torrc
RUN chown root:root /etc/tor/torrc && chmod 644 /etc/tor/torrc

# Crear script de inicio
COPY start-tor.sh /usr/local/bin/start-tor.sh
RUN chmod +x /usr/local/bin/start-tor.sh

# Exponer puertos
EXPOSE 9001 9030

# Cambiar al usuario tor
USER tor

# Punto de entrada
ENTRYPOINT ["/usr/local/bin/start-tor.sh"]
