USE Ventas_Tech_DB;
 GO

-- ============================================
 -- CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL
 -- ============================================

SELECT
 MONTH(fecha_venta) AS mes,
 SUM(cantidad * precio_unitario) AS total_facturado,
 COUNT(*) AS cantidad_pedidos,
 AVG(cantidad * precio_unitario) AS ticket_promedio
 FROM ventas
 GROUP BY MONTH(fecha_venta);

-- ============================================
 -- CONSULTA 2 - RANKING DE PRODUCTOS
 -- TOP 5 POR FACTURACION
 -- ============================================

SELECT TOP 5
 id_producto,
 SUM(cantidad) AS unidades_vendidas,
 SUM(cantidad * precio_unitario) AS total_facturado
 FROM ventas
 GROUP BY id_producto
 ORDER BY total_facturado DESC;

-- ============================================
 -- CONSULTA 3 - CLIENTES RECURRENTES
 -- ============================================

SELECT
 id_cliente,
 COUNT(*) AS cantidad_pedidos,
 SUM(cantidad * precio_unitario) AS total_gastado
 FROM ventas
 GROUP BY id_cliente
 HAVING COUNT(*) > 1;

-- ============================================
 -- CONSULTA 4 - PRODUCTOS POR ENCIMA O DEBAJO
 -- DEL PROMEDIO DE FACTURACION
 -- ============================================

WITH ventas_por_producto AS
 (
 SELECT
 id_producto,
 SUM(cantidad * precio_unitario) AS total_facturado
 FROM ventas
 GROUP BY id_producto
 ),
 promedio_productos AS
 (
 SELECT
 AVG(total_facturado) AS promedio_facturacion
 FROM ventas_por_producto
 )

SELECT
 vpp.id_producto,
 vpp.total_facturado,
 CASE
 WHEN vpp.total_facturado > pp.promedio_facturacion
 THEN 'Por encima'
 ELSE 'Por debajo'
 END AS comparacion_promedio
 FROM ventas_por_producto vpp
 CROSS JOIN promedio_productos pp
 ORDER BY vpp.total_facturado DESC;