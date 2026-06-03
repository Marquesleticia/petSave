import 'package:pet_save/models/pet_details_model.dart';

/// Serviço de dados para a tela de detalhes do pet.
///
/// Atualmente passa o modelo recebido adiante (dados vêm da tela anterior).
/// Pronto para buscar dados extras do Supabase por ID em versões futuras.
class PetDetailsService {
  Future<PetDetailsModel> getPetDetails(PetDetailsModel model) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return model;
  }
}
