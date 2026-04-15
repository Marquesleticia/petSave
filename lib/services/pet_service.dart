// Importações do pacote PostgreSQL e do modelo de dados
import 'package:postgres/postgres.dart';
import 'package:pet_save/models/pet_card.dart';

// Serviço para gerenciar operações com o banco de dados PostgreSQL
class PostgresService {
  // Abre uma conexão com o banco de dados PostgreSQL
  Future<Connection> _openConnection() async {
    return await Connection.open(
      Endpoint(
        host: 'localhost', // Host do servidor
        port: 5432, // Porta padrão do PostgreSQL
        database: 'petsave', // Nome do banco de dados
        username: 'petsave_user', // Usuário do banco
        password: 'petsave_pass', // Senha do banco
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable, // SSL desativado para ambiente local
      ),
    );
  }

  // Recupera todos os pets cadastrados no banco de dados
  Future<List<PetCard>> getAllPetCards() async {
    // Abre conexão com o banco
    final conn = await _openConnection();

    try {
      // Executa query para buscar todos os pets ordenados por data de criação
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

      // Mapeia os resultados do banco para objetos PetCard
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
      // Fecha a conexão com o banco
      await conn.close();
    }
  }

  // Recupera pets filtrados por tipo (perdidos ou resgatados)
  Future<List<PetCard>> getPetCardsByType(bool isResgatado) async {
    // Abre conexão com o banco
    final conn = await _openConnection();

    try {
      // Executa query com filtro por status (resgatado ou perdido)
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
        // Passa o parâmetro: 1 para resgatado, 0 para perdido
        parameters: [isResgatado ? 1 : 0],
      );

      // Mapeia os resultados do banco para objetos PetCard
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
      // Fecha a conexão com o banco
      await conn.close();
    }
  }
}
