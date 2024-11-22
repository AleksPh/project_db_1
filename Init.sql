CREATE TABLE IF NOT EXISTS roles (
  id SERIAL NOT NULL,
  role_name VARCHAR(255) NOT NULL,
  privileges TEXT [],
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS staff_accounts (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  role_id INTEGER REFERENCES roles(id) ON DELETE SET NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  phone_number VARCHAR(100) DEFAULT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  active BOOLEAN DEFAULT TRUE,
  placeholder TEXT DEFAULT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by UUID REFERENCES staff_accounts(id),
  updated_by UUID REFERENCES staff_accounts(id),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS categories (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  parent_id UUID REFERENCES categories (id) ON DELETE SET NULL,
  category_name VARCHAR(255) NOT NULL UNIQUE,
  category_description TEXT,
  icon TEXT,
  placeholder TEXT,
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by UUID REFERENCES staff_accounts(id),
  updated_by UUID REFERENCES staff_accounts(id),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS products (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  slug TEXT NOT NULL UNIQUE,
  product_name VARCHAR(255) NOT NULL,
  price NUMERIC NOT NULL DEFAULT 0,
  quantity INTEGER NOT NULL DEFAULT 0,
  short_description VARCHAR(165) NOT NULL,
  product_description TEXT NOT NULL,
  product_type VARCHAR(64),
  published BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by UUID REFERENCES staff_accounts(id),
  updated_by UUID REFERENCES staff_accounts(id),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS product_categories (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  product_id UUID REFERENCES products(id) NOT NULL,
  category_id UUID REFERENCES categories(id) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS product_shipping_info (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  product_id UUID REFERENCES products(id) ON DELETE SET NULL,
  weight NUMERIC NOT NULL DEFAULT 0,
  weight_unit VARCHAR(10) CHECK (weight_unit IN ('g', 'kg')),
  volume NUMERIC NOT NULL DEFAULT 0,
  volume_unit VARCHAR(10) CHECK (volume_unit IN ('l', 'ml')),
  dimension_width NUMERIC NOT NULL DEFAULT 0,
  dimension_height NUMERIC NOT NULL DEFAULT 0,
  dimension_depth NUMERIC NOT NULL DEFAULT 0,
  dimension_unit VARCHAR(10) CHECK (dimension_unit IN ('l', 'ml')),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS gallery (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  product_id UUID REFERENCES products(id),
  image TEXT NOT NULL,
  placeholder TEXT NOT NULL,
  is_thumbnail BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id)
) PARTITION BY HASH(id);

CREATE TABLE IF NOT EXISTS attributes (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  attribute_name VARCHAR(255) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by UUID REFERENCES staff_accounts(id),
  updated_by UUID REFERENCES staff_accounts(id),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS attribute_values (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  attribute_id UUID REFERENCES attributes(id) NOT NULL,
  attribute_value VARCHAR(255) NOT NULL,
  color VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS product_attributes (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  product_id UUID REFERENCES products(id) NOT NULL,
  attribute_id UUID REFERENCES attributes(id) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS product_attribute_values (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  product_attribute_id UUID REFERENCES product_attributes(id) NOT NULL,
  attribute_value_id UUID REFERENCES attribute_values(id) NOT NULL,
  PRIMARY KEY (id)
);



CREATE TABLE IF NOT EXISTS customers (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  active BOOLEAN DEFAULT TRUE,
  registered_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS customer_addresses (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  customer_id UUID REFERENCES customers(id),
  address_line1 TEXT NOT NULL,
  address_line2 TEXT,
  phone_number VARCHAR(255) NOT NULL,
  dial_code VARCHAR(100) NOT NULL,
  country VARCHAR(255) NOT NULL,
  postal_code VARCHAR(255) NOT NULL,
  city VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS coupons (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  code VARCHAR(50) NOT NULL UNIQUE,
  discount_value NUMERIC,
  discount_type VARCHAR(50) NOT NULL,
  times_used NUMERIC NOT NULL DEFAULT 0,
  max_usage NUMERIC DEFAULT null,
  order_amount_limit NUMERIC DEFAULT null,
  coupon_start_date TIMESTAMPTZ,
  coupon_end_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by UUID REFERENCES staff_accounts(id),
  updated_by UUID REFERENCES staff_accounts(id),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS product_coupons (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  product_id UUID REFERENCES products(id) NOT NULL,
  coupon_id UUID REFERENCES coupons(id) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS countries (
  id INT NOT NULL DEFAULT NEXTVAL ('countries_seq'),
  iso CHAR(2) NOT NULL,
  name VARCHAR(80) NOT NULL,
  upper_name VARCHAR(80) NOT NULL,
  iso3 CHAR(3) DEFAULT NULL,
  num_code SMALLINT DEFAULT NULL,
  phone_code INT NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS shipping_zones (
  id SERIAL NOT NULL,
  name VARCHAR(255) NOT NULL,
  display_name VARCHAR(255) NOT NULL,
  active BOOLEAN DEFAULT FALSE,
  free_shipping BOOLEAN DEFAULT FALSE,
  rate_type VARCHAR(64) CHECK (rate_type IN ('price', 'weight')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by UUID REFERENCES staff_accounts(id),
  updated_by UUID REFERENCES staff_accounts(id),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS shipping_country_zones (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  shipping_zone_id INTEGER REFERENCES shipping_zones(id) NOT NULL,
  country_id INTEGER REFERENCES countries(id) NOT NULL,
  PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS order_statuses (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  status_name VARCHAR(255) NOT NULL,
  color VARCHAR(50) NOT NULL,
  privacy VARCHAR(50),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by UUID REFERENCES staff_accounts(id),
  updated_by UUID REFERENCES staff_accounts(id),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS orders (
  id VARCHAR(50) NOT NULL,
  coupon_id UUID REFERENCES coupons(id) ON DELETE SET NULL,
  customer_id UUID REFERENCES customers(id),
  order_status_id UUID REFERENCES order_statuses(id) ON DELETE SET NULL,
  order_approved_at TIMESTAMPTZ,
  order_delivered_carrier_date TIMESTAMPTZ,
  order_delivered_customer_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_by UUID REFERENCES staff_accounts(id),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS order_items (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  product_id UUID REFERENCES products(id),
  order_id VARCHAR(50) REFERENCES orders(id),
  price NUMERIC NOT NULL,
  quantity INTEGER NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS sells (
  id SERIAL NOT NULL,
  product_id UUID UNIQUE REFERENCES products(id),
  price NUMERIC NOT NULL,
  quantity INTEGER NOT NULL,
  PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS notifications (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  account_id UUID REFERENCES customers(id),
  title VARCHAR(100),
  content TEXT,
  seen BOOLEAN,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  receive_time TIMESTAMPTZ,
  notification_expiry_date DATE,
  PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS tags (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  tag_name VARCHAR(255) NOT NULL,
  icon TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by UUID REFERENCES staff_accounts(id),
  updated_by UUID REFERENCES staff_accounts(id),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS product_tags (
  tag_id UUID REFERENCES tags(id) NOT NULL,
  product_id UUID REFERENCES products(id) NOT NULL,
  PRIMARY KEY (tag_id, product_id)
);

CREATE TABLE IF NOT EXISTS suppliers (
  id UUID NOT NULL DEFAULT uuid_generate_v4(),
  supplier_name VARCHAR(255) NOT NULL,
  company VARCHAR(255),
  phone_number VARCHAR(255),
  address_line1 TEXT NOT NULL,
  address_line2 TEXT,
  country_id INTEGER REFERENCES countries(id) NOT NULL,
  city VARCHAR(255),
  note TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by UUID REFERENCES staff_accounts(id),
  updated_by UUID REFERENCES staff_accounts(id),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS product_suppliers (
  product_id UUID REFERENCES products(id) NOT NULL,
  supplier_id UUID REFERENCES suppliers(id) NOT NULL,
  PRIMARY KEY (product_id, supplier_id)
);