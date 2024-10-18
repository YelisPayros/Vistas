USE Norwind

--Ventas Totales por Período (Año y Mes)

CREATE VIEW VentasTotalesPorPeriodo AS
SELECT 
    YEAR(o.OrderDate) AS Año,
    MONTH(o.OrderDate) AS Mes,
    SUM(od.Quantity * od.UnitPrice) AS VentasTotales
FROM 
    Orders o
JOIN 
    [Order Details] od ON o.OrderID = od.OrderID
GROUP BY 
    YEAR(o.OrderDate), 
    MONTH(o.OrderDate);

SELECT * FROM VentasTotalesPorPeriodo




--Ventas por Categoría de Producto
CREATE VIEW VentasPorCategoria AS
SELECT 
    c.CategoryName AS NombreCategoria,
    SUM(od.Quantity * p.UnitPrice) AS VentasTotales
FROM 
    Products p
JOIN 
    [Order Details] od ON p.ProductID = od.ProductID
JOIN 
    Orders o ON od.OrderID = o.OrderID
JOIN 
    Categories c ON p.CategoryID = c.CategoryID
GROUP BY 
    c.CategoryName;

	
SELECT * FROM VentasPorCategoria


--Total de Ventas por Categoría

CREATE VIEW TotalVentasPorCategoria AS
SELECT 
    c.CategoryName AS NombreCategoria,
    COUNT(o.OrderID) AS TotalVentas
FROM 
    Products p
JOIN 
    [Order Details] od ON p.ProductID = od.ProductID
JOIN 
    Orders o ON od.OrderID = o.OrderID
JOIN 
    Categories c ON p.CategoryID = c.CategoryID
GROUP BY 
    c.CategoryName;

	
SELECT * FROM TotalVentasPorCategoria

--Ventas por Región/País

CREATE VIEW VentasPorRegionPais AS
SELECT 
    c.Country,
    SUM(od.Quantity * p.UnitPrice) AS VentasTotales
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    [Order Details] od ON o.OrderID = od.OrderID
JOIN 
    Products p ON od.ProductID = p.ProductID
GROUP BY 
    c.Country;

SELECT * FROM VentasPorRegionPais

--Número de Pedidos Procesados por Empleado
CREATE VIEW PedidosPorEmpleado AS
SELECT 
    e.FirstName + ' ' + e.LastName AS Empleado,
    COUNT(o.OrderID) AS NumeroDePedidos
FROM 
    Employees e
JOIN 
    Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY 
    e.FirstName, e.LastName;


SELECT * FROM PedidosPorEmpleado


--Productividad de Empleados (Ventas por Empleado)
CREATE VIEW ProductividadEmpleados AS
SELECT 
    e.FirstName + ' ' + e.LastName AS Empleado,
    SUM(od.Quantity * p.UnitPrice) AS VentasTotales
FROM 
    Employees e
JOIN 
    Orders o ON e.EmployeeID = o.EmployeeID
JOIN 
    [Order Details] od ON o.OrderID = od.OrderID
JOIN 
    Products p ON od.ProductID = p.ProductID
GROUP BY 
    e.FirstName, e.LastName;

SELECT * FROM ProductividadEmpleados


--Clientes Atendidos por Empleado

CREATE VIEW ClientesAtendidosPorEmpleado AS
SELECT 
    e.FirstName + ' ' + e.LastName AS Empleado,
    COUNT(DISTINCT o.CustomerID) AS ClientesAtendidos
FROM 
    Employees e
JOIN 
    Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY 
    e.FirstName, e.LastName;

SELECT * FROM ClientesAtendidosPorEmpleado

--Productos Más Vendidos
CREATE VIEW ProductosMasVendidos AS
SELECT TOP 10
    p.ProductName,
    SUM(od.Quantity) AS TotalVendidos
FROM 
    Products p
JOIN 
    [Order Details] od ON p.ProductID = od.ProductID
GROUP BY 
    p.ProductName
ORDER BY 
    SUM(od.Quantity) DESC;

	
SELECT * FROM ProductosMasVendidos

--Total Mas vendido por categoria
CREATE VIEW ProductosMasVendidosPorCategoria AS
WITH ProductosOrdenados AS (
    SELECT 
        c.CategoryName,
        p.ProductName,
        SUM(od.Quantity) AS TotalVendidos,
        ROW_NUMBER() OVER (PARTITION BY c.CategoryID ORDER BY SUM(od.Quantity) DESC) AS rn
    FROM 
        Categories c
    JOIN 
        Products p ON c.CategoryID = p.CategoryID
    JOIN 
        [Order Details] od ON p.ProductID = od.ProductID
    GROUP BY 
        c.CategoryName,
        p.ProductName,
        c.CategoryID
)
SELECT 
    CategoryName,
    ProductName,
    TotalVendidos
FROM 
    ProductosOrdenados
WHERE 
    rn = 1;

	
SELECT * FROM ProductosMasVendidosPorCategoria


--Total de Ventas por Transportista
CREATE VIEW TotalVentasPorTransportista AS
SELECT 
    sh.CompanyName AS ShipperName,
    SUM(od.Quantity * od.UnitPrice) AS TotalVentas
FROM 
    Shippers sh
JOIN 
    Orders o ON sh.ShipperID = o.ShipVia
JOIN 
    [Order Details] od ON o.OrderID = od.OrderID
GROUP BY 
    sh.CompanyName;

SELECT * FROM TotalVentasPorTransportista

--Número de Órdenes Enviadas por Transportista
CREATE VIEW OrdenesEnviadasPorTransportista AS
SELECT 
    s.CompanyName AS Transportista,
    COUNT(o.OrderID) AS NumeroDeOrdenes
FROM 
    Shippers s
JOIN 
    Orders o ON s.ShipperID = o.ShipVia
GROUP BY 
    s.CompanyName;

SELECT * FROM OrdenesEnviadasPorTransportista


--Total de Ventas por Cliente

CREATE VIEW TotalVentasPorCliente AS
SELECT 
    c.CompanyName AS Cliente,
    SUM(od.Quantity * od.UnitPrice) AS TotalVentas
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    [Order Details] od ON o.OrderID = od.OrderID
GROUP BY 
    c.CompanyName;

SELECT * FROM TotalVentasPorCliente


--Número de Órdenes por Cliente
CREATE VIEW NumeroOrdenesPorCliente AS
SELECT 
    c.CompanyName AS Cliente,
    COUNT(o.OrderID) AS NumeroDeOrdenes
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CompanyName;

	
SELECT * FROM NumeroOrdenesPorCliente