import 'package:pet_save/models/pet_card.dart';
import 'package:pet_save/services/home_service.dart';

/// Controller da tela Home.
///
/// Intermediário sem estado próprio — os Futures são consumidos
/// diretamente pelo FutureBuilder na View.
class HomeController {
  final HomeService _service;

  HomeController({HomeService? service})
      : _service = service ?? HomeService();

  /// Pets perdidos para a lista horizontal "Urgente".
  Future<List<PetCard>> getUrgentPets() => _service.getUrgentPets();

  /// Todos os pets para o feed com abas.
  Future<List<PetCard>> getAllPets() => _service.getAllPets();
}
