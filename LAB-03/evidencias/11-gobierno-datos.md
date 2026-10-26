# Evidencia 11 — Matriz de Gobierno de Datos

## Objetivo
Establecer responsabilidades, controles de acceso y reglas de retención por cada atributo.

## Procedimiento
Se mapeó cada atributo personal con su respectivo Data Owner, usuarios autorizados, nivel de protección técnica y destino final al vencer su periodo de conservación.

## Resultado: Fichas de Gobierno de Datos

* **`nombre`**
  * **Finalidad:** Operación y Soporte
  * **Responsable (Data Owner):** Gerente de Atención a Clientes
  * **Usuarios Autorizados:** Soporte, Facturación
  * **Protección Técnica:** RLS / Vistas limitadas
  * **Retención:** Relación activa + 5 años
  * **Acción al Finalizar:** Cancelación / Purgado

---

* **`correo`**
  * **Finalidad:** Notificación y Contacto
  * **Responsable (Data Owner):** Gerente de Operaciones
  * **Usuarios Autorizados:** Soporte
  * **Protección Técnica:** Enmascaramiento en Dev
  * **Retención:** Relación activa
  * **Acción al Finalizar:** Purgado completo

---

* **`telefono`**
  * **Finalidad:** Contacto prioritario
  * **Responsable (Data Owner):** Gerente de Atención a Clientes
  * **Usuarios Autorizados:** Soporte
  * **Protección Técnica:** Enmascaramiento parcial
  * **Retención:** Relación activa
  * **Acción al Finalizar:** Purgado completo

---

* **`rfc`**
  * **Finalidad:** Facturación CFDI
  * **Responsable (Data Owner):** Contralor / Finanzas
  * **Usuarios Autorizados:** Facturación únicamente
  * **Protección Técnica:** Cifrado a nivel de columna
  * **Retención:** 5 años legales
  * **Acción al Finalizar:** Borrado seguro

---

* **`edad`**
  * **Finalidad:** Demografía agregada
  * **Responsable (Data Owner):** Líder de BI
  * **Usuarios Autorizados:** Analítica
  * **Protección Técnica:** Supresión en crudo (Uso de rangos)
  * **Retención:** 2 años
  * **Acción al Finalizar:** Anonimización irreversible

---

* **`ciudad`**
  * **Finalidad:** Logística y Estadística
  * **Responsable (Data Owner):** Gerente de Operaciones
  * **Usuarios Autorizados:** Soporte, Analítica
  * **Protección Técnica:** Ninguna (Dato no identificable por sí solo)
  * **Retención:** 5 años
  * **Acción al Finalizar:** Conservación estadística agregada

---

* **`codigo_postal`**
  * **Finalidad:** Envíos e Impuestos
  * **Responsable (Data Owner):** Gerente de Operaciones
  * **Usuarios Autorizados:** Facturación, Soporte
  * **Protección Técnica:** Validación de formato
  * **Retención:** 5 años
  * **Acción al Finalizar:** Purgado de tablas temporales

---

## Conclusión
Esta matriz asigna la propiedad de los datos a los dueños del negocio (Data Owner), liberando al DBA para actuar en su rol correcto de custodio técnico (Data Custodian).