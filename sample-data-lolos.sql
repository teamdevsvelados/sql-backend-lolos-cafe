-- ============================================================
-- Sample data inserts - Lolo's Cafe
-- Compatible with script-lolos.sql (MySQL 8+)
-- ============================================================

-- Note:
-- 1) INSERT IGNORE / ON DUPLICATE KEY are used so the script can be re-run safely.
-- 2) Bridge tables (user_role, role_permission) resolve IDs by name,
--    to avoid depending on fixed IDs.

-- 1. Roles
INSERT IGNORE INTO roles (name_of) VALUES
('ADMINISTRADOR'),
('CLIENTE');

-- 2. Permissions
INSERT IGNORE INTO permissions (name_of) VALUES
('GESTION_USUARIOS'),
('GESTION_PRODUCTOS'),
('CREAR_ORDEN'),
('ACTUALIZAR_ORDEN'),
('VER_REPORTES');

-- 3. Role-permission mapping (role_permission)
-- IDs are resolved by name to avoid relying on specific numeric IDs.
INSERT IGNORE INTO role_permission (role_id, permission_id)
SELECT r.id, p.id
FROM (
	SELECT 'ADMINISTRADOR' AS role_name, 'GESTION_USUARIOS' AS permission_name
	UNION ALL SELECT 'ADMINISTRADOR', 'GESTION_PRODUCTOS'
	UNION ALL SELECT 'ADMINISTRADOR', 'CREAR_ORDEN'
	UNION ALL SELECT 'ADMINISTRADOR', 'ACTUALIZAR_ORDEN'
	UNION ALL SELECT 'ADMINISTRADOR', 'VER_REPORTES'
	UNION ALL SELECT 'CLIENTE', 'CREAR_ORDEN'
	UNION ALL SELECT 'CLIENTE', 'ACTUALIZAR_ORDEN'
) x
JOIN roles r ON r.name_of = x.role_name
JOIN permissions p ON p.name_of = x.permission_name;

-- 4. Users
-- If the email already exists, basic fields are updated and no duplicate user is inserted.
INSERT INTO users (name_of, email, password_hash, visits, available, date_creation) VALUES
('Administrador Lolo', 'admin@lolos.com', '$2y$ha325b3223aa28ash1', 0, 1, NOW()),
('Dafne Hernandez', 'hernandezdaf@gmail.com', '$2y$hasada1245da1dh2', 0, 1, NOW()),
('Sandra Borboa', 'borboasandra@gmail.com', '$2y$ha53a2fa42adf6ash3', 0, 1, NOW()),
('Misael Valencia', 'valeniamisa@gmail.com', '$2y$a3a23ba35achash4', 0, 1, NOW()),
('Antonio Amaro', 'amaroantonio@gmail.com', '$2y$hashcacaeb35365', 0, 1, NOW())
ON DUPLICATE KEY UPDATE
	name_of = VALUES(name_of),
	password_hash = VALUES(password_hash),
	available = VALUES(available);

-- 5. User-role mapping (user_role)
INSERT IGNORE INTO user_role (user_id, role_id)
SELECT u.id, r.id
FROM (
	SELECT 'admin@lolos.com' AS email, 'ADMINISTRADOR' AS role_name
	UNION ALL SELECT 'hernandezdaf@gmail.com', 'CLIENTE'
	UNION ALL SELECT 'borboasandra@gmail.com', 'CLIENTE'
	UNION ALL SELECT 'valeniamisa@gmail.com', 'CLIENTE'
	UNION ALL SELECT 'amaroantonio@gmail.com', 'CLIENTE'
) x
JOIN users u ON u.email = x.email
JOIN roles r ON r.name_of = x.role_name;

-- 6. Categories
INSERT IGNORE INTO categories (name_of) VALUES
('Con Cafe'),
('Sin Cafe'),
('Sodas'),
('Tisanas'),
('Postres');

-- 7. Sizes
-- The sizes table does not include volumen_oz in the current schema.
INSERT IGNORE INTO sizes (name_of) VALUES
('Chico'),
('Mediano'),
('Grande'),
('Frappe Mediano'),
('Frappe Grande');

-- 8. Products
-- Rows are inserted only if a product with the same name does not already exist.
INSERT INTO products (
	id_category, name_of, description, type, has_coffee,
	require_size, allow_temperature, allow_milk, allow_extra,
	base_price, slice_price, available, date_creation
)
SELECT c.id, x.name_of, x.description, x.type, x.has_coffee,
			 x.require_size, x.allow_temperature, x.allow_milk, x.allow_extra,
			 x.base_price, x.slice_price, x.available, NOW()
FROM (
	SELECT 'Con Cafe' AS category_name, 'Espresso' AS name_of, 'Cafe Espresso tradicional' AS description, 'BEBIDA' AS type,
				 1 AS has_coffee, 1 AS require_size, 0 AS allow_temperature, 0 AS allow_milk, 0 AS allow_extra,
				 NULL AS base_price, NULL AS slice_price, 1 AS available
	UNION ALL SELECT 'Con Cafe', 'Americano', 'Cafe Americano clasico', 'BEBIDA', 1, 1, 0, 0, 0, NULL, NULL, 1
	UNION ALL SELECT 'Con Cafe', 'Americano Limon', 'Americano con toque de limon', 'BEBIDA', 1, 1, 0, 0, 0, NULL, NULL, 1
	UNION ALL SELECT 'Con Cafe', 'Latte Regular', 'Cafe Latte regular', 'BEBIDA', 1, 1, 1, 1, 1, NULL, NULL, 1
	UNION ALL SELECT 'Con Cafe', 'Moka', 'Moka con chocolate', 'BEBIDA', 1, 1, 1, 1, 1, NULL, NULL, 1
	UNION ALL SELECT 'Sin Cafe', 'Taro', 'Bebida Taro sin cafe', 'BEBIDA', 0, 1, 1, 1, 0, NULL, NULL, 1
	UNION ALL SELECT 'Sin Cafe', 'Matcha', 'Matcha latte frio o caliente', 'BEBIDA', 0, 1, 1, 1, 0, NULL, NULL, 1
	UNION ALL SELECT 'Sin Cafe', 'Chai Latte', 'Chai latte clasico', 'BEBIDA', 0, 1, 1, 1, 0, NULL, NULL, 1
	UNION ALL SELECT 'Sodas', 'Soda Fresa', 'Soda sabor fresa', 'BEBIDA', 0, 0, 0, 0, 0, NULL, NULL, 1
	UNION ALL SELECT 'Sodas', 'Soda Kiwi', 'Soda sabor kiwi', 'BEBIDA', 0, 0, 0, 0, 0, NULL, NULL, 1
	UNION ALL SELECT 'Sodas', 'Soda Lavanda', 'Soda sabor lavanda', 'BEBIDA', 0, 0, 0, 0, 0, NULL, NULL, 1
) x
JOIN categories c ON c.name_of = x.category_name
LEFT JOIN products p ON p.name_of = x.name_of
WHERE p.id IS NULL;

-- 9. Offers
-- Duplicates are avoided by checking offer name.
INSERT INTO offers (name_of, description_of, discount_type, value_of, start_date, end_date)
SELECT x.name_of, x.description_of, x.discount_type, x.value_of, x.start_date, x.end_date
FROM (
	SELECT 'Descuento Bienvenida' AS name_of, '10% en tu primera compra' AS description_of, 'PORCENTAJE' AS discount_type,
				 10.00 AS value_of, NULL AS start_date, NULL AS end_date
	UNION ALL SELECT 'Happy Hour', '$1 de descuento', 'MONTO', 1.00, NULL, NULL
	UNION ALL SELECT 'Promo Cafe', '5% en bebidas', 'PORCENTAJE', 5.00, NULL, NULL
	UNION ALL SELECT 'Postre Gratis', '$2 de descuento', 'MONTO', 2.00, NULL, NULL
	UNION ALL SELECT 'Fin de Semana', '15% off', 'PORCENTAJE', 15.00, NULL, NULL
) x
LEFT JOIN offers o ON o.name_of = x.name_of
WHERE o.id IS NULL;

-- Note:
-- If you also want to populate product_size_price, options, option_product, or orders,
-- idempotent blocks can be added using the same approach.