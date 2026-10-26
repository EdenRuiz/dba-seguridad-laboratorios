# Informe Analítico de Hardening

**Alumno:** Eden Uziel Ruiz Olea  
**Materia:** Administración de Bases de Datos

---

## 1. Respuestas al Cuestionario de Hardening (Actividad 30)

1. **¿Cuál era la principal superficie de ataque?**
   El parámetro `listen_addresses = '*'` combinado con reglas permisivas en `pg_hba.conf` (0.0.0.0/0) y un firewall abierto. Esto exponía el puerto 5432 a cualquier red, dejando al servidor a expensas de ataques de fuerza bruta.
2. **¿Qué configuración representaba el mayor riesgo?**
   El uso de cuentas administrativas (`SUPERUSER`) por parte de la aplicación. Si la aplicación sufre una vulnerabilidad, el atacante obtiene control total de la base de datos e, indirectamente, del sistema operativo.
3. **¿Qué cambio produjo la mayor reducción de exposición?**
   Limitar `listen_addresses` a la IP privada y restringir el firewall. Esto invisibiliza el servicio de cara a Internet, anulando vectores de ataque externos inmediatamente.
4. **¿Qué diferencia existe entre firewall y pg_hba.conf?**
   El **firewall** opera a nivel de red (Capa 3/4), descartando paquetes antes de que lleguen a PostgreSQL. **`pg_hba.conf`** opera a nivel de aplicación (Capa 7), decidiendo si una conexión de red ya establecida tiene derecho a autenticarse y acceder a una base de datos concreta.
5. **¿Qué diferencia existe entre autenticación y autorización?**
   **Autenticación** es verificar *quién* eres (usuario y contraseña `scram-sha-256`). **Autorización** es verificar *qué* puedes hacer una vez dentro (permisos `SELECT`, roles `CREATEDB`).
6. **¿Por qué una cuenta de aplicación no debe ser SUPERUSER?**
   Por el principio de mínimo privilegio. La aplicación solo necesita leer/escribir registros operativos. Darle SUPERUSER permite crear nuevos roles, eliminar bases de datos, leer archivos de configuración y evadir controles de auditoría.
7. **¿Por qué cambiar el puerto de PostgreSQL no constituye hardening suficiente?**
   Es "seguridad por oscuridad". Un simple escaneo de puertos (como Nmap) descubrirá el nuevo puerto en cuestión de segundos. No mitiga vulnerabilidades de autenticación ni autorización.
8. **¿Por qué listen_addresses='*' puede ser innecesario?**
   Porque en arquitecturas de producción estándar, la base de datos se comunica exclusivamente con un grupo reducido de servidores (backend web o API) alojados en la misma red privada. Escuchar en la interfaz pública expone el servicio innecesariamente.
9. **¿Qué papel tiene el sistema operativo en la seguridad de PostgreSQL?**
   Un rol crítico. Si los permisos del sistema operativo son deficientes (ej. `chmod 777`), cualquier usuario que acceda al servidor mediante SSH podría leer `pg_hba.conf`, robar copias de seguridad del directorio de datos o alterar binarios, saltándose cualquier control interno de PostgreSQL.
10. **¿Qué controles deberían revisarse periódicamente?**
    La vigencia y robustez de contraseñas, auditoría de permisos de roles (evitar *privilege creep*), reglas de firewall obsoletas, parches del SGBD, y rotación de certificados TLS.

---

## 2. Caso Integral de Seguridad (Actividad 18 y 24)

### Matriz de Riesgos Identificados

| # | Problema | Riesgo | Control propuesto |
|---|---|---|---|
| 1 | `listen_addresses = '*'` | Visibilidad mundial del servicio. | Cambiar a IP de red privada. |
| 2 | Firewall abierto en TCP 5432 | Escaneo de puertos y fuerza bruta. | Regla Default DROP, Allowlist solo a IP de App. |
| 3 | `pg_hba.conf` permite `0.0.0.0/0` | Accesos desde subredes no autorizadas. | Modificar a subred específica (ej. `10.0.0.0/24`). |
| 4 | `pg_hba.conf` permite acceso a base de datos `all` | Movimiento lateral hacia otras bases de datos. | Especificar nombre de la base de datos de la App. |
| 5 | App utiliza rol administrativo (`SUPERUSER`) | Toma de control total vía SQL Injection. | Revocar SUPERUSER, crear rol con CRUD mínimo. |
| 6 | No hay segregación de funciones | DBA y App usan la misma cuenta. | Crear cuentas `dba_admin` y `app_user` separadas. |
| 7 | Contraseñas "fuertes" pero infraestructura débil | Robo de hash vía exposición de red local. | Implementar TLS (`ssl=on`) para cifrar en tránsito. |
| 8 | Método de autenticación no verificado en `pg_hba` | Riesgo de rebajar la autenticación a `md5` o `trust`. | Forzar `scram-sha-256` en las políticas de conexión. |
| 9 | Falta de restricción temporal / timeouts | Agotamiento de recursos por conexiones zombis. | Establecer `idle_in_transaction_session_timeout`. |
| 10 | Conexiones de emergencia no garantizadas | En caso de ataque DoS, el DBA pierde acceso. | Configurar `superuser_reserved_connections`. |

**¿Es suficiente tener contraseñas fuertes? (Análisis por capas)**
No. Una contraseña fuerte es inútil frente a un ataque de intermediario (Man-in-the-Middle) si no hay **Red/Cifrado (TLS)** para proteger el tránsito. Es inútil frente a una inyección SQL si la **Autorización** permite ejecutar `DROP TABLE` (app como SUPERUSER). Es inútil si el **Sistema Operativo** permite a un atacante leer los archivos físicos de la DB, y es inútil si la falta de **Monitoreo** permite miles de intentos de login o fugas silenciosas sin disparar alertas.

---

## 3. Reflexión Personal (Actividad 31)

**¿Qué cambiarías primero si recibieras la responsabilidad de asegurar un servidor PostgreSQL que ya se encuentra funcionando en producción?**

*Lo primero que cambiaría son las capas exteriores (Red y Firewall), específicamente la regla de `listen_addresses` y las excepciones del firewall del sistema operativo.*

**Justificación:**
El riesgo de impacto inmediato de un servidor expuesto a Internet (`listen_addresses = '*'`) es crítico. Mientras audito pacientemente los usuarios internos, los privilegios de la aplicación y la encriptación, el servidor sigue expuesto a redes de bots intentando fuerza bruta.
Cortar el acceso externo mediante firewall y restringir la escucha a la IP local/privada produce una **reducción masiva e inmediata de la superficie de ataque** sin interrumpir la continuidad operativa de la aplicación (que suele residir en la red interna). Una vez asegurado el perímetro, se puede aplicar *hardening* de autenticación, segregación de roles y TLS de forma controlada.