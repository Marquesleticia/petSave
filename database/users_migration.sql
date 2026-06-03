CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS users (
    id            SERIAL        PRIMARY KEY,
    name          TEXT          NOT NULL,
    email         TEXT          NOT NULL UNIQUE,
    password_hash TEXT          NOT NULL,
    created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email
    ON users (email);

CREATE OR REPLACE VIEW vw_users AS
SELECT
    id,
    name,
    email,
    '••••••••' AS password,
    created_at
FROM users
ORDER BY created_at DESC;