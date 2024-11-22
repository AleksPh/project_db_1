CREATE OR REPLACE FUNCTION update_at_timestamp()
RETURNS
    TRIGGER
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- TRIGGERS --
CREATE TRIGGER category_set_update BEFORE UPDATE ON categories FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp();
CREATE TRIGGER gallery_set_update BEFORE UPDATE ON gallery FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp();
CREATE TRIGGER attribute_set_update BEFORE UPDATE ON attributes FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp();
CREATE TRIGGER product_set_update BEFORE UPDATE ON products FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp();
CREATE TRIGGER staff_set_update BEFORE UPDATE ON staff_accounts FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp();
CREATE TRIGGER coupon_set_update BEFORE UPDATE ON coupons FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp();
CREATE TRIGGER customer_set_update BEFORE UPDATE ON customers FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp();
CREATE TRIGGER order_set_update BEFORE UPDATE ON orders FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp();
CREATE TRIGGER notification_set_update BEFORE UPDATE ON notifications FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp();
CREATE TRIGGER tag_set_update BEFORE UPDATE ON tags FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp();
CREATE TRIGGER order_status_set_update BEFORE UPDATE ON order_statuses FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp();
CREATE TRIGGER suppliers_set_update BEFORE UPDATE ON suppliers FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp();




-- INDEXES --                                                                                                                                                                         -- Declaration of a foreign key constraint does not automatically create an index on the referencing columns.
CREATE INDEX idx_product_publish ON products (published);
CREATE INDEX idx_customer_email ON customers (email);
CREATE INDEX idx_product_category ON product_categories (product_id, category_id);
CREATE INDEX idx_product_shipping_info_product_id ON product_shipping_info (product_id);
CREATE INDEX idx_image_gallery ON gallery (product_id, is_thumbnail);
CREATE INDEX idx_attribute_values ON attribute_values (attribute_id);
CREATE INDEX idx_product_attribute_values_product_attribute_id ON product_attribute_values (product_attribute_id);
CREATE INDEX idx_product_attribute_values_attribute_value_id ON product_attribute_values (attribute_value_id);
CREATE INDEX idx_product_attribute_fk ON product_attributes (product_id, attribute_id);
CREATE INDEX idx_code_coupons ON coupons (code);
CREATE INDEX idx_product_id_coupon_id_product_coupons ON product_coupons (product_id, coupon_id);
CREATE INDEX idx_shipping_zone_id_shipping_country_zones ON shipping_country_zones (shipping_zone_id);
CREATE INDEX idx_country_id_shipping_country_zones ON shipping_country_zones (country_id);
CREATE INDEX idx_order_customer_id ON orders (customer_id);
CREATE INDEX idx_product_id_order_item ON order_items (product_id);
CREATE INDEX idx_order_id_order_item ON order_items (order_id);
CREATE INDEX idx_product_supplier ON product_suppliers (product_id, supplier_id);


-- PARTIOTIONS --
-- CREATE TABLE gallery_part1 PARTITION OF gallery FOR VALUES WITH (modulus 3, remainder 0);
-- CREATE TABLE gallery_part2 PARTITION OF gallery FOR VALUES WITH (modulus 3, remainder 1);
-- CREATE TABLE gallery_part3 PARTITION OF gallery FOR VALUES WITH (modulus 3, remainder 2);