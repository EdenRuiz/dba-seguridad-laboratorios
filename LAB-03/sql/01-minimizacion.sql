-- LAB-03: Minimización de Datos para Soporte
-- Creación de la estructura mínima y carga filtrada desde clientes

DROP TABLE IF EXISTS clientes_soporte;

CREATE TABLE clientes_soporte (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    telefono VARCHAR(20)
);

INSERT INTO clientes_soporte (id, nombre, correo, telefono)
SELECT id, nombre, correo, telefono
FROM clientes;

SELECT * FROM clientes_soporte;