-- LAB-03: Control de Acceso por Roles y Vistas
-- Restricción del rol analista únicamente a vistas anonimizadas/agregadas

DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'analista') THEN
      CREATE ROLE analista NOLOGIN;
   END IF;
END $$;

CREATE OR REPLACE VIEW v_analitica_clientes AS
SELECT
    ciudad,
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END AS rango_edad
FROM clientes;

GRANT USAGE ON SCHEMA public TO analista;
GRANT SELECT ON v_analitica_clientes TO analista;

REVOKE ALL ON clientes FROM analista;

-- Verificación de privilegios asignados al rol
SELECT grantee, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'analista';