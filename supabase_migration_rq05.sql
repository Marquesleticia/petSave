-- ============================================================
-- RQ05 – Integração com API Externa (Geolocalização OSM)
-- Migration: adicionar colunas latitude e longitude
-- Tabela: pet_cards
-- ============================================================

-- Adiciona colunas de geolocalização (opcionais – nullable)
-- Tipo DOUBLE PRECISION (= float8) para coordenadas geográficas com
-- precisão suficiente (~1,1 m no equador a 8 casas decimais).

ALTER TABLE pet_cards
  ADD COLUMN IF NOT EXISTS latitude  DOUBLE PRECISION,
  ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION;

-- Índice para consultas geográficas futuras (ex.: pets próximos ao usuário)
CREATE INDEX IF NOT EXISTS idx_pet_cards_lat_lng
  ON pet_cards (latitude, longitude)
  WHERE latitude IS NOT NULL AND longitude IS NOT NULL;

-- ============================================================
-- Verificação (execute para confirmar o resultado)
-- ============================================================
-- SELECT column_name, data_type
-- FROM information_schema.columns
-- WHERE table_name = 'pet_cards'
--   AND column_name IN ('latitude', 'longitude');
