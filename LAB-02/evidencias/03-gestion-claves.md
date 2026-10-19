# Evidencia 03: El Problema de la Gestión de Claves

## Objetivo
Identificar las implicaciones de seguridad asociadas al almacenamiento de claves criptográficas y secretos directamente dentro de archivos SQL, scripts o repositorios.

## Comando o procedimiento
Se analizó la consulta empleada en la demostración técnica:

## Resultado obtenido
Se confirmó que cualquier persona o herramienta con permisos para leer el archivo SQL puede extraer la clave de descifrado directamente en texto claro.

## Análisis
Exposición en repositorios: Si un archivo con claves reales se publica en un repositorio Git, la clave queda expuesta a todos los usuarios con acceso al proyecto.

Persistencia en el historial: Aunque la clave se elimine en un commit posterior, continuará existiendo permanentemente en el historial de commits anteriores de Git (git log).

## Conclusión
Las claves criptográficas nunca deben almacenarse en scripts ni en repositorios de código fuente (hardcoded secrets). Deben administrarse fuera de la base de datos mediante variables de entorno protegidas o sistemas dedicados a la gestión de secretos (Secrets Managers).

```sql
SELECT pgp_sym_decrypt(rfc_cifrado, 'CLAVE-DE-PRUEBA-LAB02') 
FROM clientes_protegidos;