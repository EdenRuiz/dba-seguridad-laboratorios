# Evidencia 14 — Evaluación Integral de Riesgos

## Objetivo
Identificar vulnerabilidades, incumplimientos de privacidad y riesgos en la arquitectura actual de Comercializadora Norte S.A. de C.V.

## Procedimiento
Se evaluó el entorno operativo frente a los 10 hallazgos más críticos de privacidad y gobierno de datos.

## Resultado: Desglose de Riesgos y Controles

* **1. Analítica consulta directamente la tabla de producción `clientes`**
  * **Principio Afectado:** Mínimo Privilegio / Minimización
  * **Riesgo:** Exposición no autorizada de PII (Nombre, Correo, RFC).
  * **Control Propuesto:** Crear rol `analista` y otorgar acceso solo a la vista `v_analitica_clientes`.

---

* **2. Uso de bases de datos productivas completas en ambientes de desarrollo/pruebas**
  * **Principio Afectado:** Confidencialidad / Minimización
  * **Riesgo:** Fuga de datos personales por entornos de desarrollo con menor seguridad.
  * **Control Propuesto:** Implementar enmascaramiento/anonimización de datos (*faking/obfuscation*) previa a la copia.

---

* **3. Conservación de datos por 12 años sin política documentada**
  * **Principio Afectado:** Limitación de Conservación
  * **Riesgo:** Multas regulatorias y aumento de superficie de impacto ante brechas.
  * **Control Propuesto:** Definir e implementar una política automatizada de purga y retención de datos.

---

* **4. Marketing utiliza correos operativos para campañas promocionales sin consentimiento**
  * **Principio Afectado:** Limitación de Finalidad
  * **Riesgo:** Sanciones por SPAM o violaciones a la LFPDPPP (finalidad secundaria no informada).
  * **Control Propuesto:** Separar listas de correo mediante consentimiento (*Opt-in*) y vistas de exclusión.

---

* **5. Falta de documentación sobre la finalidad de cada campo almacenado**
  * **Principio Afectado:** Gobierno de Datos / Responsabilidad
  * **Riesgo:** Indefinición de responsables y tratamientos arbitrarios de la información.
  * **Control Propuesto:** Elaborar y mantener actualizado el Catálogo y Matriz de Gobierno de Datos.

---

* **6. Ausencia de cifrado o enmascaramiento para datos sensibles (RFC)**
  * **Principio Afectado:** Confidencialidad
  * **Riesgo:** Lectura en texto plano por cualquier rol con acceso `SELECT`.
  * **Control Propuesto:** Aplicar cifrado de columna o enmascaramiento dinámico (*Data Masking*).

---

* **7. Falta de segregación de funciones entre administradores y usuarios analíticos**
  * **Principio Afectado:** Control de Acceso
  * **Riesgo:** Alteración accidental o maliciosa de datos operativos por analistas.
  * **Control Propuesto:** Asignar roles con permisos estrictos de lectura agregada (`NOLOGIN` base, roles específicos).

---

* **8. Inexistencia de registros de auditoría sobre lecturas de datos personales**
  * **Principio Afectado:** Trazabilidad
  * **Riesgo:** Imposibilidad de realizar análisis forense ante una fuga de información.
  * **Control Propuesto:** Habilitar auditoría en PostgreSQL (`pgaudit`) para consultas sobre datos sensibles.

---

* **9. Falta de mecanismo técnico para atender solicitudes de Cancelación/Oposición (ARCO)**
  * **Principio Afectado:** Atención a Derechos del Titular
  * **Riesgo:** Incumplimiento legal con los plazos de respuesta a titulares.
  * **Control Propuesto:** Diseñar procedimientos almacenados y flujos de trabajo para anonimización de solicitudes ARCO.

---

* **10. Acceso amplio del área de soporte a datos fiscales como el RFC**
  * **Principio Afectado:** Proporcionalidad
  * **Riesgo:** Exposición innecesaria de información financiera/fiscal al personal de soporte.
  * **Control Propuesto:** Rediseñar la tabla `clientes_soporte` omitiendo columnas fiscales.

## Conclusión
La identificación proactiva de riesgos permite priorizar la implementación de controles técnicos en el motor de base de datos antes de sufrir una brecha de seguridad o sanción legal.