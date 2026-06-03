# PetSave

App Flutter para localização de animais perdidos e registro de animais encontrados.

---

## Arquitetura MVCS (RQ01)

```
lib/
├── config/
│   └── supabase_config.dart          ← credenciais Supabase (substitua antes de rodar)
├── models/                           ← M: entidades de dados
│   ├── login_model.dart
│   ├── pet_card.dart                 ← inclui latitude e longitude (RQ05)
│   └── pet_details_model.dart        ← inclui latitude e longitude (RQ05)
├── controllers/                      ← C: lógica de interface / estado
│   ├── home_controller.dart
│   ├── login_controller.dart
│   └── pet_details_controller.dart
├── services/                         ← S: persistência remota e regras de negócio
│   ├── supabase_service.dart         ← SDK oficial supabase_flutter (RQ02/RQ03)
│   ├── location_service.dart         ← GPS + geocoding Nominatim/OSM (RQ05) ★ novo
│   ├── home_service.dart
│   ├── login_service.dart
│   └── pet_details_service.dart
├── pages/                            ← V: telas (Views)
│   ├── home_page.dart
│   ├── login_page.dart
│   ├── pet_details_page.dart         ← mapa OSM com local exato (RQ05)
│   ├── pet_registration_page.dart    ← botão GPS + preview de mapa (RQ05)
│   └── register_page.dart
├── widgets/
│   └── feed_card.dart
├── utils/
│   └── image_helpers.dart
└── main.dart                         ← inicializa Supabase antes do runApp
```

---

## Como configurar o Supabase

1. Crie um projeto em https://app.supabase.com
2. Acesse **Settings → API** e copie:
   - **Project URL** → `supabaseUrl`
   - **anon public** → `supabaseAnonKey`
3. Cole os valores em `lib/config/supabase_config.dart`
4. Execute o SQL abaixo no **SQL Editor** do Supabase para criar a tabela e adicionar as colunas de geolocalização:

```sql
-- Tabela principal
-- (execute o migration original primeiro, se ainda não tiver feito)

-- RQ05 – colunas de geolocalização
ALTER TABLE pet_cards
  ADD COLUMN IF NOT EXISTS latitude  DOUBLE PRECISION,
  ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION;

CREATE INDEX IF NOT EXISTS idx_pet_cards_lat_lng
  ON pet_cards (latitude, longitude)
  WHERE latitude IS NOT NULL AND longitude IS NOT NULL;
```

> O arquivo completo está em `supabase_migration_rq05.sql` na raiz do projeto.

---

## Requisitos implementados

| Requisito | Descrição | Status |
|-----------|-----------|--------|
| RQ01 | Arquitetura MVCS | ✅ |
| RQ02 | Persistência remota – SDK Supabase Flutter | ✅ |
| RQ03 | Auth nativo Supabase (`signUp` / `signInWithPassword`) | ✅ |
| RQ04 | Câmera/galeria via `image_picker` | ✅ |
| RQ05 | Integração API externa – geolocalização OSM/Nominatim | ✅ |

---

## RQ05 – Integração com API Externa (Geolocalização)

O sistema utiliza dois serviços externos gratuitos, **sem necessidade de chave de API**:

| Serviço | Função |
|---------|--------|
| **GPS nativo** (`geolocator`) | Captura a posição atual do dispositivo (lat/lng) |
| **Nominatim / OpenStreetMap** | Geocoding reverso: converte lat/lng em endereço legível |
| **OpenStreetMap Tile Server** | Renderiza o mapa interativo (`flutter_map`) |

### Fluxo na tela de cadastro (`pet_registration_page.dart`)

1. Usuário toca em **"Usar minha localização"**
2. O app solicita permissão de GPS ao sistema operacional
3. `LocationService.getCurrentLocation()` retorna lat/lng via `geolocator`
4. `LocationService.reverseGeocode()` chama a API Nominatim e preenche o campo Endereço automaticamente
5. Um **mapa de preview** (OSM, somente leitura) aparece abaixo do campo com um marcador na posição detectada
6. As coordenadas são salvas junto com o pet no Supabase (`latitude`, `longitude`)

### Fluxo na tela de detalhes (`pet_details_page.dart`)

- Se o pet possui coordenadas, exibe a seção **"Local exato no mapa"** com um mapa OSM interativo (pinch-zoom + drag) e um marcador laranja no ponto exato do registro
- Pets cadastrados sem localização continuam funcionando normalmente (seção do mapa é omitida)

### Permissões necessárias

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>O PetSave usa sua localização para registrar onde o animal foi visto ou encontrado.</string>
```

---

## Dependências principais

```yaml
# Persistência remota (RQ02/RQ03)
supabase_flutter: ^2.5.6

# Recurso nativo – câmera/galeria (RQ04)
image_picker: ^0.8.7+5

# Geolocalização e mapas – API externa OSM/Nominatim (RQ05)
flutter_map: ^6.1.0    # renderização de mapas OpenStreetMap
latlong2:    ^0.9.0    # coordenadas geográficas
geolocator:  ^11.0.0   # GPS nativo do dispositivo
http:        ^1.2.1    # requisições HTTP ao Nominatim
```
