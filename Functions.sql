-- FUNCTIONS --

CREATE OR REPLACE FUNCTION add_product(
  p_slug TEXT,
  p_product_name VARCHAR(255),
  p_price NUMERIC,
  p_quantity INTEGER,
  p_short_description VARCHAR(165),
  p_product_description TEXT,
  p_product_type VARCHAR(64),
  p_published BOOLEAN,
  staff_email VARCHAR(255)
) RETURNS VOID AS $$
DECLARE
  staff_uuid UUID;
BEGIN
  SELECT id INTO staff_uuid
  FROM staff_accounts
  WHERE email = staff_email;

  -- Handle case where staff member not found (optional)
  IF staff_uuid IS NULL THEN
    RAISE EXCEPTION 'Staff member with email % not found', staff_email;
  END IF;

  INSERT INTO products(
    slug, product_name, price, quantity, short_description, product_description,
    product_type, published, created_by, updated_by
  ) VALUES (
    p_slug, p_product_name, p_price, p_quantity, p_short_description, p_product_description,
    p_product_type, p_published, staff_uuid, staff_uuid
  );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_product(
    p_slug TEXT,
    p_product_name VARCHAR(255),
    p_price NUMERIC,
    p_quantity INTEGER,
    p_short_description VARCHAR(165),
    p_product_description TEXT,
    staff_email VARCHAR(255)
) RETURNS VOID AS $$
DECLARE
    staff_uuid UUID;
BEGIN
    -- Fetch the staff member's UUID based on their email
    SELECT id INTO staff_uuid
    FROM staff_accounts
    WHERE email = staff_email;

    -- Handle case where staff member not found (optional)
    IF staff_uuid IS NULL THEN
        RAISE EXCEPTION 'Staff member with email % not found', staff_email;
    END IF;

    UPDATE products
    SET
        product_name = p_product_name,
        price = p_price,
        quantity = p_quantity,
        short_description = p_short_description,
        product_description = p_product_description,
        updated_by = staff_uuid
    WHERE slug = p_slug;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_product_counts_by_category()
RETURNS TABLE(
    category_name VARCHAR(64),
    product_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        product_type AS category_name,
        CAST(COUNT(*) AS INTEGER) AS product_count
    FROM products
    GROUP BY product_type
    ORDER BY product_count DESC, product_type;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_product_counts_by_user()
RETURNS TABLE(
    user_email VARCHAR(255),
    product_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        sm.email AS user_email,
        CAST(COUNT(p.slug) AS INTEGER) AS product_count
    FROM products p
    JOIN staff_accounts sm ON p.created_by = sm.id
    GROUP BY sm.email
    ORDER BY product_count DESC, sm.email;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION notify_customers_about_coupon()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO notifications(account_id, title, content, seen, receive_time, notification_expiry_date)
    SELECT
        id AS account_id,
        'New Coupon Available!' AS title,
        'A new coupon ' || NEW.code || ' with ' || NEW.discount_value || ' ' || NEW.discount_type || ' discount is now available!' AS content,
        FALSE AS seen,
        NOW() AS receive_time,
        NEW.coupon_end_date AS notification_expiry_date
    FROM customers
    WHERE active = TRUE;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notify_customers
AFTER INSERT ON coupons
FOR EACH ROW
EXECUTE FUNCTION notify_customers_about_coupon();

--  notify_customers_about_coupon_expire_date();