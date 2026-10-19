# Evidencia 02: Cifrado de Información Sensible

## Objetivo
Implementar cifrado simétrico en columnas de base de datos para proteger atributos confidenciales (RFC) almacenados en reposo.

## Comando o procedimiento
Se creó la tabla `clientes_protegidos` con el campo `rfc_cifrado` de tipo `BYTEA`. Se utilizó la función `pgp_sym_encrypt()` para cifrar el valor al insertar y `pgp_sym_decrypt()` para recuperarlo:

## Resultado obtenido
Al realizar un SELECT *, el campo rfc_cifrado se muestra en formato binario ininteligible (\xc30d0407...). Al aplicar pgp_sym_decrypt() con la clave simétrica correcta, la base de datos devuelve la cadena original 'LOPA900101ABC'.

## Análisis
Diferencia entre hash y cifrado: crypt() produce un valor unidireccional que jamás se puede recuperar en texto claro. pgp_sym_encrypt() es un mecanismo bidireccional que permite recuperar el dato original cuando un proceso autorizado proporciona la clave simétrica.

Control de claves: Si se intenta descifrar utilizando una clave incorrecta, PostgreSQL arroja un error de descifrado y no expone el contenido.

## Conclusión
El cifrado simétrico en reposo protege la confidencialidad de datos sensibles almacenados en disco, garantizando que no puedan ser leídos si los archivos físicos o respaldos de la base de datos son extraviados o robados.

```sql
INSERT INTO clientes_protegidos (nombre, rfc_cifrado)
VALUES ('Ana López', pgp_sym_encrypt('LOPA900101ABC', 'CLAVE-DE-PRUEBA-LAB02'));

SELECT id, nombre, pgp_sym_decrypt(rfc_cifrado, 'CLAVE-DE-PRUEBA-LAB02') AS rfc
FROM clientes_protegidos;