# Evidencia 08: Análisis de Escenario de Seguridad

## Objetivo
Evaluar una arquitectura de base de datos vulnerable e identificar las medidas correctivas integrales.

## Comando o procedimiento
Se analizó un caso hipotético con contraseñas en texto claro, RFC sin cifrar, falta de validación TLS y claves dentro de scripts SQL.

## Resultado obtenido
Respuestas detalladas al análisis de riesgos:
1. **Riesgos principales:** Fuga masiva de credenciales, intercepción de tráfico (*MITM*), robo de datos en respaldos y descifrado no autorizado por claves expuestas.
2. **Mecanismos correctivos:** Hashing con sal para contraseñas, cifrado simétrico para RFC, conexiones TLS con `verify-full` y claves en un *Secrets Manager*.
3. **Problema más crítico:** Almacenar contraseñas y claves en texto claro, ya que anula cualquier otro esfuerzo de protección.
4. **Insuficiencia del RBAC:** Se confirmó que un esquema correcto de roles y permisos no protege los datos si los archivos físicos o las redes son vulnerados.

## Análisis
Los controles de acceso (RBAC) regulan *quién* puede ejecutar consultas, pero no protegen la información si el almacenamiento físico o el canal de red resultan comprometidos.

## Conclusión
La seguridad en bases de datos requiere un enfoque de **defensa en profundidad**, donde los permisos, el cifrado en reposo, el cifrado en tránsito y la custodia de claves operen de manera coordinada.