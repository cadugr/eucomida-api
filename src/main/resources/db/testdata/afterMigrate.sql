set foreign_key_checks = 0;

DELETE FROM user_roles;
DELETE FROM users;
DELETE FROM roles_permissions;
DELETE FROM roles;
DELETE FROM permissions;
DELETE FROM oauth2_registered_client;

set foreign_key_checks = 1;

alter table user_roles auto_increment = 1;
alter table users auto_increment = 1;
alter table roles_permissions auto_increment = 1;
alter table roles auto_increment = 1;
alter table permissions auto_increment = 1;

-- Permissões
INSERT INTO permissions (name) VALUES ('CREATE_ORDER');
INSERT INTO permissions (name) VALUES ('CONSULT_ORDER_STATUS');

-- Roles
INSERT INTO roles (name) VALUES ('USER'); -- ID 1
INSERT INTO roles (name) VALUES ('DELIVERY_MAN'); -- ID 2

-- Relacionar permissões às roles
INSERT INTO roles_permissions (role_id, permission_id) VALUES (1, 1); -- USER -> CREATE_ORDER
INSERT INTO roles_permissions (role_id, permission_id) VALUES (2, 1); -- DELIVERY_MAN -> CREATE_ORDER
INSERT INTO roles_permissions (role_id, permission_id) VALUES (2, 2); -- DELIVERY_MAN -> CONSULT_ORDER_STATUS

-- Usuários com senha encriptada (BCrypt)
INSERT INTO users (username, password, enabled) VALUES ('joao', '$2a$12$Afvj6vjn0NVxbmpSw0lJW.HrRkqEk5Ced6Ba2XuNwp54VaNiEbfgu', true);
INSERT INTO users (username, password, enabled) VALUES ('maria', '$2a$12$Afvj6vjn0NVxbmpSw0lJW.HrRkqEk5Ced6Ba2XuNwp54VaNiEbfgu', true);

-- Relacionar roles aos usuários
INSERT INTO user_roles (user_id, role_id) VALUES (1, 1); -- joao é USER
INSERT INTO user_roles (user_id, role_id) VALUES (2, 2); -- maria é DELIVERY_MAN

INSERT INTO oauth2_registered_client (
    id,
    client_id,
    client_id_issued_at,
    client_secret,
    client_secret_expires_at,
    client_name,
    client_authentication_methods,
    authorization_grant_types,
    redirect_uris,
    post_logout_redirect_uris,
    scopes,
    client_settings,
    token_settings
) VALUES (
             'frontend-web-client',
             'frontend-web',
             CURRENT_TIMESTAMP,
             NULL,
             NULL,
             'Frontend Web',
             'none',
             'refresh_token,authorization_code',
             'http://localhost:4200/callback',
             'http://localhost:4200/',
             'profile,email',
             '{"@class":"java.util.Collections$UnmodifiableMap","settings.client.require-proof-key":true,"settings.client.require-authorization-consent":false}',
             '{"@class":"java.util.Collections$UnmodifiableMap","settings.token.reuse-refresh-tokens":true,"settings.token.x509-certificate-bound-access-tokens":false,"settings.token.id-token-signature-algorithm":["org.springframework.security.oauth2.jose.jws.SignatureAlgorithm","RS256"],"settings.token.access-token-time-to-live":["java.time.Duration",3600.000000000],"settings.token.access-token-format":{"@class":"org.springframework.security.oauth2.server.authorization.settings.OAuth2TokenFormat","value":"self-contained"},"settings.token.refresh-token-time-to-live":["java.time.Duration",10800.000000000],"settings.token.authorization-code-time-to-live":["java.time.Duration",300.000000000],"settings.token.device-code-time-to-live":["java.time.Duration",300.000000000]}'
         );
