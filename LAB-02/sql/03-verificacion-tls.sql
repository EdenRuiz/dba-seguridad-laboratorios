-- Verificación del estado de cifrado en tránsito (TLS/SSL) en PostgreSQL

-- 1. Parámetros generales del servidor
SHOW ssl;
SHOW ssl_min_protocol_version;
SHOW port;
SHOW listen_addresses;

-- 2. Verificación del cliente y conexión actual
SELECT 
    inet_client_addr() AS ip_cliente,
    inet_client_port() AS puerto_cliente;

-- 3. Estado de TLS/SSL para la sesión actual
SELECT 
    pid,
    ssl,
    version,
    cipher,
    bits,
    client_dn
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();