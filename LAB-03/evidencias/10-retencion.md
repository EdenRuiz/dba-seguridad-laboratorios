# Evidencia 10 — Política de Retención y Conservación

## Objetivo
Evaluar los riesgos de conservar información personal de forma indefinida.

## Procedimiento
Se analizaron los impactos operativos, legales y de seguridad de mantener registros de clientes sin un plazo fijado de expiración.

## Resultado: Análisis de Preguntas
* **1. ¿Es compatible la retención indefinida con la minimización?**  
  No. Conservar datos "por si acaso" viola directamente el principio de minimización y limitación del plazo de conservación.

* **2. Riesgos de conservar datos innecesarios:**  
  * Aumento del impacto ante una brecha de seguridad (*data breach*).  
  * Mayores costos de almacenamiento y tiempo de respaldo.  
  * Incurrimiento en faltas administrativas y sanciones regulatorias.

* **3. Criterios para determinar periodos de retención:**  
  * Obligaciones legales (fiscales, mercantiles, laborales).  
  * Prescripción de acciones judiciales o contractuales.  
  * Utilidad operativa legítima.

* **4. Información a documentar:**  
  * Base legal/normativa del plazo seleccionado.  
  * Procedimiento automatizado de purga o anonimización al vencer el plazo.

## Conclusión
El DBA debe implementar tareas programadas (`pg_cron` o jobs externos) para depurar o anonimizar registros cuyo periodo de conservación haya expirado.