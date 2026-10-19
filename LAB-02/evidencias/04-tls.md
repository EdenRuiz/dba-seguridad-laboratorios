# Evidencia 04: Verificación del Estado de TLS/SSL

## Objetivo
Verificar la configuración y el estado activo del cifrado en tránsito (TLS/SSL) en las conexiones del servidor PostgreSQL.

## Comando o procedimiento
Se consultaron los parámetros generales del servidor y la vista del sistema `pg_stat_ssl`:

## Resultado obtenido
SHOW ssl; devolvió on.

La consulta a pg_stat_ssl retornó ssl = true, mostrando el protocolo en uso (ej. TLSv1.3) y el algoritmo de cifrado asignado a la sesión actual.

## Análisis
Protección en tránsito: TLS protege los datos que viajan por la red entre el cliente y el servidor, evitando ataques de escucha pasiva (sniffing) y de alteración de tráfico (Man-in-the-Middle).

Verificación de servidor: Modos como sslmode=verify-full aseguran no solo que la comunicación esté cifrada, sino que el certificado del servidor sea auténtico y coincida con el nombre de dominio al que se conecta el cliente.

## Conclusión
TLS es el estándar indispensable para proteger las comunicaciones en tránsito de una base de datos. Impide que las credenciales o las consultas enviadas por los usuarios puedan ser interceptadas en la red.

```sql
SHOW ssl;
SHOW ssl_min_protocol_version;

SELECT pid, ssl, version, cipher 
FROM pg_stat_ssl 
WHERE pid = pg_backend_pid();