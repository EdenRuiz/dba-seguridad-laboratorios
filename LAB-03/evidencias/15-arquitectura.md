# Evidencia 15 — Propuesta de Arquitectura de Datos Protegidos

## Objetivo
Diseñar una propuesta conceptual para separar la información de acuerdo con su finalidad y nivel de confidencialidad.

## Procedimiento
Se estructuró un esquema de base de datos dividido funcionalmente mediante capas de aislamiento en PostgreSQL 16.

## Esquema Arquitectónico Conceptual


                               BASE DE DATOS (PostgreSQL 16)
                                             │
               ┌─────────────────────────────┼─────────────────────────────┐
               ▼                             ▼                             ▼
       ESQUEMA OPERACIÓN             ESQUEMA ANALÍTICA             ESQUEMA AUDITORÍA
 (Soporte / Facturación)              (Business Intelligence)       (Seguridad / DBA)
               │                             │                             │
               ├── clientes_soporte          ├── v_analitica_clientes      └── audit_log (pgaudit)
               └── clientes_facturacion      │    (Datos Agregados)               (Trazabilidad)
                       │                     │
                       ▼                     ▼
             [RLS + Cifrado RFC]      [Acceso Limitado a Vistas]

             

             Resultado: Componentes de Seguridad y Gobierno
1. Acceso: Roles segregados (rol_soporte, rol_facturacion, analista) bajo el principio de mínimo privilegio.

2. Minimización: Tablas y vistas específicas por función operativa.

3. Protección de Datos Sensibles: Enmascaramiento de correos/teléfonos para soporte y cifrado de columna para el RFC.

4. Retención: Job automático ejecutado vía pg_cron que purga registros inactivos a más de 5 años.

5. Trazabilidad: Extensión pgaudit activa para registrar cualquier acceso a datos personales sensibles.

6. Eliminación y ARCO: Función almacenada sp_atender_cancelacion_arco(id_cliente) que anonimiza datos operativos manteniendo integridad referencial.

Conclusión
Demuestra que los principios normativos de privacidad pueden traducirse en decisiones concretas de arquitectura dentro de PostgreSQL.