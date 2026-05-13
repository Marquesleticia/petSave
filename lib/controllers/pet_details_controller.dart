import 'package:flutter/material.dart';
import 'package:pet_save/models/pet_details_model.dart';
import 'package:pet_save/services/pet_details_service.dart';

class PetDetailsController extends ChangeNotifier {
  final PetDetailsService _service = PetDetailsService();
  PetDetailsModel? _petDetails;
  bool _loading = false;
  String? _error;

  PetDetailsModel? get petDetails => _petDetails;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadPetDetails(PetDetailsModel model) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _petDetails = await _service.getPetDetails(model);
    } catch (e) {
      _error = 'Erro ao carregar detalhes do pet';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
