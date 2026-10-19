# Evidencia 07: Comparación de Mecanismos Criptográficos

## Objetivo
Comparar y clasificar los mecanismos criptográficos adecuados para la protección de credenciales, datos en reposo, datos en tránsito y respaldos.

## Comando o procedimiento
Se estructuró una matriz comparativa analizando las necesidades de protección según el estado del dato:

| Situación | Mecanismo apropiado | ¿Qué protege? |
| :--- | :--- | :--- |
| **Contraseña de usuario** | Password Hashing (`crypt`, bcrypt) | Evita la exposición de credenciales en filtraciones de la BD. Es unidireccional. |
| **RFC almacenado en una tabla** | Cifrado en reposo (`pgp_sym_encrypt`) | Protege la confidencialidad en disco, permitiendo recuperar el valor original con la clave. |
| **Consulta cliente -> servidor** | Cifrado en tránsito (TLS / `sslmode`) | Protege la información transmitida en la red contra intercepción o modificación. |
| **Respaldo de base de datos** | Cifrado de respaldos (PGP / AES-256) | Impide la lectura de información confidencial si el archivo de backup es sustraído. |
| **Clave criptográfica** | Gestor de secretos / Vars. de entorno | Evita que la clave principal sea leída o expuesta en repositorios de código. |

## Resultado obtenido
Matriz descriptiva categorizada por tipo de dato y control técnico requerido.

## Análisis
Cada problema de seguridad requiere una solución específica: las contraseñas no se cifran (se aplica hash), los datos a recuperar no se procesan con hash (se cifran), y la red se protege independientemente con TLS.

## Conclusión
La seguridad no se resuelve con un solo mecanismo. Una arquitectura segura combina hashing para credenciales, cifrado simétrico para atributos confidenciales en reposo, TLS para el tráfico en red y un manejo aislado de claves.