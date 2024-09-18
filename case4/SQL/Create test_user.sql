CREATE USER 'test_user'@'localhost' IDENTIFIED BY 'Test,123';
GRANT SELECT ON energo.* TO 'test_user'@'localhost';
GRANT INSERT, UPDATE, DELETE ON energo.auth TO 'test_user'@'localhost';
FLUSH PRIVILEGES;