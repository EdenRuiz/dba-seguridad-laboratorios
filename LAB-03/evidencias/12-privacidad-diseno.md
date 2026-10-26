# Evidencia 12 — Privacidad por Diseño (Privacy by Design)

## Objetivo
Evaluar un diseño deficiente de tabla y proponer la aplicación de Privacidad por Diseño y Por Defecto.

## Procedimiento
Se auditó la propuesta del desarrollador para la creación de una tabla con exceso de datos personales e irrelevantes para la operación básica.

## Resultado: Análisis de la Propuesta
* **1. Problemas identificados:** La tabla propuesta recopila información altamente sensible y desproporcionada (`salario`, `estado_civil`, `ocupacion`, `fecha_nacimiento` completa) sin justificación operativa explicada.
* **2. Principios ignorados:** Minimización de datos, proporcionalidad y Privacidad por Defecto.
* **3. Preguntas previas a la aprobación:**  
  * ¿Para qué proceso específico se requiere el `salario` y `estado_civil`?  
  * ¿Es necesaria la `fecha_nacimiento` exacta o solo verificar mayoría de edad?
* **4. Datos a eliminar:** `salario`, `estado_civil`, `ocupacion`.
* **5. Datos a justificar:** `fecha_nacimiento` (reemplazar por un booleano `es_mayor_edad` si el negocio solo requiere validación legal).
* **6. Aplicación de Privacidad por Defecto:** Configurar tablas con mínimos campos obligatorios y denegar el acceso a nuevas columnas por defecto hasta revisar su finalidad.

## Conclusión
Aplicar Privacidad por Diseño desde la fase de modelado de datos previene la acumulación de pasivos de información sensible en producción.