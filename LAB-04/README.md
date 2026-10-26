# LAB-04 — Hardening y Configuración Segura de PostgreSQL

**Alumno:** Eden Uziel Ruiz Olea  
**Unidad:** II — Seguridad, privacidad y control de acceso  
**Tema:** 2.6 Hardening de bases de datos  
**Motor:** PostgreSQL 16  

---

## 1. Objetivo
Aplicar un proceso de hardening integral sobre un servidor PostgreSQL para reducir drásticamente su superficie de ataque. Se transitará desde una instalación genérica altamente permisiva hacia una línea base de seguridad documentada mediante controles de red, autenticación, autorización y sistema operativo.

## 2. Entorno
* **Sistema de Base de Datos:** PostgreSQL 16.
* **Contexto:** Entorno aislado de laboratorio académico que simula la infraestructura de la empresa Comercializadora Norte S.A. de C.V.

## 3. Superficie de Ataque Inicial (Hallazgos)
La inspección inicial reveló graves deficiencias de configuración (*Secure by default* vulnerado):
1. **Red expuesta:** El servicio escuchaba en todas las interfaces de red (`listen_addresses = '*'`).
2. **Control de acceso deficiente:** El archivo `pg_hba.conf` permitía autenticación desde cualquier IP (`0.0.0.0/0`) hacia cualquier base de datos.
3. **Privilegios excesivos:** Las aplicaciones se conectaban con roles portadores del permiso `SUPERUSER`.
4. **Criptografía pasiva:** TLS desactivado o sin obligatoriedad, y parámetros contra agotamiento de recursos ausentes.

## 4. Cambios Realizados y Justificación
Se aplicó el modelo de seguridad en capas:
* **Capa OS / Red:** Bloqueo en firewall y restricción del parámetro de escucha únicamente a la subred interna necesaria. Justificación: Detiene ataques automatizados externos.
* **Capa Autenticación (`pg_hba.conf`):** Se erradicaron rangos `0.0.0.0/0`, reemplazándolos por perfiles `host` específicos combinados obligatoriamente con encriptación `scram-sha-256`.
* **Capa Autorización (Roles):** Se segregó el rol administrativo `dba_admin` del rol operativo `app_user` (principio de mínimo privilegio).
* **Capa Tránsito y Disponibilidad:** Se validó TLS y se establecieron límites temporales como `idle_in_transaction_session_timeout` para evitar ataques DoS por ocupación de conexiones.

## 5. Verificación
La validación post-hardening confirma que:
* Consultas a `pg_hba_file_rules` no muestran subredes globales.
* Consultas a `pg_roles` evidencian la revocación de propiedades administrativas a usuarios operativos.
* La vista `pg_stat_ssl` ratifica que el tráfico actual se encuentra cifrado.

## 6. Documentación Adicional
La carpeta `/configuracion` contiene:
* `baseline.md`: Propuesta de arquitectura y línea base esperada.
* `cambios.md`: Matriz de cambios efectuados y Checklist de los 15 controles aplicados.
El archivo `informe.md` contiene el desarrollo del caso de estudio integral, el cuestionario analítico y la reflexión final.

## 7. Conclusiones
El hardening demostró que la seguridad de la base de datos es sistémica. Configurar contraseñas robustas o cifrar columnas carece de valor si el archivo `pg_hba.conf` es laxo, si la red carece de segmentación o si el sistema operativo no protege los archivos de configuración (`postgresql.conf`). La seguridad requiere alinear OS, Red, Autenticación, Autorización y Auditoría de forma holística.