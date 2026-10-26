-- LAB-04: Inspección de Superficie de Ataque y Configuración (Actividades 1, 2, 3 y 4)

-- 1. Identificación del motor y superficie de ataque básica
SELECT version();
SHOW port;
SHOW listen_addresses;
SHOW ssl;
SHOW password_encryption;

-- 2. Conexiones activas actuales
SELECT pid, usename, datname, client_addr, client_port, application_name
FROM pg_stat_activity
WHERE client_addr IS NOT NULL;

-- 3. Ubicación de archivos sensibles
SHOW config_file;
SHOW hba_file;
SHOW ident_file;
SHOW data_directory;
SHOW log_directory;

-- 4. Inspección de reglas de pg_hba.conf (Autenticación basada en host)
SELECT type, database, user_name, address, auth_method
FROM pg_hba_file_rules
ORDER BY type, address;