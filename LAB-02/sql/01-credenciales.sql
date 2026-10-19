-- Demostración de almacenamiento inseguro vs. seguro mediante password hashing (pgcrypto)

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1. Demostración insegura (Texto Claro - Mala Práctica)
CREATE TABLE IF NOT EXISTS usuarios_insegura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL
);

INSERT INTO usuarios_insegura (usuario, password)
VALUES ('juan', 'Password123')
ON CONFLICT DO NOTHING;

SELECT * FROM usuarios_insegura;

-- 2. Demostración segura (Password Hashing con Salt usando bcrypt)
CREATE TABLE IF NOT EXISTS usuarios_segura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL
);

INSERT INTO usuarios_segura (usuario, password_hash)
VALUES (
    'juan',
    crypt('Password123', gen_salt('bf'))
)
ON CONFLICT (usuario) DO NOTHING;

-- Verificación de credencial almacenada (No muestra la contraseña original)
SELECT * FROM usuarios_segura;

-- 3. Validación de Autenticación
-- Intento con Contraseña Correcta (Retorna TRUE)
SELECT 
    usuario, 
    (password_hash = crypt('Password123', password_hash)) AS contraseña_correcta
FROM usuarios_segura
WHERE usuario = 'juan';

-- Intento con Contraseña Incorrecta (Retorna FALSE)
SELECT 
    usuario, 
    (password_hash = crypt('OtraPassword', password_hash)) AS contraseña_correcta
FROM usuarios_segura
WHERE usuario = 'juan';