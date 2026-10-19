# Reporte Final: LAB-02 — Cifrado, Credenciales y Comunicaciones Seguras

**Estudiante:** Eden Ruiz  
**Asignatura:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Unidad:** II — Seguridad, privacidad y control de acceso  
**Motor BD:** PostgreSQL 16  
**Modalidad:** Práctica individual  

---

## 1. Introducción
El objetivo de esta práctica es analizar e implementar mecanismos de protección criptográfica en PostgreSQL como un componente indispensable para complementar el esquema de control de acceso (RBAC). Se abordan tres necesidades fundamentales: la protección de credenciales mediante funciones de hashing unidireccionales, el cifrado de información sensible en reposo, la verificación de conexiones cifradas en tránsito (TLS) y la definición de políticas estrictas para evitar la exposición de claves o secretos en repositorios de código.

---

## 2. Protección de Credenciales
- **Texto Claro vs. Hash:** Almacenar contraseñas en texto claro expone a la organización a filtraciones masivas de credenciales. Las contraseñas no deben cifrarse con algoritmos reversibles, ya que la presencia de una clave de descifrado mantendría el riesgo de exposición.
- **Password Hashing con Salt:** Mediante la extensión `pgcrypto`, se utilizó la función `crypt()` configurada con un algoritmo de derivación de claves con sal aleatoria (`gen_salt('bf')` - bcrypt).
- **Verificación:** Se confirmó que el proceso de autenticación no requiere revertir el hash, sino aplicar la misma función sobre la contraseña ingresada y comparar el resultado con el hash almacenado.

---

## 3. Protección de Datos Sensibles
- **Cifrado en Reposto:** Para datos que requieren ser recuperados en su formato original por procesos autorizados (como el campo RFC), se implementó cifrado simétrico mediante la función `pgp_sym_encrypt()`.
- **Resultados:** El dato queda almacenado en la base de datos como una secuencia binaria incomprensible (`BYTEA`). La recuperación en texto claro únicamente es posible al ejecutar la función `pgp_sym_decrypt()` proporcionando la clave simétrica correspondiente.

---

## 4. Cifrado en Tránsito (TLS)
- **Verificación en PostgreSQL:** Se inspeccionó la vista de diagnóstico `pg_stat_ssl` y la variable global `SHOW ssl;`, confirmando que la sesión activa opera mediante conexiones cifradas basadas en TLS v1.3.
- **Protección de la Red:** TLS garantiza la confidencialidad e integridad de la información que viaja entre el cliente (pgAdmin/psql) y el servidor, previniendo ataques de intercepción pasiva (*eavesdropping*) o alteración de datos (*Man-in-the-Middle*).

---

## 5. Gestión de Claves y Secretos
- **Riesgo en Repositorios:** Almacenar claves o contraseñas en scripts SQL subidos a repositorios Git (*hardcoded secrets*) expone la seguridad de la organización. Aunque el archivo sea corregido en versiones posteriores, el secreto permanecerá accesible en el historial de commits anteriores (`git log`).
- **Política de Claves:** Se estableció una política obligatoria para gestionar claves fuera del código fuente, utilizando variables de entorno o gestores de secretos dedicados (*Secrets Managers*).

---

## 6. Respuestas a Preguntas de Reflexión

1. **¿Por qué una contraseña no debe almacenarse como texto claro?**  
   Porque cualquier usuario o atacante con acceso de lectura a la tabla obtendría de forma inmediata la credencial original, permitiendo la suplantación de identidad y el compromiso de cuentas en otros servicios.
2. **¿Por qué un hash no es equivalente a un cifrado?**  
   Un hash es una transformación matemática unidireccional (irreversible) diseñada para verificación; el cifrado es un proceso bidireccional diseñado para recuperar el dato original mediante una clave.
3. **¿Por qué el cifrado de una columna no sustituye al control de acceso?**  
   Porque el control de acceso limita qué cuentas pueden ejecutar consultas lógicas sobre las tablas, mientras que el cifrado protege la información física en disco contra robos de archivos o accesos no autorizados al almacenamiento.
4. **¿Por qué TLS no sustituye a los mecanismos de autorización de PostgreSQL?**  
   TLS asegura que la transmisión por el canal de red sea privada e inalterable, pero no controla qué permisos o privilegios posee la cuenta dentro del motor de la base de datos.
5. **¿Qué ocurriría si una organización pierde una clave utilizada para cifrar información?**  
   La información cifrada con esa clave queda completamente inalcanzable e irrecuperable (pérdida permanente de datos).
6. **¿Qué ocurriría si una clave criptográfica se publica accidentalmente en GitLab?**  
   Cualquier persona con acceso al historial del repositorio podría extraer la clave y descifrar la información confidencial de la organización.
7. **¿Por qué un repositorio privado no debe considerarse un almacén de secretos?**  
   Porque los permisos de desarrollo son más amplios que los de administración de secretos, y los secretos quedan clonados en las computadoras locales de todos los colaboradores.
8. **¿Qué diferencia existe entre proteger información almacenada y proteger información durante su transmisión?**  
   Proteger datos almacenados (en reposo) previene la extracción física de discos o respaldos; proteger la transmisión (en tránsito) evita la intercepción o manipulación de datos en la red.
9. **¿Por qué la gestión de claves es tan importante como el algoritmo criptográfico?**  
   Porque incluso el algoritmo criptográfico más robusto queda anulado si la clave que lo gobierna es robada, extraviada o expuesta en texto claro.
10. **¿Qué mecanismo adicional implementarías en una organización para proteger los respaldos de las bases de datos?**  
    Cifrado asimétrico previo al almacenamiento (usando PGP/GPG) y custodia de las copias en un almacenamiento secundario fuera del sitio (*off-site*) con control de acceso estricto.


## 7. Conclusiones
La seguridad de una base de datos exige un enfoque integral de defensa en profundidad. El enmascaramiento, la seudonimización y el control de acceso deben respaldarse con mecanismos criptográficos como el hashing de contraseñas con sal, el cifrado de columnas confidenciales en reposo, conexiones de red protegidas mediante TLS y una estricta política de gestión de claves fuera del código fuente.