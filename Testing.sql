
--INSERT INTO roles (role_name, privileges) VALUES ('Admin', ARRAY['CREATE', 'READ', 'UPDATE', 'DELETE']);
--INSERT INTO roles (role_name, privileges) VALUES ('Staff', ARRAY['READ', 'UPDATE']);
--INSERT INTO roles (role_name, privileges) VALUES ('Viewer', ARRAY['READ']);

INSERT INTO staff_accounts (first_name, last_name, email, password_hash, role_id) VALUES ('John', 'Doe', 'john.doe@example.com', 'hashed_password1', 1);
INSERT INTO staff_accounts (first_name, last_name, email, password_hash, role_id) VALUES ('Jane', 'Smith', 'jane.smith@example.com', 'hashed_password2', 2);


SELECT add_product(
    'Apple-MacBook-M2-2024',
    'MacBook Pro 16" 2024 Apple M2 Pro, 512GB, 1TB',
    3999.99,
    10,
    'This is a short description',
    'This is a longer product description',
    'Electronics',
    TRUE,
    'john.doe@example.com'
);
SELECT add_product(
    'Samsung-GalaxyS14-2024',
    'Samsung Galaxy S14 2024, 128GB, 5G',
    999.99,
    20,
    'Latest Samsung flagship phone',
    'The Samsung Galaxy S14 offers the latest in smartphone technology with a vibrant display and cutting-edge camera system.',
    'Electronics',
    TRUE,
    'jane.smith@example.com'
);
SELECT add_product(
    'Nike-AirMax-2024',
    'Nike Air Max 2024 Edition, Blue/White, Size 10-12',
    149.99,
    50,
    'Latest Nike Air Max shoes',
    'The Nike Air Max 2024 Edition offers unparalleled comfort with its advanced cushioning system. Perfect for athletes and casual wearers alike.',
    'Clothing',
    TRUE,
    'jane.smith@example.com'
);
SELECT update_product(
    'Nike-AirMax-2024',
    'Nike Air Max 2024 Limited Edition, Blue/White, Size 10',
    159.99,
    40,
    'Limited Edition Nike Air Max shoes',
    'The Nike Air Max 2024 Limited Edition offers enhanced features and a unique design. Perfect for those looking for exclusivity.',
    'john.doe@example.com'
);

SELECT * FROM get_product_counts_by_category();

SELECT * FROM get_product_counts_by_user();

-- Inserting two sample customers
INSERT INTO customers(first_name, last_name, email, password_hash)
VALUES
('Arnold', 'SH', 'arnold.sh@example.com', 'hashed_password1'),
('Lorem', 'Ipsum', 'lorem.ipsum@example.com', 'hashed_password2');




-- -- Inserting a new coupon
-- INSERT INTO coupons(code, discount_value, discount_type, coupon_start_date, coupon_end_date, created_by, updated_by)
-- VALUES
-- ('SUMMER20-2', 20, 'PERCENT', NOW(), NOW() + INTERVAL '1 month', '8f600855-731f-4add-8ffa-4d2c286f1d00', '8f600855-731f-4add-8ffa-4d2c286f1d00');
--
-- INSERT INTO coupons(code, discount_value, discount_type, coupon_start_date, coupon_end_date, created_by, updated_by)
-- VALUES
-- ('WINTER20', 25, 'PERCENT', NOW(), NOW() + INTERVAL '1 month', '8f600855-731f-4add-8ffa-4d2c286f1d00', '8f600855-731f-4add-8ffa-4d2c286f1d00');
--
--
-- select * from customers;
-- select* from notifications;