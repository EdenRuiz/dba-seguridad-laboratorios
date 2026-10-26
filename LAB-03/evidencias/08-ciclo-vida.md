# Evidencia 08 — Cancelación y Ciclo de Vida del Dato

## Objetivo
Analizar la complejidad técnica de dar cumplimiento al derecho de Cancelación (ARCO) a lo largo del ciclo de vida del dato.

## Procedimiento
Se mapearon todas las entidades y réplicas donde la información de un cliente persiste tras un `DELETE` en la tabla primaria.

```text
clientes (Tabla Principal)
   │
   ├── respaldos (Backups en cinta/S3)
   ├── réplicas (Standby / Read Replicas)
   ├── reportes (Archivos PDF / Excel generados)
   ├── exportaciones (Datasets para pruebas/Analítica)
   └── sistemas externos (CRMs, pasarelas de pago, logs)

   Resultado
Identificación de los puntos críticos donde la información permanece almacenada a pesar de ser borrada de la base de datos de producción.

Análisis
Un comando DELETE FROM clientes WHERE id = X; solo impacta la tabla operativa en caliente. Los principales retos son:

1. Respaldos: Modificar un backup binario de PostgreSQL es técnicamente inviable. La solución consiste en registrar la cancelación en una lista de supresión que reaplique el borrado si se restaura un backup anterior.

2. Logs y Auditorías: Por ley fiscal (CFF) o auditoría de seguridad, ciertos rastros de transacciones deben conservarse (bloqueados) sin ser eliminados inmediatamente.

3. Réplicas y Caché: La baja debe propagarse por replicación lógica/física y purgar capas de caché (Redis/Memcached).

Conclusión
La eliminación técnica de un dato exige una estrategia de orquestación en todo el ecosistema de TI, no una simple sentencia DML en la base principal.