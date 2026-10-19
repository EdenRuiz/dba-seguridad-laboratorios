# Reporte de Práctica: LAB-01 — Protección y Privacidad de Datos

**Estudiante:** Eden Uziel Ruiz Olea  
**Asignatura:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Unidad:** II — Seguridad, privacidad y control de acceso  
 

---

### 1. Clasificación de Datos

#### Matriz de Clasificación (Formato Texto Descriptivo)

- **Campo: `id`**
  - **¿Identifica directamente?:** No
  - **¿Puede contribuir a identificar?:** Sí
  - **¿Requiere protección?:** Sí
  - **Justificación:** Es la clave primaria interna. Por sí sola no revela el nombre del titular, pero combinada con claves externas, logs o tablas relacionadas permite la reidentificación.

- **Campo: `nombre`**
  - **¿Identifica directamente?:** Sí
  - **¿Puede contribuir a identificar?:** Sí
  - **¿Requiere protección?:** Sí
  - **Justificación:** Identificador directo principal. Permite determinar la identidad real y física de la persona sin ambigüedad.

- **Campo: `correo`**
  - **¿Identifica directamente?:** Sí
  - **¿Puede contribuir a identificar?:** Sí
  - **¿Requiere protección?:** Sí
  - **Justificación:** Identificador directo único. Habitualmente está vinculado a la cuenta digital personal y contiene nombres o estructuras identificables.

- **Campo: `telefono`**
  - **¿Identifica directamente?:** Sí
  - **¿Puede contribuir a identificar?:** Sí
  - **¿Requiere protección?:** Sí
  - **Justificación:** Identificador directo de contacto individual. Su exposición permite la localización del titular y genera riesgos de privacidad.

- **Campo: `rfc`**
  - **¿Identifica directamente?:** Sí
  - **¿Puede contribuir a identificar?:** Sí
  - **¿Requiere protección?:** Sí
  - **Justificación:** Clave oficial única de identificación tributaria en México. Contiene iniciales y fecha de nacimiento del titular.

- **Campo: `edad`**
  - **¿Identifica directamente?:** No
  - **¿Puede contribuir a identificar?:** Sí
  - **¿Requiere protección?:** Sí
  - **Justificación:** Cuasi-identificador. No identifica por sí solo, pero cruzado con ubicación geográfica reduce significativamente el grupo de muestra.

- **Campo: `ciudad`**
  - **¿Identifica directamente?:** No
  - **¿Puede contribuir a identificar?:** Sí
  - **¿Requiere protección?:** No
  - **Justificación:** Dato geográfico amplio. Solo contribuye a la identificación si se cruza con múltiples cuasi-identificadores.

- **Campo: `codigo_postal`**
  - **¿Identifica directamente?:** No
  - **¿Puede contribuir a identificar?:** Sí
  - **¿Requiere protección?:** Sí
  - **Justificación:** Cuasi-identificador geográfico. En zonas o colonias con baja densidad de población facilita la reidentificación.

- **Campo: `fecha_alta`**
  - **¿Identifica directamente?:** No
  - **¿Puede contribuir a identificar?:** Sí
  - **¿Requiere protección?:** No
  - **Justificación:** Metadata operativa de control. No revela identidad por sí sola a menos que se cruce con eventos externos muy específicos.

### Respuestas
1. **¿Qué campos identifican directamente a una persona?**  
   `nombre`, `correo`, `telefono` y `rfc`.
2. **¿Qué campos no identifican por sí solos pero podrían contribuir a hacerlo?**  
   `edad`, `ciudad`, `codigo_postal` y `id` (cuasi-identificadores).
3. **¿Qué combinación de campos podría incrementar el riesgo de reidentificación?**  
   La combinación de `edad` + `codigo_postal` + `ciudad`.
4. **¿Todos los datos que deben protegerse son necesariamente datos personales sensibles desde el punto de vista jurídico?**  
   No. Los datos personales ordinarios (ej. teléfono, correo) no son legalmente "sensibles", pero operacionalmente requieren protección estricta.

---

## 2. Enmascaramiento (Masking)

Se creó el rol personalizado `soporte_eden_ruiz` sin capacidad de sesión directa. Mediante la vista `v_clientes_soporte`, se aplica enmascaramiento dinámico a los atributos sensibles (`correo`, `telefono` y `rfc`).

### Respuestas
1. **¿Qué información continúa existiendo en la tabla original?**  
   Los datos originales completos e inalterados.
2. **¿Qué información puede visualizar el usuario soporte?**  
   Los campos `id` y `nombre` limpios, junto a las versiones parcialmente ocultas con asteriscos.
3. **¿Por qué no es suficiente ocultar los datos únicamente en la aplicación?**  
   Porque si un atacante obtiene acceso a la base de datos directamente, la falta de controles en la BD expondría los datos reales.
4. **¿Qué ocurriría si soporte tuviera acceso directo a clientes?**  
   Violaría el principio de mínimo privilegio, incrementando el riesgo de fuga masiva de información.

---

## 3. Seudonimización (Pseudonymization)

- **`pii.mapa_cliente`**: Almacena la relación entre el `token` (UUID) y el `cliente_id` real.
- **`analitica.clientes`**: Almacena atributos analíticos asociados únicamente al `cliente_token`.
- **Separación de roles**: El rol `analista_eden_ruiz` tiene acceso únicamente al esquema `analitica`.

### Respuestas
1. **¿Qué ocurriría si analista pudiera consultar también `pii.mapa_cliente`?**  
   Se perdería la seudonimización de inmediato al poder reidentificar a los clientes mediante un JOIN.
2. **¿Qué principio de seguridad se está aplicando al separar ambos accesos?**  
   Separación de funciones (*Separation of Duties*) y Mínimo privilegio.
3. **¿Por qué la seudonimización no equivale a anonimización?**  
   Porque sigue existiendo una tabla de correspondencia protegida que permite revertir el proceso.
4. **¿Qué información permite volver a relacionar el token con una persona?**  
   La tabla `pii.mapa_cliente` cruzada con `public.clientes`.

---

## 4. Anonimización y Análisis del Riesgo

Se utilizaron técnicas de Generalización y Agregación combinadas con la supresión de grupos pequeños (`HAVING COUNT(*) >= 5`).

### Respuestas
1. **¿Qué identificadores directos fueron eliminados?**  
   `nombre`, `correo`, `telefono` y `rfc`.
2. **¿Qué cuasi-identificadores permanecen?**  
   Rango de edad y región postal.
3. **¿Qué combinaciones de atributos podrían reducir el anonimato?**  
   Rangos de edad muy estrechos cruzados con zonas postales reducidas.
4. **¿Qué sucede cuando un grupo contiene pocos registros?**  
   Aumenta el riesgo de reidentificación por inferencia.
5. **¿Qué atributos deberían generalizarse?**  
   La edad (rangos amplios) y el código postal (macro-zonas).
6. **¿Qué información debería suprimirse?**  
   Grupos por debajo del umbral mínimo $k$.
7. **¿Es correcto afirmar que el conjunto de datos es "100 % anónimo"? ¿Por qué?**  
   No. Siempre existe un riesgo residual al cruzar información agregada con fuentes externas.

---

## 5. Retención de Datos

- **Criterio:** Registros con antigüedad mayor a 5 años desde `fecha_alta`.
- **Justificación:** Principio de minimización de datos y cumplimiento operativo/legal.
- **Controles pre-eliminación:** Respaldo cifrado previo, autorización formal por el DPO/DBA y registro en bitácora inmutable.

---

## 6. Conclusiones y Preguntas de Reflexión

- **Para soporte:** Enmascaramiento Dinámico (Vistas).
- **Para analítica:** Seudonimización con separación de funciones.
- **Para publicar estadísticas:** Anonimización Irreversible (Generalización + Agregación).
- **¿Por qué ninguna técnica sustituye al control de acceso?**  
  Porque las técnicas de transformación alteran la presentación del dato, pero sin un control de acceso estricto (`GRANT`/`REVOKE`), un usuario no autorizado podría saltarse la vista y consultar las tablas subyacentes.