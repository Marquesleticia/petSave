import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:pet_save/models/pet_card.dart';

/// Serviço central de acesso ao Supabase.
///
/// Utiliza o SDK oficial [supabase_flutter] (RQ02 / RQ03).
/// Todas as operações passam pelo cliente singleton inicializado em [main.dart].
///
/// Convenção de retorno:
///   • Leituras  → retornam o dado solicitado (lista ou objeto)
///   • Escritas  → retornam [null] em sucesso ou [String] de erro para a UI
class SupabaseService {
  // Acesso ao cliente singleton do SDK
  SupabaseClient get _client => Supabase.instance.client;

  static const String _tablePetCards = 'pet_cards';
  static const String _tableUsers    = 'users';

  // ── Autenticação nativa Supabase (RQ03) ─────────────────────────────────

  /// Registra um novo usuário usando o Auth nativo do Supabase.
  ///
  /// O Supabase Auth gerencia hashing, sessão e tokens automaticamente.
  /// Retorna [null] em sucesso ou mensagem de erro amigável.
  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email:    email.trim().toLowerCase(),
        password: password,
        data:     {'name': name.trim()},  // salvo em auth.users → raw_user_meta_data
      );

      if (response.user == null) {
        return 'Erro ao criar conta. Tente novamente.';
      }
      return null; // sucesso
    } on AuthException catch (e) {
      if (e.message.contains('already registered') ||
          e.message.contains('User already registered')) {
        return 'Este e-mail já está cadastrado.';
      }
      return 'Erro ao cadastrar: ${e.message}';
    } catch (_) {
      return 'Falha de conexão. Verifique sua internet.';
    }
  }

  /// Autentica o usuário via e-mail e senha (Auth nativo Supabase).
  ///
  /// Retorna o nome do usuário em sucesso ou [null] se inválido.
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email:    email.trim().toLowerCase(),
        password: password,
      );

      final user = response.user;
      if (user == null) return null;

      // Nome salvo em user_metadata durante o cadastro
      final name = user.userMetadata?['name'] as String?;
      return name ?? email.split('@').first;
    } on AuthException {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Encerra a sessão do usuário atual.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // ── PetCards – CRUD (RQ02) ───────────────────────────────────────────────

  /// Retorna todos os pets ordenados do mais recente.
  Future<List<PetCard>> getAllPetCards() async {
    final rows = await _client
        .from(_tablePetCards)
        .select()
        .order('created_at', ascending: false);

    return (rows as List<dynamic>)
        .map((r) => PetCard.fromMap(r as Map<String, dynamic>))
        .toList();
  }

  /// Retorna pets filtrados por tipo.
  ///
  /// [isResgatado] = false → perdidos | true → resgatados
  Future<List<PetCard>> getPetCardsByType(bool isResgatado) async {
    final rows = await _client
        .from(_tablePetCards)
        .select()
        .eq('isResgatado', isResgatado)
        .order('created_at', ascending: false);

    return (rows as List<dynamic>)
        .map((r) => PetCard.fromMap(r as Map<String, dynamic>))
        .toList();
  }

  /// Insere um novo pet na tabela remota.
  ///
  /// Retorna [null] em sucesso ou mensagem de erro para a UI.
  Future<String?> insertPetCard({
    required String name,
    required bool isResgatado,
    required String local,
    required String timeAgo,
    required String imageUrl,
  }) async {
    try {
      await _client.from(_tablePetCards).insert({
        'name':        name,
        'isResgatado': isResgatado,
        'local':       local,
        'timeAgo':     timeAgo,
        'imageUrl':    imageUrl,
      });
      return null; // sucesso
    } on PostgrestException catch (e) {
      return 'Erro ao cadastrar pet: ${e.message}';
    } catch (_) {
      return 'Falha de conexão. Verifique sua internet.';
    }
  }
}
