import 'package:pet_save/models/pet_details_model.dart';

class PetDetailsService {
  // Aqui você pode buscar detalhes do pet de uma API ou banco de dados, se necessário.
  // No momento, apenas retorna o modelo recebido (mock).
  Future<PetDetailsModel> getPetDetails(PetDetailsModel model) async {
    // Simulação de delay de rede
    await Future.delayed(const Duration(milliseconds: 300));
    return model;
  }
}
