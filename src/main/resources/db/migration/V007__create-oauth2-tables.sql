CREATE TABLE oauth2_authorization (
  id VARCHAR(100) PRIMARY KEY,
  registered_client_id VARCHAR(100) NOT NULL,
  principal_name VARCHAR(200) NOT NULL,
  authorization_grant_type VARCHAR(100) NOT NULL,
  attributes TEXT,
  state VARCHAR(500),
  authorization_code_value TEXT,
  authorization_code_issued_at TIMESTAMP,
  authorization_code_expires_at TIMESTAMP,
  authorization_code_metadata TEXT,
  access_token_value TEXT,
  access_token_issued_at TIMESTAMP,
  access_token_expires_at TIMESTAMP,
  access_token_metadata TEXT,
  access_token_type VARCHAR(100),
  access_token_scopes TEXT,
  refresh_token_value TEXT,
  refresh_token_issued_at TIMESTAMP,
  refresh_token_expires_at TIMESTAMP,
  refresh_token_metadata TEXT,
  id_token_value TEXT,
  id_token_issued_at TIMESTAMP,
  id_token_expires_at TIMESTAMP,
  id_token_metadata TEXT,
  user_code_value TEXT,
  user_code_issued_at TIMESTAMP,
  user_code_expires_at TIMESTAMP,
  user_code_metadata TEXT,
  device_code_value TEXT,
  device_code_issued_at TIMESTAMP,
  device_code_expires_at TIMESTAMP,
  device_code_metadata TEXT
);

CREATE TABLE oauth2_authorization_consent (
  registered_client_id VARCHAR(100) NOT NULL,
  principal_name VARCHAR(200) NOT NULL,
  authorities TEXT NOT NULL,
  PRIMARY KEY (registered_client_id, principal_name)
);

CREATE TABLE oauth2_registered_client (
  id VARCHAR(100) PRIMARY KEY,
  client_id VARCHAR(100) NOT NULL,
  client_id_issued_at TIMESTAMP NOT NULL,
  client_secret VARCHAR(200),
  client_secret_expires_at TIMESTAMP,
  client_name VARCHAR(200) NOT NULL,
  client_authentication_methods TEXT NOT NULL,
  authorization_grant_types TEXT NOT NULL,
  redirect_uris TEXT NOT NULL,
  post_logout_redirect_uris TEXT,
  scopes TEXT NOT NULL,
  client_settings TEXT NOT NULL,
  token_settings TEXT NOT NULL
);
