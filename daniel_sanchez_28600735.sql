use tiendaderopa;
CREATE TABLE clientes (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    direccion VARCHAR(100),
    correo_electronico VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE productos (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    precio DECIMAL(10, 2),
    categoria VARCHAR(50),
    stock INT
);

CREATE TABLE pedidos (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_cliente INT,
    fecha DATE,
    estado VARCHAR(50),
    total DECIMAL(10, 2),
    FOREIGN KEY (ID_cliente) REFERENCES clientes(ID)
);

CREATE TABLE ventas (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_pedido INT,
    ID_producto INT,
    cantidad INT,
    precio_venta DECIMAL(10, 2),
    FOREIGN KEY (ID_pedido) REFERENCES pedidos(ID),
    FOREIGN KEY (ID_producto) REFERENCES productos(ID)
);

INSERT INTO clientes (nombre, apellido, direccion, correo_electronico, telefono)
VALUES ('Juan', 'Pérez', 'Calle 123, Ciudad', 'juan@example.com', '12345678'),
       ('María', 'Gómez', 'Av. Principal, Pueblo', 'maria@example.com', '29876543'),
       ('Ana', 'López', 'Av. Libertad 456, Ciudad', 'ana@example.com', '14561237'),
       ('Carlos', 'Martínez', 'Calle 789, Pueblo', 'carlos@example.com', '13692584'),
       ('Sofía', 'Rodríguez', 'Calle 321, Villa', 'sofia@example.com', '18521473'),
       ('Pedro', 'González', 'Av. Principal 789, Pueblo', 'pedro@example.com', '14725836');
       
INSERT INTO productos (nombre, descripcion, precio, categoria, stock)
VALUES ('Camiseta blanca', 'Camiseta básica de algodón', 15.99, 'Camisetas', 100),
       ('Pantalón vaquero', 'Pantalón estilo jeans', 29.99, 'Pantalones', 50),
       ('Vestido floral', 'Vestido estampado de flores', 39.99, 'Vestidos', 30),
       ('Chaqueta de cuero', 'Chaqueta estilo motera', 79.99, 'Chaquetas', 20),
       ('Pantalón deportivo', 'Pantalón cómodo para hacer ejercicio', 24.99, 'Pantalones', 40),
       ('Bufanda de lana', 'Bufanda suave y abrigada', 14.99, 'Accesorios', 50);
       
INSERT INTO pedidos (ID_cliente, fecha, estado, total)
VALUES (1, '2024-05-13', 'En proceso', 45.98),
       (2, '2024-05-14', 'Entregado', 29.99),
       (3, '2024-05-12', 'Entregado', 64.97),
       (4, '2024-05-14', 'En proceso', 119.96),
       (1, '2024-05-15', 'Entregado', 39.99);
       
INSERT INTO ventas (ID_pedido, ID_producto, cantidad, precio_venta)
VALUES (1, 1, 2, 31.98),
       (2, 2, 1, 29.99),
       (3, 1, 1, 39.99),
       (4, 2, 1, 79.99),
       (4, 3, 2, 49.98),
       (4, 4, 3, 44.97),
       (5, 1, 1, 19.99),
       (5, 4, 2, 29.98);

-- Consulta 1:
SELECT nombre, apellido, direccion, correo_electronico
FROM clientes
WHERE ID IN (
    SELECT DISTINCT ID_cliente
    FROM pedidos
    WHERE fecha >= CURDATE() - INTERVAL 30 DAY
);

-- Consulta 2:
SELECT p.nombre, SUM(v.cantidad) AS cantidad_vendida, SUM(v.cantidad * v.precio_venta) AS total_vendido
FROM ventas v
JOIN productos p ON v.ID_producto = p.ID
JOIN pedidos pd ON v.ID_pedido = pd.ID
WHERE pd.fecha >= CURDATE() - INTERVAL 30 DAY
GROUP BY p.ID
ORDER BY cantidad_vendida DESC;

-- Consulta 3:
SELECT c.nombre, c.apellido, COUNT(p.ID) AS cantidad_pedidos
FROM clientes c
JOIN pedidos p ON c.ID = p.ID_cliente
WHERE p.fecha >= CURDATE() - INTERVAL 1 YEAR
GROUP BY c.ID
ORDER BY cantidad_pedidos DESC;

-- Actualización 1:
UPDATE productos
SET precio = precio * 1.1
WHERE categoria = 'Camisetas';

-- Eliminación 2:
DELETE FROM pedidos
WHERE ID NOT IN (
    SELECT DISTINCT ID_pedido
    FROM ventas
);

-- Vista 1:
CREATE VIEW vista_clientes_pedidos AS
SELECT c.nombre, c.apellido, p.fecha, p.total
FROM clientes c
JOIN pedidos p ON c.ID = p.ID_cliente;




