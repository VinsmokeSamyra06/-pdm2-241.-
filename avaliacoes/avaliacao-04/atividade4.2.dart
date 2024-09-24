import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Aluno {
  int? id;
  String nome;
  String dataNascimento;

  Aluno({this.id, required this.nome, required this.dataNascimento});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['nome'] = nome;
    map['data_nascimento'] = dataNascimento;
    return map;
  }

  static Aluno fromMap(Map<String, dynamic> map) {
    return Aluno(
      id: map['id'],
      nome: map['nome'],
      dataNascimento: map['data_nascimento'],
    );
  }
}

class AlunoDatabase {
  static final AlunoDatabase instance = AlunoDatabase._init();

  static Database? _database;

  AlunoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('aluno.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE TB_ALUNOS (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        data_nascimento TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertAluno(Aluno aluno) async {
    final db = await database;
    return await db.insert('TB_ALUNOS', aluno.toMap());
  }

  Future<Aluno?> getAluno(int id) async {
    final db = await database;
    final maps = await db.query(
      'TB_ALUNOS',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return Aluno.fromMap(maps.first);
  }

  Future<List<Aluno>> getAllAlunos() async {
    final db = await database;
    final maps = await db.query('TB_ALUNOS');

    return List.generate(maps.length, (i) {
      return Aluno.fromMap(maps[i]);
    });
  }

  Future<int> updateAluno(Aluno aluno) async {
    final db = await database;
    return await db.update(
      'TB_ALUNOS',
      aluno.toMap(),
      where: 'id = ?',
      whereArgs: [aluno.id],
    );
  }

  Future<int> deleteAluno(int id) async {
    final db = await database;
    return await db.delete(
      'TB_ALUNOS',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

Future<String> dbPath(String dbName) async {
  final dbPath = await getDatabasesPath();
  return join(dbPath, dbName);
}

void main() async {
  // Inicializar sqflite_common_ffi
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // Inicializar o banco de dados
  final db = AlunoDatabase.instance;

  // Deletar qualquer banco de dados existente
  await databaseFactory.deleteDatabase(await dbPath('aluno.db'));

  // Inserir um aluno
  final aluno = Aluno(nome: 'João', dataNascimento: '2000-01-01');
  int alunoId = await db.insertAluno(aluno);

  // Buscar um aluno pelo ID
  Aluno? retrievedAluno = await db.getAluno(alunoId);
  print('Aluno recuperado: ${retrievedAluno?.toMap()}');

  // Atualizar os dados de um aluno
  if (retrievedAluno != null) {
    retrievedAluno.nome = 'João da Silva';
    await db.updateAluno(retrievedAluno);

    // Buscar todos os alunos
    List<Aluno> alunos = await db.getAllAlunos();
    print('Todos os alunos: ${alunos.map((a) => a.toMap()).toList()}');

    // Deletar um aluno
    await db.deleteAluno(alunoId);
  }
}
