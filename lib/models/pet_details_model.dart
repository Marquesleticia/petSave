/// Dados detalhados de um pet exibidos na tela de detalhes.
class PetDetailsModel {
  final String name;
  final bool isResgatado;
  final String local;
  final String imageUrl;
  final String description;
  // RQ05 – Geolocalização
  final double? latitude;
  final double? longitude;

  const PetDetailsModel({
    required this.name,
    required this.isResgatado,
    required this.local,
    required this.imageUrl,
    required this.description,
    this.latitude,
    this.longitude,
  });
}
