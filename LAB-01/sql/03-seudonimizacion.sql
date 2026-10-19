-- 1. Revocar privilegios previos que impiden el DROP del rol
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM analista_eden_ruiz;
REVOKE ALL ON SCHEMA public FROM analista_eden_ruiz;

-- 2. Eliminar y recrear el rol de forma limpia
DROP ROLE IF EXISTS analista_eden_ruiz;
CREATE ROLE analista_eden_ruiz NOLOGIN;

-- 3. Crear esquemas necesarios
CREATE SCHEMA IF NOT EXISTS pii;
CREATE SCHEMA IF NOT EXISTS analitica;

-- 4. Habilitar extensión para tokens UUID
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 5. Crear la tabla de correspondencia (Mapa protegido)
CREATE TABLE IF NOT EXISTS pii.mapa_cliente (
    token UUID PRIMARY KEY,
    cliente_id BIGINT UNIQUE REFERENCES public.clientes(id)
);

-- Generar tokens para los clientes existentes
INSERT INTO pii.mapa_cliente (token, cliente_id)
SELECT gen_random_uuid(), id FROM public.clientes
ON CONFLICT (cliente_id) DO NOTHING;

-- 6. Dataset para el área de analítica
CREATE TABLE IF NOT EXISTS analitica.clientes AS
SELECT
    m.token AS cliente_token,
    c.edad,
    c.ciudad,
    c.codigo_postal,
    c.fecha_alta
FROM pii.mapa_cliente m
JOIN public.clientes c ON c.id = m.cliente_id;

-- 7. Asignar permisos estrictos al rol analista
GRANT USAGE ON SCHEMA analitica TO analista_eden_ruiz;
GRANT SELECT ON analitica.clientes TO analista_eden_ruiz;

-- Denegar acceso al mapa de correspondencia y a los datos originales
REVOKE ALL ON ALL TABLES IN SCHEMA pii FROM analista_eden_ruiz;
REVOKE ALL ON public.clientes FROM analista_eden_ruiz;

-- 8. Verificación
SELECT * FROM analitica.clientes;