CREATE ROLE soporte_eden_ruiz NOLOGIN;

-- 2. Crear la vista enmascarada
CREATE OR REPLACE VIEW v_clientes_soporte AS
SELECT
    id,
    nombre,
    CONCAT(
        LEFT(correo, 2),
        '*****',
        SUBSTRING(correo FROM POSITION('@' IN correo))
    ) AS correo,
    CONCAT(
        '******',
        RIGHT(telefono, 4)
    ) AS telefono,
    CONCAT(
        '*********',
        RIGHT(rfc, 4)
    ) AS rfc
FROM clientes;

-- 3. Control de acceso
GRANT USAGE ON SCHEMA public TO soporte_eden_ruiz;
GRANT SELECT ON v_clientes_soporte TO soporte_eden_ruiz;
REVOKE ALL ON clientes FROM soporte_eden_ruiz;

-- 4. Verificación
SELECT * FROM v_clientes_soporte;