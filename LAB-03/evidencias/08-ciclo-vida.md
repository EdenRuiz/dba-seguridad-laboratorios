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