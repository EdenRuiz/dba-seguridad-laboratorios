# Evidencia 10: Política Mínima de Gestión de Claves Criptográficas

## Objetivo
Definir los lineamientos organizativos indispensables para la administración segura del ciclo de vida de las claves criptográficas.

## Comando o procedimiento
Se formuló una política de 8 reglas obligatorias:

1. **Prohibición en Código Fuente:** Prohibido guardar claves o secretos en scripts SQL o repositorios Git.
2. **Generación Segura:** Uso exclusivo de generadores aleatorios criptográficos seguros (CSPRNG).
3. **Almacenamiento Aislado:** Guardado en gestores de secretos o inyectados por variables de entorno.
4. **Mínimo Acceso:** Acceso restringido exclusivamente a los procesos o aplicaciones autorizados.
5. **Rotación Periódica:** Rotación obligatoria anual o inmediata ante sospechas de fuga.
6. **Respaldo Cifrado:** Copias de seguridad de claves cifradas en ubicaciones independientes.
7. **Respuesta ante Exposición:** Revocación e inhabilitación inmediata de cualquier clave filtrada.
8. **Destrucción Segura:** Eliminación irreversible de claves al finalizar su ciclo de vida útil.

## Resultado obtenido
Documento de política de gestión de claves estructurado y alineado con estándares técnicos.

## Análisis
El eslabón más débil de la criptografía suele ser la administración humana de las claves. Si la clave se pierde o se expone, el algoritmo criptográfico pierde toda su efectividad.

## Conclusión
Un algoritmo de cifrado robusitocubierto por una mala gestión de claves no ofrece seguridad real. La implementación estricta de políticas de custodia de claves es fundamental para respaldar cualquier control criptográfico en la organización.