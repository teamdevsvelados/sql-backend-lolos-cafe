-- ============================================================
-- Project: Lolo's Café
-- Database: lolosv2
-- Engine: MySQL 8+
-- Charset: utf8mb4
-- ============================================================

CREATE DATABASE IF NOT EXISTS lolosv2
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE lolosv2;

SET NAMES utf8mb4;
SET time_zone = '-06:00';

-- ============================================================
-- 1) Security: Roles / Permissions / Users
-- ============================================================

CREATE TABLE roles (
  id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name_of VARCHAR(30) NOT NULL UNIQUE,
  available TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE permissions (
  id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name_of VARCHAR(50) NOT NULL UNIQUE,
  available TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE role_permission (
  role_id TINYINT UNSIGNED NOT NULL,
  permission_id SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (role_id, permission_id),

  CONSTRAINT fk_rp_role
    FOREIGN KEY (role_id) REFERENCES roles(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_rp_permission
    FOREIGN KEY (permission_id) REFERENCES permissions(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name_of VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE,
  phone VARCHAR(20),
  password_hash VARCHAR(255),
  visits INT UNSIGNED NOT NULL DEFAULT 0,
  available TINYINT(1) NOT NULL DEFAULT 1,
  date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE user_role (
  user_id INT UNSIGNED NOT NULL,
  role_id TINYINT UNSIGNED NOT NULL,

  PRIMARY KEY (user_id, role_id),

  CONSTRAINT fk_ur_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_ur_role
    FOREIGN KEY (role_id) REFERENCES roles(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;


-- ============================================================
-- 2) Catalog / Menu
-- ============================================================

CREATE TABLE categories (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name_of VARCHAR(50) NOT NULL UNIQUE,
  available TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE products (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_category INT UNSIGNED NOT NULL,

  name_of VARCHAR(100) NOT NULL,
  description VARCHAR(255),

  type ENUM('BEBIDA','POSTRE') NOT NULL,

  has_coffee TINYINT(1) NOT NULL DEFAULT 0,
  require_grain TINYINT(1) NOT NULL DEFAULT 0,

  require_size TINYINT(1) NOT NULL DEFAULT 1,
  allow_temperature TINYINT(1) NOT NULL DEFAULT 0,
  allow_milk TINYINT(1) NOT NULL DEFAULT 0,
  allow_extra TINYINT(1) NOT NULL DEFAULT 0,

  url_image VARCHAR(255),

  base_price DECIMAL(10,2),
  slice_price DECIMAL(10,2),

  available TINYINT(1) NOT NULL DEFAULT 1,
  date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_product_category
    FOREIGN KEY (id_category) REFERENCES categories(id),

  INDEX idx_product_type (type),
  INDEX idx_product_available (available),
  INDEX idx_product_category_available (id_category, available)
) ENGINE=InnoDB;


-- ============================================================
-- 3) Sizes and Prices
-- ============================================================

CREATE TABLE sizes (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name_of VARCHAR(20) NOT NULL UNIQUE,
  available TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE product_size_price (
  id_product INT UNSIGNED NOT NULL,
  id_size INT UNSIGNED NOT NULL,
  price DECIMAL(10,2) NOT NULL,

  PRIMARY KEY (id_product, id_size),

  CONSTRAINT fk_psp_product
    FOREIGN KEY (id_product) REFERENCES products(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_psp_size
    FOREIGN KEY (id_size) REFERENCES sizes(id)
) ENGINE=InnoDB;


-- ============================================================
-- 4) Options (temperature, milk, extras, grain)
-- ============================================================

CREATE TABLE options (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  type_of ENUM('TEMPERATURA','LECHE','EXTRA','GRANO') NOT NULL,
  name_of VARCHAR(50) NOT NULL,
  extra_price DECIMAL(10,2) NOT NULL DEFAULT 0,
  available TINYINT(1) NOT NULL DEFAULT 1,

  UNIQUE KEY uq_option_type_name (type_of, name_of),

  INDEX idx_option_type (type_of)
) ENGINE=InnoDB;

CREATE TABLE option_product (
  id_product INT UNSIGNED NOT NULL,
  id_option INT UNSIGNED NOT NULL,

  PRIMARY KEY (id_product, id_option),

  CONSTRAINT fk_op_product
    FOREIGN KEY (id_product) REFERENCES products(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_op_option
    FOREIGN KEY (id_option) REFERENCES options(id)
) ENGINE=InnoDB;


-- ============================================================
-- 5) Offers / Promotions
-- ============================================================

CREATE TABLE offers (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name_of VARCHAR(100) NOT NULL,
  description_of VARCHAR(255),

  discount_type ENUM('PORCENTAJE','MONTO') NOT NULL,

  value_of DECIMAL(10,2) NOT NULL,
  available TINYINT(1) NOT NULL DEFAULT 1,

  start_date DATE NULL,
  end_date DATE NULL
) ENGINE=InnoDB;

CREATE TABLE offer_product (
  id_product INT UNSIGNED NOT NULL,
  id_offer INT UNSIGNED NOT NULL,

  PRIMARY KEY (id_product, id_offer),

  CONSTRAINT fk_offer_product
    FOREIGN KEY (id_product) REFERENCES products(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_offer_offer
    FOREIGN KEY (id_offer) REFERENCES offers(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;


-- ============================================================
-- 6) Orders
-- ============================================================

CREATE TABLE orders (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

  id_user INT UNSIGNED NULL,

  customer_name VARCHAR(150),
  customer_phone VARCHAR(20),
  customer_address VARCHAR(255),
  payment_method VARCHAR(50),

  status_of ENUM('CREADO','EN_PROCESO','LISTO','ENTREGADO','CANCELADO')
    NOT NULL DEFAULT 'CREADO',

  general_notes VARCHAR(500),

  subtotal DECIMAL(10,2) NOT NULL DEFAULT 0,
  discount DECIMAL(10,2) NOT NULL DEFAULT 0,
  total DECIMAL(10,2) NOT NULL DEFAULT 0,

  available TINYINT(1) NOT NULL DEFAULT 1,
  date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_order_user
    FOREIGN KEY (id_user) REFERENCES users(id),

  INDEX idx_order_status (status_of),
  INDEX idx_order_date (date_creation)
) ENGINE=InnoDB;


-- ============================================================
-- 7) Order Items
-- ============================================================

CREATE TABLE order_items (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_order BIGINT UNSIGNED NOT NULL,
  id_product INT UNSIGNED NOT NULL,
  id_size INT UNSIGNED NULL,
  quantity INT UNSIGNED NOT NULL DEFAULT 1,
  item_notes VARCHAR(500),
  
  base_price DECIMAL(10,2) NOT NULL,
  total_extras DECIMAL(10,2) NOT NULL DEFAULT 0,
  total_line DECIMAL(10,2) NOT NULL,

  CONSTRAINT fk_item_order
    FOREIGN KEY (id_order) REFERENCES orders(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_item_product
    FOREIGN KEY (id_product) REFERENCES products(id),

  CONSTRAINT fk_item_size
    FOREIGN KEY (id_size) REFERENCES sizes(id),

  INDEX idx_order_items (id_order)
) ENGINE=InnoDB;


-- ============================================================
-- 8) Order Item Options
-- ============================================================

CREATE TABLE order_item_option (
  item_id BIGINT UNSIGNED NOT NULL,
  id_option INT UNSIGNED NOT NULL,
  applied_extra_price DECIMAL(10,2) NOT NULL DEFAULT 0,

  PRIMARY KEY (item_id, id_option),

  CONSTRAINT fk_oio_item
    FOREIGN KEY (item_id) REFERENCES order_items(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_oio_option
    FOREIGN KEY (id_option) REFERENCES options(id)
) ENGINE=InnoDB;


-- ============================================================
-- 9) Offer Applied to Order
-- ============================================================

CREATE TABLE offer_order (
  id_order BIGINT UNSIGNED NOT NULL,
  id_offer INT UNSIGNED NOT NULL,
  applied_discount DECIMAL(10,2) NOT NULL DEFAULT 0,

  PRIMARY KEY (id_order, id_offer),

  CONSTRAINT fk_offer_order
    FOREIGN KEY (id_order) REFERENCES orders(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_offer_order_offer
    FOREIGN KEY (id_offer) REFERENCES offers(id)
) ENGINE=InnoDB;