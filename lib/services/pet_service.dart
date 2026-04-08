import 'package:postgres/postgres.dart';
import 'package:pet_save/models/pet_card.dart';

class PostgresService {
  Future<Connection> _openConnection() async {
    return await Connection.open(
      Endpoint(
        host: 'localhost',
        port: 5432,
        database: 'petsave',
        username: 'petsave_user',
        password: 'petsave_pass',
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
      ),
    );
  }

  Future<List<PetCard>> getAllPetCards() async {
    final conn = await _openConnection();

    try {
      final result = await conn.execute(
        Sql(r'''
          SELECT
            id,
            name,
            "isResgatado",
            local,
            "timeAgo",
            "imageUrl"
          FROM pet_cards
          ORDER BY created_at DESC
        '''),
      );

      return result.map((row) {
        return PetCard.fromMap({
          'id': row[0],
          'name': row[1],
          'isResgatado': row[2],
          'local': row[3],
          'timeAgo': row[4],
          'imageUrl': row[5],
        });
      }).toList();
    } finally {
      await conn.close();
    }
  }

  Future<List<PetCard>> getPetCardsByType(bool isResgatado) async {
    final conn = await _openConnection();

    try {
      final result = await conn.execute(
        Sql(r'''
          SELECT
            id,
            name,
            "isResgatado",
            local,
            "timeAgo",
            "imageUrl"
          FROM pet_cards
          WHERE "isResgatado" = $1
          ORDER BY created_at DESC
        '''),
        parameters: [isResgatado ? 1 : 0],
      );

      return result.map((row) {
        return PetCard.fromMap({
          'id': row[0],
          'name': row[1],
          'isResgatado': row[2],
          'local': row[3],
          'timeAgo': row[4],
          'imageUrl': row[5],
        });
      }).toList();
    } finally {
      await conn.close();
    }
  }
}