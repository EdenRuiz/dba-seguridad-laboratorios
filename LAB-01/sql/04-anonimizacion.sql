-- 1. Generalización por Rango de Edad
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,
    COUNT(*) AS total
FROM clientes
GROUP BY 1;

-- 2. Generalización por Región Postal
SELECT
    LEFT(codigo_postal, 2) AS region,
    COUNT(*) AS total
FROM clientes
GROUP BY 1;

-- 3. Combinación de atributos y supresión de grupos pequeños (k = 5)
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,
    LEFT(codigo_postal, 2) AS region,
    COUNT(*) AS total
FROM clientes
GROUP BY 1, 2
HAVING COUNT(*) >= 5;

-- 4. RETO DE ANONIMIZACIÓN (Reducción mayor del riesgo de reidentificación)
SELECT
    CASE
        WHEN edad < 40 THEN 'Menor de 40'
        ELSE '40 o más'
    END AS grupo_edad,
    CONCAT(LEFT(codigo_postal, 1), 'XXXX') AS zona_macro,
    COUNT(*) AS total_registros
FROM clientes
GROUP BY 1, 2;