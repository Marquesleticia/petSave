import 'package:pet_save/services/supabase_service.dart';

/// Serviço de autenticação (RQ03).
///
/// Delega ao [SupabaseService] que usa o Auth nativo do Supabase,
/// gerenciando hashing, tokens e sessão automaticamente.
class LoginService {
  final SupabaseService _supabaseService;

  LoginService({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? SupabaseService();

  /// Autentica o usuário. Retorna o nome em sucesso ou [null] se inválido.
  Future<String?> authenticate(String email, String password) =>
      _supabaseService.loginUser(email: email, password: password);
}
