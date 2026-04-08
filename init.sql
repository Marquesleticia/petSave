-- ============================================================
--  PetSave – init.sql
--  Gerado a partir da análise REAL do código Flutter
--  Arquivo: lib/services/database_helper.dart
--  Tabela:  pet_cards  (versão 2 do banco SQLite local)
-- ============================================================

-- ──────────────────────────────────────────────
--  TABELA PRINCIPAL: pet_cards
--  Campos idênticos ao CREATE TABLE do database_helper.dart:
--    id INTEGER PRIMARY KEY AUTOINCREMENT
--    name TEXT NOT NULL
--    isResgatado INTEGER NOT NULL   → 0=perdido, 1=resgatado
--    local TEXT NOT NULL
--    timeAgo TEXT NOT NULL
--    imageUrl TEXT NOT NULL
-- ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS pet_cards (
    id          SERIAL       PRIMARY KEY,
    name        TEXT         NOT NULL,
    "isResgatado" INTEGER    NOT NULL CHECK ("isResgatado" IN (0, 1)),
    local       TEXT         NOT NULL,
    "timeAgo"   TEXT         NOT NULL,
    "imageUrl"  TEXT         NOT NULL,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- Índice para filtrar rapidamente por tipo (perdido/resgatado)
-- Usado em: getPetCardsByType(bool isResgatado)
CREATE INDEX IF NOT EXISTS idx_pet_cards_is_resgatado
    ON pet_cards ("isResgatado");

-- ──────────────────────────────────────────────
--  DADOS PADRÃO
--  Idênticos ao _insertDefaultPets() do database_helper.dart
-- ──────────────────────────────────────────────

-- PERDIDOS (isResgatado = 0)
INSERT INTO pet_cards (name, "isResgatado", local, "timeAgo", "imageUrl") VALUES
    ('Rex',
     0,
     'Parque das Flores',
     '2 horas',
     'https://cdn.pixabay.com/photo/2016/02/19/15/46/dog-1210559_1280.jpg'),

    ('Mia',
     0,
     'Rua das Acácias',
     '5 horas',
     'https://cdn.pixabay.com/photo/2014/11/30/14/11/cat-551554_1280.jpg'),

    ('Bolinha',
     0,
     'Avenida Paulista',
     '1 dia',
     'https://cdn.pixabay.com/photo/2015/11/16/14/34/dog-1045674_1280.jpg'),

-- RESGATADOS (isResgatado = 1)
    ('Doguinho',
     1,
     'Parque Ibirapuera',
     '3 horas',
     'https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313_1280.jpg'),

    ('Luna',
     1,
     'Vila Mariana',
     '6 horas',
     'https://cdn.pixabay.com/photo/2017/07/25/01/22/cat-2534450_1280.jpg');

-- ──────────────────────────────────────────────
--  VIEW útil para o pgAdmin (leitura humana)
-- ──────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_pet_cards AS
SELECT
    id,
    name,
    CASE "isResgatado"
        WHEN 1 THEN 'RESGATADO'
        ELSE        'PERDIDO'
    END AS status,
    local,
    "timeAgo" AS tempo,
    "imageUrl" AS imagem,
    created_at
FROM pet_cards
ORDER BY id;
