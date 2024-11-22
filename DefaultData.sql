-- DEFAULT DATA --
WITH att_id AS (
    INSERT INTO attributes (attribute_name)
    VALUES ('Color'), ('Size')
    RETURNING *
)
INSERT INTO attribute_values (attribute_id, attribute_value, color)
VALUES
  (( SELECT id FROM att_id WHERE attribute_name = 'Color'), 'Black', '#000'),
  (( SELECT id FROM att_id WHERE attribute_name = 'Color'), 'White', '#FFF'),
  (( SELECT id FROM att_id WHERE attribute_name = 'Color'), 'Red', '#FF0000'),
  (( SELECT id FROM att_id WHERE attribute_name = 'Color'), 'Blue', '#0000FF'),
  (( SELECT id FROM att_id WHERE attribute_name = 'Color'), 'Green', '#008000'),
  (( SELECT id FROM att_id WHERE attribute_name = 'Color'), 'Yellow', '#FFFF00'),
  (( SELECT id FROM att_id WHERE attribute_name = 'Size'), 'XS', null),
  (( SELECT id FROM att_id WHERE attribute_name = 'Size'), 'S', null),
  (( SELECT id FROM att_id WHERE attribute_name = 'Size'), 'M', null),
  (( SELECT id FROM att_id WHERE attribute_name = 'Size'),'L', null),
  (( SELECT id FROM att_id WHERE attribute_name = 'Size'),'XL', null),
(( SELECT id FROM att_id WHERE attribute_name = 'Size'),'XXL', null);


INSERT INTO order_statuses (status_name, color, privacy) VALUES
  ('Delivered', '#5ae510','public'),
  ('Paid', '#4caf50','public'),
  ('Confirmed', '#00d4cb','public'),
  ('Processing', '#ab5ae9', 'public'),
  ('Pending', '#ffe224', 'public'),
  ('Shipped', '#71f9f7', 'public'),
  ('Cancelled', '#FD9F3D', 'public');


INSERT INTO roles (id, role_name, privileges) VALUES
  (1, 'Store Administrator', ARRAY ['super_admin_privilege', 'admin_read_privilege', 'admin_create_privilege', 'admin_update_privilege', 'admin_delete_privilege', 'staff_read_privilege', 'staff_create_privilege', 'staff_update_privilege', 'staff_delete_privilege']),
  (2, 'Sales Manager', ARRAY ['admin_read_privilege', 'admin_create_privilege', 'admin_update_privilege', 'admin_delete_privilege', 'staff_read_privilege', 'staff_create_privilege', 'staff_update_privilege', 'staff_delete_privilege']),
  (3, 'Sales Staff', ARRAY ['staff_read_privilege', 'staff_create_privilege', 'staff_update_privilege', 'staff_delete_privilege']),
  (4, 'Guest', ARRAY ['staff_read_privilege']),
  (5, 'Investor', ARRAY ['admin_read_privilege', 'staff_read_privilege']);

INSERT INTO tags (tag_name, icon) VALUES
  ( 'Tools', 'Tools'),
  ( 'Electronics', 'Electronics'),
  ( 'Beauty Health', 'Beauty&Health'),
  ( 'Shirts', 'Clothes'),
  ( 'Accessories', 'Accessories');


INSERT INTO countries (id, iso, upper_name, name, iso3, num_code, phone_code) VALUES
(1, 'CN', 'CHINA', 'China', 'CHN', 156, 86),
(2, 'IN', 'INDIA', 'India', 'IND', 356, 91),
(3, 'US', 'UNITED STATES', 'United States', 'USA', 840, 1),
(4, 'ID', 'INDONESIA', 'Indonesia', 'IDN', 360, 62),
(5, 'NO', 'NORWAY', 'Norway', 'NOR', 578, 47),
(6, 'BR', 'BRAZIL', 'Brazil', 'BRA', 76, 55),
(7, 'SG', 'SINGAPORE', 'Singapore', 'SGP', 702, 65),
(8, 'GB', 'UNITED KINGDOM', 'United Kingdom', 'GBR', 826, 44),
(9, 'UA', 'UKRAINE', 'Ukraine', 'UKR', 804, 380),
(10, 'MX', 'MEXICO', 'Mexico', 'MEX', 484, 52);


-- Configuration --
-- ALTER SYSTEM SET max_connections = '10';
-- ALTER SYSTEM SET shared_buffers = '64MB';
-- ALTER SYSTEM SET effective_cache_size = '192MB';
-- ALTER SYSTEM SET maintenance_work_mem = '16MB';
-- ALTER SYSTEM SET checkpoint_completion_target = '0.9';
-- ALTER SYSTEM SET wal_buffers = '2MB';
-- ALTER SYSTEM SET default_statistics_target = '5';
-- ALTER SYSTEM SET random_page_cost = '1.1';
-- ALTER SYSTEM SET effective_io_concurrency = '10';
-- ALTER SYSTEM SET work_mem = '1310kB';
-- ALTER SYSTEM SET min_wal_size = '1GB';
-- ALTER SYSTEM SET max_wal_size = '4GB';