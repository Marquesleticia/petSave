import 'package:pet_save/models/pet_card.dart';
import 'package:pet_save/services/home_service.dart';

class HomeController {
  final HomeService _service = HomeService();

  Future<List<PetCard>> getUrgentPets() async {
    return await _service.getUrgentPets();
  }

  Future<List<PetCard>> getAllPets() async {
    return await _service.getAllPets();
  }
}
