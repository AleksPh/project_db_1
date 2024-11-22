CREATE USER read_user WITH PASSWORD 'read_password';
CREATE USER create_user WITH PASSWORD 'create_password';
CREATE USER update_user WITH PASSWORD 'update_password';
CREATE USER delete_user WITH PASSWORD 'delete_password';
CREATE USER crud_user WITH PASSWORD 'crud_password';


GRANT development TO read_user;
GRANT development TO create_user;
GRANT development TO update_user;
GRANT development TO delete_user;
GRANT development TO crud_user;

GRANT USAGE ON SCHEMA public TO read_user;
GRANT USAGE ON SCHEMA public TO create_user;
GRANT USAGE ON SCHEMA public TO update_user;
GRANT USAGE ON SCHEMA public TO delete_user;
GRANT USAGE ON SCHEMA public TO crud_user;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO read_user;
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA public TO create_user;
GRANT SELECT, UPDATE ON ALL TABLES IN SCHEMA public TO update_user;
GRANT SELECT, DELETE ON ALL TABLES IN SCHEMA public TO delete_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO crud_user;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO read_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO create_user;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO update_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO delete_user;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO crud_user;