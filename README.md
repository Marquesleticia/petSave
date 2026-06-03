# PetSave

App Flutter para localização de animais perdidos e registro de animais encontrados.

## Arquitetura MVCS (RQ01)

```
lib/
├── config/
│   └── supabase_config.dart      ← credenciais Supabase (substitua antes de rodar)
├── models/                       ← M: entidades de dados
│   ├── login_model.dart
│   ├── pet_card.dart
│   └── pet_details_model.dart
├── controllers/                  ← C: lógica de interface / estado
│   ├── home_controller.dart
│   ├── login_controller.dart
│   └── pet_details_controller.dart
├── services/                     ← S: persistência remota e regras de negócio
│   ├── supabase_service.dart     ← SDK oficial supabase_flutter (RQ02/RQ03)
│   ├── home_service.dart
│   ├── login_service.dart
│   └── pet_details_service.dart
├── pages/                        ← V: telas (Views)
│   ├── home_page.dart
│   ├── login_page.dart
│   ├── pet_details_page.dart
│   ├── pet_registration_page.dart
│   └── register_page.dart
├── widgets/
│   └── feed_card.dart
├── utils/
│   └── image_helpers.dart
└── main.dart                     ← inicializa Supabase antes do runApp
```

## Como configurar o Supabase

1. Crie um projeto em https://app.supabase.com
2. Acesse **Settings → API** e copie:
   - **Project URL** → `supabaseUrl`
   - **anon public** → `supabaseAnonKey`
3. Cole os valores em `lib/config/supabase_config.dart`
4. Execute o SQL em `database/supabase_migration.sql` no **SQL Editor** do Supabase

## Requisitos implementados

| Requisito | Descrição | Status |
|-----------|-----------|--------|
| RQ01 | Arquitetura MVCS | ✅ |
| RQ02 | Persistência remota – SDK Supabase Flutter | ✅ |
| RQ03 | Auth nativo Supabase (signUp / signInWithPassword) | ✅ |
| RQ04 | Câmera/galeria via image_picker | ✅ |
| RQ05 | Integração API externa (geolocalização) | 🔜 previsto |

## Dependências principais

```yaml
supabase_flutter: ^2.5.6   # SDK oficial (RQ02/RQ03)
image_picker:    ^0.8.7+5  # recurso nativo do dispositivo (RQ04)
```
