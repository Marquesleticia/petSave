import 'package:pet_save/models/pet_card.dart';
import 'package:pet_save/services/postgres_service.dart';

class HomeController {
  final PostgresService _petService = PostgresService();

  Future<List<PetCard>> getUrgentPets() async {
    return await _petService.getPetCardsByType(false);
  }

  Future<List<PetCard>> getAllPets() async {
    return await _petService.getAllPetCards();
  }
}
