# 🐾 PetSave – Banco de Dados (Docker)

## O que foi corrigido (vs. versão anterior)

| Problema anterior | Correção aplicada |
|---|---|
| Tabelas inexistentes (`users`, `pets`, `adoption_requests`, `favorites`) | Removidas — não existem no código |
| Campos inventados (`species`, `breed`, `age_months`, `gender`...) | Removidos |
| UUID como PK | Trocado por `SERIAL` (igual ao `AUTOINCREMENT` do SQLite) |
| `version: '3.9'` obsoleto | Removido |
| Healthcheck sem `start_period` | Adicionado `start_period: 30s` |

## Estrutura real do banco (do código Flutter)

A tabela `pet_cards` é criada em `lib/services/database_helper.dart`:

```sql
CREATE TABLE pet_cards (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    "isResgatado" INTEGER NOT NULL,  -- 0=perdido, 1=resgatado
    local       TEXT NOT NULL,
    "timeAgo"   TEXT NOT NULL,
    "imageUrl"  TEXT NOT NULL,
    created_at  TIMESTAMPTZ DEFAULT NOW()
)
```

## Estrutura dos arquivos

```
docker-compose.yml      ← orquestra PostgreSQL + pgAdmin
init.sql                ← cria a tabela real e insere os 5 pets padrão
pgadmin_servers.json    ← pré-configura o servidor no pgAdmin
```

Coloque todos na **raiz do projeto PetSave** (mesma pasta do `pubspec.yaml`).

## ▶️ Subir o ambiente

```bash
# 1. Limpar containers e volumes antigos (IMPORTANTE se já tentou antes)
docker compose down -v

# 2. Subir tudo do zero
docker compose up -d
```

## 🔍 Verificar se subiu

```bash
docker compose ps
docker logs petsave_db
```

## 🗄️ Acessos

| Serviço | URL / Porta | Credenciais |
|---|---|---|
| PostgreSQL | `localhost:5432` | user: `petsave_user` / pass: `petsave_pass` / db: `petsave` |
| pgAdmin | http://localhost:5050 | email: `admin@petsave.com` / senha: `admin123` |

## 🛑 Outros comandos

```bash
# Parar (mantém os dados)
docker compose down

# Parar e apagar tudo (reset total)
docker compose down -v

# Acessar o banco via terminal
docker exec -it petsave_db psql -U petsave_user -d petsave

# Ver os pets no banco
docker exec -it petsave_db psql -U petsave_user -d petsave -c "SELECT * FROM vw_pet_cards;"
```

## ⚠️ Nota importante

O app Flutter usa **SQLite local** (`sqflite`) no dispositivo. Este banco PostgreSQL serve para:
- Visualizar e gerenciar os dados via pgAdmin
- Servir como backend compartilhado (se futuramente integrar uma API)
- Desenvolvimento e testes com dados reais
