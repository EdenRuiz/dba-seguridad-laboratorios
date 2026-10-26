# Línea Base de Seguridad (Baseline) — PostgreSQL 16

## 1. Red y Exposición
* **Interfaces autorizadas (`listen_addresses`):** Configurar únicamente en la IP privada de la red de base de datos (Ej. `10.10.10.20`), nunca en `*` (0.0.0.0).
* **Puerto:** TCP 5432 (o uno modificado internamente, siempre respaldado por el firewall).
* **Firewall:** Regla *Allowlist* estricta. Bloqueo por defecto (`DROP`). Solo permitir el puerto 5432 desde la subred de servidores de aplicaciones y la subred de DBAs (Ej. `10.10.10.0/24`).

## 2. Autenticación
* **Método estándar:** `scram-sha-256` en todas las reglas de `pg_hba.conf`. Rechazar `md5`, `trust` o `password`.
* **Políticas de credenciales:** Uso de gestor de contraseñas rotativas. Ninguna contraseña embebida en código fuente.

## 3. Autorización (Mínimo Privilegio)
* **Cuentas de aplicación:** `NOSUPERUSER`, `NOCREATEDB`, `NOCREATEROLE`. Propietarias únicamente de las tablas/esquemas requeridos por el ORM o la aplicación.
* **Cuentas administrativas:** Uso de cuentas `dba_nombre` en lugar del rol genérico `postgres`.

## 4. Configuración (Parámetros)
* **Timeouts:** `idle_in_transaction_session_timeout` fijado (Ej. 60s) para evitar bloqueos por transacciones huérfanas.
* **Conexiones:** `max_connections` dimensionado a los recursos reales (Ej. 100). `superuser_reserved_connections` = 3 (para garantizar acceso de emergencia).

## 5. Sistema Operativo y Archivos
* **Propiedad:** Todos los archivos en `/var/lib/pgsql` (o equivalente) deben pertenecer a `postgres:postgres`.
* **Permisos:** Directorio de datos en `0700` (`drwx------`). Archivos `postgresql.conf` y `pg_hba.conf` en `0600`.

## 6. Cifrado (TLS)
* **Conexiones:** `ssl = on`. Obligar a los clientes a conectarse con `sslmode=require` o superior.
* **Versión mínima:** `ssl_min_protocol_version = 'TLSv1.2'`.

## 7. Mantenimiento y Auditoría
* **Actualización:** Patching mensual tras validación en entorno de Staging.
* **Trazabilidad:** Extensión `pgaudit` habilitada para registrar escalamiento de privilegios y cambios DDL.