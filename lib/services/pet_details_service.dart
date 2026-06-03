import 'package:pet_save/models/pet_details_model.dart';


class PetDetailsService {
  Future<PetDetailsModel> getPetDetails(PetDetailsModel model) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return model;
  }
}
