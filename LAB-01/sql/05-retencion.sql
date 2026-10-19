-- 05-retencion.sql
-- Identificación de registros que exceden el periodo de conservación (5 años)

SELECT 
    id,
    nombre,
    fecha_alta,
    CURRENT_DATE - fecha_alta AS dias_antiguedad
FROM clientes
WHERE fecha_alta < CURRENT_DATE - INTERVAL '5 years';