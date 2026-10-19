# Evidencia 01: Protección de Credenciales

## Objetivo
Demostrar el riesgo de almacenar contraseñas en texto claro y aplicar mecanismos de hashing con sal (bcrypt) para proteger credenciales de acceso.

## Procedimiento y Comandos
Se crearon las tablas `usuarios_insegura` y `usuarios_segura`. Se utilizó la función `crypt()` combinada con `gen_salt('bf')` de la extensión `pgcrypto`.

## Resultado obtenido
Tabla insegura: Muestra directamente la contraseña 'Password123' en texto claro.

Tabla segura: Guarda un hash incomprensible (ej. $2a$06$...).

Validación:

Evaluando con 'Password123', el resultado en contraseña_correcta fue true.

Evaluando con 'OtraPassword', el resultado fue false.

## Análisis
Generación de sal: Cada llamada a gen_salt('bf') genera un valor aleatorio distinto. Esto evita que dos contraseñas iguales produzcan el mismo hash y neutraliza los ataques con tablas arcoíris.

Verificación sin descifrar: Un hash es una función matemática unidireccional. No se requiere "descifrar" la contraseña original para autenticar; únicamente se aplica el mismo hash a la contraseña ingresada y se compara.

## Conclusión
Almacenar contraseñas en texto claro es una práctica inaceptable de seguridad. Las credenciales deben protegerse siempre con algoritmos de hashing diseñados para contraseñas (como bcrypt, Argon2id o scrypt) combinados con sal aleatoria.

```sql
INSERT INTO usuarios_segura (usuario, password_hash)
VALUES ('juan', crypt('Password123', gen_salt('bf')));

Se probó la autenticación con la contraseña correcta e incorrecta
 
SELECT usuario, (password_hash = crypt('Password123', password_hash)) AS contraseña_correcta
FROM usuarios_segura WHERE usuario = 'juan';

