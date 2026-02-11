SELECT * FROM roles;
INSERT INTO roles (name_of) VALUES
('ADMINISTRADOR'),
('CLIENTE');

SELECT * FROM permissions;

INSERT INTO permissions (name_of) VALUES
('GESTION_USUARIOS'),
('GESTION_PRODUCTOS'),
('CREAR_ORDEN'),
('ACTUALIZAR_ORDEN'),
('VER_REPORTES');

SELECT * FROM rol_permission;

INSERT INTO rol_permission (rol_id, permission_id) VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),
(2,3),(2,4);

SELECT * FROM users;

INSERT INTO users (name_of, email, password_hash, rol_id) VALUES
('Administrador Lolo','admin@lolos.com','$2y$ha325b3223aa28ash1',1),
('Dafne Hernández','hernandezdaf@gmail.com','$2y$hasada1245da1dh2',2),
('Sandra Borboa','borboasandra@gmail.com','$2y$ha53a2fa42adf6ash3',2),
('Misael Valencia','valeniamisa@gmail.com','$2y$a3a23ba35achash4',2),
('Antonio Amaro','amaroantonio@gmail.com','$2y$hashcacaeb35365',2);

SELECT * FROM offers;

INSERT INTO offers (name_of, description_of, discount_type, value_of) VALUES
('Descuento Bienvenida','10% en tu primera compra','PORCENTAJE',10),
('Happy Hour','$1 de descuento','MONTO',1),
('Promo Café','5% en bebidas','PORCENTAJE',5),
('Postre Gratis','$2 de descuento','MONTO',2),
('Fin de Semana','15% off','PORCENTAJE',15);

SELECT * FROM sizes;

INSERT INTO sizes (name_of, volumen_oz) VALUES
('Chico',12),
('Mediano',16),
('Grande',20),
('Frappé Mediano',16),
('Frappé Grande',20);

SELECT * FROM categories;
INSERT INTO categories (name_of) VALUES
('Con Café'),
('Sin Café'),
('Sodas'),
('Tisanas'),
('Postres');

SELECT * FROM products;

INSERT INTO products (id_category, name_of, description, type, have_coffe) VALUES
(1,'Espresso','Café Espresso tradicional','BEBIDA',1),
(1,'Americano','Café Americano clásico','BEBIDA',1),
(1,'Americano Limón','Americano con toque de limón','BEBIDA',1),
(1,'Latte Regular','Café Latte regular','BEBIDA',1),
(1,'Moka','Moka con chocolate','BEBIDA',1),
(2,'Taro','Bebida Taro sin café','BEBIDA',0),
(2,'Matcha','Matcha latte frío o caliente','BEBIDA',0),
(2,'Chai Latte','Chai latte clásico','BEBIDA',0),
(3,'Soda Fresa','Soda sabor fresa','BEBIDA',0),
(3,'Soda Kiwi','Soda sabor kiwi','BEBIDA',0),
(3,'Soda Lavanda','Soda sabor lavanda','BEBIDA',0);

SELECT * FROM offers;

INSERT INTO offers (name_of, description_of, discount_type, value_of) VALUES
('Descuento Bienvenida','10% en tu primera compra','PORCENTAJE',10),
('Happy Hour','$1 de descuento','MONTO',1),
('Promo Café','5% en bebidas','PORCENTAJE',5),
('Postre Gratis','$2 de descuento','MONTO',2),
('Fin de Semana','15% off','PORCENTAJE',15);