# Matriz de Cambios de Hardening y Lista de Verificación

## 1. Línea Base Antes vs. Después (Actividad 16)

| Control | Antes | Después | Justificación |
|---|---|---|---|
| **listen_addresses** | `'*'` | `'10.10.10.20'` | Impedir que la base de datos sea visible desde interfaces públicas o innecesarias. |
| **pg_hba.conf** | `host all all 0.0.0.0/0 md5` | `host comercializadora app_user 10.10.10.0/24 scram-sha-256` | Restringir el acceso a la DB correcta, con el usuario correcto, desde la red correcta, con cifrado moderno. |
| **Usuarios Administrativos** | Aplicación usaba `postgres` | App usa `app_user` (sin SUPERUSER) | Evitar compromiso total del servidor si la aplicación sufre una vulnerabilidad de inyección SQL. |
| **Permisos OS** | `0644` en `pg_hba.conf` | `0600` en `pg_hba.conf` | Evitar que otros usuarios del sistema operativo lean reglas de acceso o configuraciones. |
| **TLS** | `ssl = off` / Opcional | `ssl = on` (TLSv1.2+) | Prevenir interceptación de tráfico (Man-in-the-Middle) y robo de credenciales en la red. |
| **Timeouts** | `0` (Infinito) | `60000ms` (60s) | Liberar recursos y bloqueos dejados por conexiones inactivas o scripts colgados. |

---

## 2. Checklist de Hardening (Actividad 17)

| # | Control | Verificado | Evidencia (Comando/Ruta) |
|---|---|:---:|---|
| 1 | Puerto documentado y justificado | ✅ | `SHOW port;` |
| 2 | Interfaces de escucha restringidas (`listen_addresses`) | ✅ | `SHOW listen_addresses;` |
| 3 | Reglas `0.0.0.0/0` eliminadas de `pg_hba.conf` | ✅ | `SELECT * FROM pg_hba_file_rules;` |
| 4 | Métodos obsoletos (`trust`, `md5`) eliminados de `pg_hba` | ✅ | `SELECT auth_method FROM pg_hba_file_rules;` |
| 5 | Encriptación de contraseñas seteada en `scram-sha-256` | ✅ | `SHOW password_encryption;` |
| 6 | Superusuarios limitados y nominales | ✅ | `\du` o vista `pg_roles` |
| 7 | Aplicación utiliza un rol sin privilegios DDL (`app_user`) | ✅ | Revocación de `SUPERUSER` verificada |
| 8 | Extensiones no utilizadas desinstaladas | ✅ | `SELECT extname FROM pg_extension;` |
| 9 | SSL activado en el motor de base de datos | ✅ | `SHOW ssl;` |
| 10 | Versión de TLS restringida (mínimo TLS 1.2) | ✅ | `SHOW ssl_min_protocol_version;` |
| 11 | `idle_in_transaction_session_timeout` configurado | ✅ | `SHOW idle_in_transaction_session_timeout;` |
| 12 | Directorio de datos (`data_directory`) con permisos `0700` | ✅ | `ls -ld /var/lib/pgsql/data` |
| 13 | Archivos `.conf` con permisos `0600` (dueño `postgres`) | ✅ | `ls -l postgresql.conf` |
| 14 | Firewall de OS (iptables/ufw) bloqueando puerto 5432 excepto a IPs amigas | ✅ | `ufw status` / `iptables -L` |
| 15 | Conexiones de respaldo garantizadas (`superuser_reserved_connections`) | ✅ | `SHOW superuser_reserved_connections;` |