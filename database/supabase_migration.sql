-- ============================================================
--  PetSave – supabase_migration.sql
--
--  Execute este script no SQL Editor do Supabase:
--    https://app.supabase.com → seu projeto → SQL Editor → New Query
--
--  O Supabase já gerencia autenticação via auth.users.
--  Tabela de usuários customizada (name, etc.) não é necessária
--  pois o nome é salvo em auth.users.raw_user_meta_data → 'name'.
-- ============================================================

-- ──────────────────────────────────────────────────────────────
--  TABELA: pet_cards
--  isResgatado: BOOLEAN nativo (true = resgatado, false = perdido)
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS pet_cards (
    id           BIGSERIAL    PRIMARY KEY,
    name         TEXT         NOT NULL,
    "isResgatado" BOOLEAN     NOT NULL DEFAULT false,
    local        TEXT         NOT NULL,
    "timeAgo"    TEXT         NOT NULL DEFAULT 'Agora',
    "imageUrl"   TEXT         NOT NULL,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- Índice para filtro rápido por tipo (RF06 / RF07 / RF08)
CREATE INDEX IF NOT EXISTS idx_pet_cards_is_resgatado
    ON pet_cards ("isResgatado");

-- ──────────────────────────────────────────────────────────────
--  ROW LEVEL SECURITY (RLS)
--  Leitura pública; escrita apenas para usuários autenticados.
-- ──────────────────────────────────────────────────────────────
ALTER TABLE pet_cards ENABLE ROW LEVEL SECURITY;

-- Qualquer pessoa pode visualizar os pets
CREATE POLICY "pet_cards_select_public"
    ON pet_cards FOR SELECT
    USING (true);

-- Apenas usuários autenticados podem inserir
CREATE POLICY "pet_cards_insert_authenticated"
    ON pet_cards FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- ──────────────────────────────────────────────────────────────
--  DADOS INICIAIS (seed)
-- ──────────────────────────────────────────────────────────────
INSERT INTO pet_cards (name, "isResgatado", local, "timeAgo", "imageUrl") VALUES
    ('Rex',      false, 'Parque das Flores',   '2 horas',
     'https://cdn.pixabay.com/photo/2016/02/19/15/46/dog-1210559_1280.jpg'),
    ('Mia',      false, 'Rua das Acácias',     '5 horas',
     'https://cdn.pixabay.com/photo/2014/11/30/14/11/cat-551554_1280.jpg'),
    ('Bolinha',  false, 'Avenida Paulista',    '1 dia',
     'https://cdn.pixabay.com/photo/2015/11/16/14/34/dog-1045674_1280.jpg'),
    ('Doguinho', true,  'Parque Ibirapuera',   '3 horas',
     'https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313_1280.jpg'),
    ('Luna',     true,  'Vila Mariana',        '6 horas',
     'https://cdn.pixabay.com/photo/2017/07/25/01/22/cat-2534450_1280.jpg');

-- ──────────────────────────────────────────────────────────────
--  VIEW auxiliar para inspeção no Supabase Dashboard
-- ──────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_pet_cards AS
SELECT
    id,
    name,
    CASE "isResgatado"
        WHEN true  THEN 'RESGATADO'
        ELSE            'PERDIDO'
    END AS status,
    local,
    "timeAgo"   AS tempo,
    "imageUrl"  AS imagem,
    created_at
FROM pet_cards
ORDER BY created_at DESC;
