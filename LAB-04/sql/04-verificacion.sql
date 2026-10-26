-- LAB-04: Verificación de conexiones cifradas (Actividad 15)

SHOW ssl_min_protocol_version;

-- Verificar si las sesiones actuales están utilizando TLS
SELECT 
    s.pid, 
    a.usename, 
    a.client_addr, 
    s.ssl, 
    s.version, 
    s.cipher
FROM pg_stat_ssl s
JOIN pg_stat_activity a ON s.pid = a.pid
WHERE a.client_addr IS NOT NULL;