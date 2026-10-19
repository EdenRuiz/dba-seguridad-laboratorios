-- Cifrado simétrico de datos almacenados en reposo usando PGP (pgcrypto)

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1. Tabla con campo cifrado (BYTEA)
CREATE TABLE IF NOT EXISTS clientes_protegidos (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    rfc_cifrado BYTEA NOT NULL
);

-- 2. Inserción de dato cifrado con clave simétrica ficticia de laboratorio
INSERT INTO clientes_protegidos (nombre, rfc_cifrado)
VALUES (
    'Ana López',
    pgp_sym_encrypt('LOPA900101ABC', 'CLAVE-DE-PRUEBA-LAB02')
);

-- 3. Consulta de la tabla (Muestra datos binarios cifrados/unreadable)
SELECT * FROM clientes_protegidos;

-- 4. Descifrado legítimo mediante suministro de la clave simétrica
SELECT 
    id,
    nombre,
    pgp_sym_decrypt(rfc_cifrado, 'CLAVE-DE-PRUEBA-LAB02') AS rfc_descifrado
FROM clientes_protegidos;