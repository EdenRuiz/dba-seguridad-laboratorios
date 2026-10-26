# Evidencia 01 — Inventario y Finalidad de los Datos

## Objetivo
Clasificar los atributos de la tabla `clientes` identificando datos personales, su finalidad legítima, nivel de acceso restringido y tiempo de retención justificado.

## Procedimiento
Se auditó la estructura de la tabla `clientes` frente a las necesidades operativas de los roles organizacionales (Atención a clientes, Facturación, Analítica y DBA).

## Resultado: Inventario y Clasificación de Datos

* **`id`**
  * **¿Es dato personal?:** No
  * **Finalidad:** Identificación única de registro operativo
  * **¿Es necesario?:** Sí
  * **Nivel de acceso:** Todos los roles
  * **Retención:** Indefinido (Llave primaria interna)

---

* **`nombre`**
  * **¿Es dato personal?:** Sí
  * **Finalidad:** Identificar al titular en soporte y facturación
  * **¿Es necesario?:** Sí
  * **Nivel de acceso:** Soporte, Facturación
  * **Retención:** Durante vigencia de relación comercial + 5 años fiscal

---

* **`correo`**
  * **¿Es dato personal?:** Sí
  * **Finalidad:** Canal de comunicación y autenticación
  * **¿Es necesario?:** Sí
  * **Nivel de acceso:** Soporte
  * **Retención:** Durante vigencia de relación comercial

---

* **`telefono`**
  * **¿Es dato personal?:** Sí
  * **Finalidad:** Canal alternativo de contacto urgente
  * **¿Es necesario?:** Sí (Opcional)
  * **Nivel de acceso:** Soporte
  * **Retención:** Durante vigencia de relación comercial

---

* **`rfc`**
  * **¿Es dato personal?:** Sí (Sensible/Fiscal)
  * **Finalidad:** Cumplimiento de obligaciones tributarias (CFDI)
  * **¿Es necesario?:** Sí
  * **Nivel de acceso:** Facturación únicamente
  * **Retención:** 5 años contables (Art. 30 CFF México)

---

* **`edad`**
  * **¿Es dato personal?:** Sí
  * **Finalidad:** Segmentación demográfica agregada
  * **¿Es necesario?:** No en crudo (Utilizar rango)
  * **Nivel de acceso:** Analítica (Agregado)
  * **Retención:** Duración de la cuenta

---

* **`ciudad`**
  * **¿Es dato personal?:** Sí
  * **Finalidad:** Logística de envíos y estadísticas regionales
  * **¿Es necesario?:** Sí
  * **Nivel de acceso:** Soporte (Logística), Analítica
  * **Retención:** Duración de la cuenta

---

* **`codigo_postal`**
  * **¿Es dato personal?:** Sí
  * **Finalidad:** Validación fiscal y cálculo de envíos
  * **¿Es necesario?:** Sí
  * **Nivel de acceso:** Facturación, Soporte
  * **Retención:** 5 años contables

---

* **`fecha_alta`**
  * **¿Es dato personal?:** No
  * **Finalidad:** Control de antigüedad y auditoría operativa
  * **¿Es necesario?:** Sí
  * **Nivel de acceso:** DBA, Analítica
  * **Retención:** Indefinido

---

## Análisis
No todos los campos con carácter de dato personal deben tener el mismo nivel de visibilidad. El RFC es un dato fiscal sujeto a estricta reserva, mientras que el nombre y correo son necesarios para la interacción diaria de soporte. La edad cruda representa un riesgo innecesario de privacidad; para analítica basta con convertirlo a rangos agrupados.

## Conclusión
El inventario de datos permite definir barreras de acceso precisas antes de otorgar permisos globales en la base de datos, garantizando que cada departamento consulte únicamente lo necesario.