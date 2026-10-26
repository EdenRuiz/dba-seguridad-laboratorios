# Evidencia 05 — Análisis de Finalidad Secundaria

## Objetivo
Evaluar las implicaciones legales y técnicas de utilizar datos operativos para finalidades no informadas originalmente (envío de promociones personalizadas).

## Procedimiento e interrogantes
* **1. ¿Tener los datos autoriza su uso para cualquier fin?**  
  No. El principio de limitación de finalidad (LFPDPPP Art. 12) establece que los datos no pueden ser tratados para fines distintos a los informados en el Aviso de Privacidad inicial.

* **2. Preguntas previas de la organización:**  
  * ¿El Aviso de Privacidad contempla finalidades mercadotécnicas?  
  * ¿Se recabó el consentimiento explícito (*opt-in*) del titular?  
  * ¿Existe un mecanismo de cancelación/*opt-out* para dejar de recibir promociones?

* **3. Datos realmente necesarios para marketing:**  
  Únicamente correo electrónico y preferencias explícitas de suscripción. Se debe prescindir de RFC, edad exacta o identificadores internos.

* **4. Acceso directo de marketing a la tabla `clientes`:**  
  No. Marketing no requiere acceso directo en lectura a la base de datos de producción.

* **5. Controles técnicos de limitación:**  
  Creación de vistas dedicadas que filtren únicamente clientes con bandera `consentimiento_marketing = TRUE`, o exportación de listas anonimizadas/seudonimizadas mediante tokens hacia la plataforma de envíos.

## Resultado
Un análisis estructurado que demuestra que antes de activar cualquier campaña comercial, la organización debe adecuar el marco jurídico y aplicar barreras técnicas en PostgreSQL.

## Conclusión
Una finalidad secundaria requiere reconsiderar la base jurídica de tratamiento. Técnica y operativamente, el DBA debe restringir el acceso directo a producción a áreas promocionales.