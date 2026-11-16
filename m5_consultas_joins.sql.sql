USE Ventas_Tech_DB;
 GO

-- =====================================================
 -- Consulta 1: Vista base del proyecto (INNER JOIN)
 -- Propósito: generar una vista enriquecida para análisis
 -- =====================================================

SELECT
 v.fecha_venta,
 c.id_cliente,
 c.nombre AS cliente,
 p.nombre_producto,
 cat.nombre_categoria,
 v.cantidad,
 v.precio_unitario,
 (v.cantidad * v.precio_unitario) AS total_venta
 FROM ventas v
 INNER JOIN clientes c
 ON v.id_cliente = c.id_cliente
 INNER JOIN productos p
 ON v.id_producto = p.id_producto
 INNER JOIN categorias cat
 ON p.id_categoria = cat.id_categoria;

-- Hallazgo:
 -- Las ventas pueden analizarse con información descriptiva
 -- de clientes, productos y categorías en una única consulta.

-- =====================================================
 -- Consulta 2: Clientes sin ventas (LEFT JOIN)
 -- Propósito: detectar clientes registrados que nunca compraron
 -- =====================================================

SELECT
 c.nombre,
 c.email,
 c.fecha_registro
 FROM clientes c
 LEFT JOIN ventas v
 ON c.id_cliente = v.id_cliente
 WHERE v.id_cliente IS NULL;

-- Hallazgo:
 -- Con los datos actuales no aparecen clientes sin ventas.
 -- CRM no tiene registros pendientes de seguimiento.

-- =====================================================
 -- Consulta 3: Productos sin ventas (LEFT JOIN)
 -- Propósito: detectar productos sin movimiento comercial
 -- =====================================================

SELECT
 p.nombre_producto,
 cat.nombre_categoria,
 p.precio
 FROM productos p
 LEFT JOIN ventas v
 ON p.id_producto = v.id_producto
 INNER JOIN categorias cat
 ON p.id_categoria = cat.id_categoria
 WHERE v.id_producto IS NULL;

-- Hallazgo:
 -- Con los datos cargados todos los productos registran ventas.
 -- El área de producto no tiene artículos sin movimiento.

-- =====================================================
 -- Consulta 4: Consolidado por canal (UNION ALL)
 -- Propósito: comparar ventas entre dos grupos
 -- =====================================================

SELECT
 canal,
 SUM(total) AS total_canal
 FROM
 (
 SELECT
 fecha_venta,
 cantidad * precio_unitario AS total,
 'Online' AS canal
 FROM ventas
 WHERE id_cliente <= 3

 UNION ALL

 SELECT
 fecha_venta,
 cantidad * precio_unitario AS total,
 'Presencial' AS canal
 FROM ventas
 WHERE id_cliente > 3

) AS consolidado
 GROUP BY canal;

-- Hallazgo:
 -- El consolidado permite comparar la facturación
 -- entre ambos canales definidos para el análisis.