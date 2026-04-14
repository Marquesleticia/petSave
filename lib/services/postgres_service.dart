import 'package:crypto/crypto.dart';
import 'package:postgres/postgres.dart';
import 'package:pet_save/models/pet_card.dart';
import 'dart:convert';

class PostgresService {
  static const String _host = 'localhost';
  static const int _port = 5432;
  static const String _database = 'petsave';
  static const String _username = 'petsave_user';
  static const String _password = 'petsave_pass';

  Future<Connection> _openConnection() async {
    return await Connection.open(
      Endpoint(
        host: _host,
        port: _port,
        database: _database,
        username: _username,
        password: _password,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
  }

  // ── Hash de senha (SHA-256) ──────────────────────────────
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // ── Cadastrar novo usuário ───────────────────────────────
  /// Retorna null se OK, ou uma mensagem de erro se falhar.
  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final conn = await _openConnection();
    try {
      final hash = _hashPassword(password);

      await conn.execute(
        Sql(r'''
          INSERT INTO users (name, email, password_hash)
          VALUES ($1, $2, $3)
        '''),
        parameters: [name.trim(), email.trim().toLowerCase(), hash],
      );

      return null; // sucesso
    } on ServerException catch (e) {
      if (e.message.contains('unique') ||
          e.message.contains('idx_users_email') ||
          e.message.contains('duplicate')) {
        return 'Este e-mail já está cadastrado.';
      }
      return 'Erro ao cadastrar: ${e.message}';
    } finally {
      await conn.close();
    }
  }

  // ── Login ────────────────────────────────────────────────
  /// Retorna o nome do usuário se as credenciais estiverem corretas,
  /// ou null se e-mail/senha estiverem errados.
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    final conn = await _openConnection();
    try {
      final hash = _hashPassword(password);

      final result = await conn.execute(
        Sql(r'''
          SELECT name FROM users
          WHERE email = $1
            AND password_hash = $2
          LIMIT 1
        '''),
        parameters: [email.trim().toLowerCase(), hash],
      );

      if (result.isEmpty) return null;
      return result.first[0] as String;
    } finally {
      await conn.close();
    }
  }

  // ── Pet Cards ────────────────────────────────────────────
  Future<List<PetCard>> getPetCardsByType(bool isResgatado) async {
    final conn = await _openConnection();
    try {
      final result = await conn.execute(
        Sql(r'''
          SELECT id, name, "isResgatado", local, "timeAgo", "imageUrl"
          FROM pet_cards
          WHERE "isResgatado" = $1
          ORDER BY created_at DESC
        '''),
        parameters: [isResgatado ? 1 : 0],
      );

      return result
          .map((row) => PetCard(
                id: row[0] as int?,
                name: row[1] as String,
                isResgatado: (row[2] as int) == 1,
                local: row[3] as String,
                timeAgo: row[4] as String,
                imageUrl: row[5] as String,
              ))
          .toList();
    } finally {
      await conn.close();
    }
  }

  Future<List<PetCard>> getAllPetCards() async {
    final conn = await _openConnection();
    try {
      final result = await conn.execute(
        Sql(r'''
          SELECT id, name, "isResgatado", local, "timeAgo", "imageUrl"
          FROM pet_cards
          ORDER BY created_at DESC
        '''),
      );

      return result
          .map((row) => PetCard(
                id: row[0] as int?,
                name: row[1] as String,
                isResgatado: (row[2] as int) == 1,
                local: row[3] as String,
                timeAgo: row[4] as String,
                imageUrl: row[5] as String,
              ))
          .toList();
    } finally {
      await conn.close();
    }
  }

  // ── Inserir novo pet card ────────────────────────────────
  /// Retorna null se OK, ou uma mensagem de erro se falhar.
  Future<String?> insertPetCard({
    required String name,
    required bool isResgatado,
    required String local,
    required String timeAgo,
    required String imageUrl,
  }) async {
    final conn = await _openConnection();
    try {
      await conn.execute(
        Sql(r'''
          INSERT INTO pet_cards (name, "isResgatado", local, "timeAgo", "imageUrl")
          VALUES ($1, $2, $3, $4, $5)
        '''),
        parameters: [name, isResgatado ? 1 : 0, local, timeAgo, imageUrl],
      );

      return null; // sucesso
    } on ServerException catch (e) {
      return 'Erro ao cadastrar pet: ${e.message}';
    } finally {
      await conn.close();
    }
  }
}
