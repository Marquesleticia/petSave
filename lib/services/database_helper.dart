import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:petSave/models/pet_card.dart';

class DatabaseHelper {
  static const _databaseName = 'petsave.db';
  static const _databaseVersion = 2;
  static const _tableName = 'pet_cards';

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    final db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );

    // Verifica se a tabela está vazia e insere os dados padrão
    final count = await db.query(_tableName);
    if (count.isEmpty) {
      await _insertDefaultPets(db);
    }

    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        isResgatado INTEGER NOT NULL,
        local TEXT NOT NULL,
        timeAgo TEXT NOT NULL,
        imageUrl TEXT NOT NULL
      )
    ''');
    // Inserir dados padrão
    await _insertDefaultPets(db);
  }

  Future<void> _insertDefaultPets(Database db) async {
    final defaultPets = [
      // PERDIDOS (3)
      {
        'name': 'Rex',
        'isResgatado': 0,
        'local': 'Parque das Flores',
        'timeAgo': '2 horas',
        'imageUrl':
            'https://cdn.pixabay.com/photo/2016/02/19/15/46/dog-1210559_1280.jpg',
      },
      {
        'name': 'Mia',
        'isResgatado': 0,
        'local': 'Rua das Acácias',
        'timeAgo': '5 horas',
        'imageUrl':
            'https://cdn.pixabay.com/photo/2014/11/30/14/11/cat-551554_1280.jpg',
      },
      {
        'name': 'Bolinha',
        'isResgatado': 0,
        'local': 'Avenida Paulista',
        'timeAgo': '1 dia',
        'imageUrl':
            'https://cdn.pixabay.com/photo/2015/11/16/14/34/dog-1045674_1280.jpg',
      },
      // RESGATADOS (2)
      {
        'name': 'Doguinho',
        'isResgatado': 1,
        'local': 'Parque Ibirapuera',
        'timeAgo': '3 horas',
        'imageUrl':
            'https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313_1280.jpg',
      },
      {
        'name': 'Luna',
        'isResgatado': 1,
        'local': 'Vila Mariana',
        'timeAgo': '6 horas',
        'imageUrl':
            'https://cdn.pixabay.com/photo/2017/07/25/01/22/cat-2534450_1280.jpg',
      },
    ];

    for (var pet in defaultPets) {
      await db.insert(_tableName, pet);
    }
  }

  // CREATE - Inserir novo card
  Future<int> insertPetCard(PetCard card) async {
    final db = await database;
    return await db.insert(_tableName, card.toMap());
  }

  // READ - Buscar todos os cards
  Future<List<PetCard>> getAllPetCards() async {
    final db = await database;
    final maps = await db.query(_tableName);
    return List.generate(maps.length, (i) => PetCard.fromMap(maps[i]));
  }

  // READ - Buscar card por ID
  Future<PetCard?> getPetCardById(int id) async {
    final db = await database;
    final maps = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return PetCard.fromMap(maps.first);
    }
    return null;
  }

  // READ - Buscar cards por tipo (Resgatado/Perdido)
  Future<List<PetCard>> getPetCardsByType(bool isResgatado) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'isResgatado = ?',
      whereArgs: [isResgatado ? 1 : 0],
    );
    return List.generate(maps.length, (i) => PetCard.fromMap(maps[i]));
  }

  // UPDATE - Atualizar card
  Future<int> updatePetCard(PetCard card) async {
    final db = await database;
    return await db.update(
      _tableName,
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  // DELETE - Deletar card
  Future<int> deletePetCard(int id) async {
    final db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  // DELETE - Deletar todos os cards
  Future<int> deleteAllPetCards() async {
    final db = await database;
    return await db.delete(_tableName);
  }

  // CLOSE - Fechar conexão
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
