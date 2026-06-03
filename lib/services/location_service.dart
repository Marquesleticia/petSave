import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class GeocodingResult {
  final double latitude;
  final double longitude;
  final String displayName; 

  const GeocodingResult({
    required this.latitude,
    required this.longitude,
    required this.displayName,
  });
}

/// Serviço de geolocalização – RQ05 (Integração com API Externa).
///
/// Utiliza:
///   • [geolocator]  → GPS nativo do dispositivo
///   • Nominatim OSM → geocoding reverso e direto 
///
/// Fluxo principal:
///   1. [getCurrentLocation]  → obtém lat/lng via GPS
///   2. [reverseGeocode]      → converte lat/lng em endereço legível (OSM)
///   3. [geocodeAddress]      → converte endereço em lat/lng (OSM)
class LocationService {
  static const String _nominatimBase = 'https://nominatim.openstreetmap.org';

  // User-Agent obrigatório pela política do Nominatim
  static const Map<String, String> _headers = {
    'User-Agent': 'PetSave/1.0 (app de adoção de pets)',
    'Accept-Language': 'pt-BR,pt;q=0.9',
  };

  // ── GPS ──────────────────────────────────────────────────────────────────

  /// Solicita permissão e retorna a posição atual do dispositivo.
  ///
  /// Lança [LocationServiceException] em caso de permissão negada
  /// ou serviço de localização desativado.
  Future<Position> getCurrentLocation() async {
    // Verifica se o serviço de localização está habilitado
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceException(
        'Serviço de localização desativado. Ative o GPS nas configurações.',
      );
    }

    // Verifica/solicita permissão
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationServiceException(
          'Permissão de localização negada.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationServiceException(
        'Permissão de localização negada permanentemente. '
        'Habilite nas configurações do aplicativo.',
      );
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // ── Geocoding Reverso (lat/lng → endereço) ───────────────────────────────

  /// Converte coordenadas em endereço legível usando Nominatim (OSM).
  ///
  /// Retorna [GeocodingResult] com o endereço ou lança [LocationServiceException].
  Future<GeocodingResult> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    final uri = Uri.parse(
      '$_nominatimBase/reverse'
      '?format=json'
      '&lat=$latitude'
      '&lon=$longitude'
      '&zoom=16'
      '&addressdetails=0',
    );

    try {
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw LocationServiceException(
          'Falha no geocoding reverso (status ${response.statusCode}).',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final displayName = json['display_name'] as String? ?? '';

      // Simplifica o endereço: mantém apenas as primeiras partes relevantes
      final simplified = _simplifyAddress(displayName);

      return GeocodingResult(
        latitude: latitude,
        longitude: longitude,
        displayName: simplified,
      );
    } on LocationServiceException {
      rethrow;
    } catch (e) {
      throw LocationServiceException(
        'Erro ao buscar endereço: verifique sua conexão.',
      );
    }
  }

  // ── Geocoding Direto (endereço → lat/lng) ────────────────────────────────

  /// Converte um endereço textual em coordenadas usando Nominatim (OSM).
  ///
  /// Retorna [GeocodingResult] ou null se não encontrar resultados.
  Future<GeocodingResult?> geocodeAddress(String address) async {
    if (address.trim().isEmpty) return null;

    final uri = Uri.parse(
      '$_nominatimBase/search'
      '?format=json'
      '&q=${Uri.encodeComponent(address)}'
      '&limit=1'
      '&addressdetails=0',
    );

    try {
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final list = jsonDecode(response.body) as List<dynamic>;
      if (list.isEmpty) return null;

      final first = list.first as Map<String, dynamic>;
      final lat = double.tryParse(first['lat'] as String? ?? '');
      final lon = double.tryParse(first['lon'] as String? ?? '');
      if (lat == null || lon == null) return null;

      return GeocodingResult(
        latitude: lat,
        longitude: lon,
        displayName: first['display_name'] as String? ?? address,
      );
    } catch (_) {
      return null;
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Simplifica o endereço retornado pelo Nominatim para exibição na UI.
  ///
  /// Mantém rua, número, bairro e cidade (remove estado, país e CEP).
  String _simplifyAddress(String fullAddress) {
    final parts = fullAddress.split(',');
    // Nominatim retorna: rua, nº, bairro, cidade, estado, CEP, país
    // Mantemos as primeiras 4 partes (suficiente para exibição)
    final keep = parts.take(4).map((p) => p.trim()).toList();
    return keep.join(', ');
  }
}

/// Exceção lançada pelo [LocationService] em caso de erro de permissão
/// ou falha de geocoding.
class LocationServiceException implements Exception {
  final String message;
  const LocationServiceException(this.message);

  @override
  String toString() => message;
}
