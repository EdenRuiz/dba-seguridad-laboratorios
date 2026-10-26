-- LAB-04: Inspección de extensiones y parámetros de conexión (Actividades 10 y 11)

-- 1. Extensiones instaladas
SELECT extname, extversion 
FROM pg_extension 
ORDER BY extname;

-- 2. Configuración de límites y timeouts
SHOW max_connections;
SHOW superuser_reserved_connections;
SHOW statement_timeout;
SHOW idle_in_transaction_session_timeout;