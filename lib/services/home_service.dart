import 'package:pet_save/models/pet_card.dart';
import 'package:pet_save/services/supabase_service.dart';


///
///   • [getUrgentPets] → pets perdidos para o carrossel "Urgente"
///   • [getAllPets]    → feed completo para as abas Perdidos / Resgatados
class HomeService {
  final SupabaseService _supabaseService;

  HomeService({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? SupabaseService();

  Future<List<PetCard>> getUrgentPets() =>
      _supabaseService.getPetCardsByType(false);

  Future<List<PetCard>> getAllPets() =>
      _supabaseService.getAllPetCards();
}
