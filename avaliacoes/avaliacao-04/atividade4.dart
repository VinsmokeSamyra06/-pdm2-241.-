import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  // Inicializa o sqflite_common_ffi para uso em ambiente desktop
  sqfliteFfiInit();

  // Define a factory para usar o sqflite_common_ffi
  databaseFactory = databaseFactoryFfi;

  // Chama a função principal
  await runDatabaseOperations();
}

Future<void> runDatabaseOperations() async {
  var databasePath = await getDatabasesPath();
  String path = join(databasePath, "demo.db");

  // Deleta o banco de dados se ele já existir
  await deleteDatabase(path);

  // Abre o banco de dados e cria a tabela Aluno
  var db = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    await db.execute("CREATE TABLE Aluno (id INTEGER PRIMARY KEY, nome TEXT)");
  });

  // Insere registros na tabela Aluno
  await db.execute("INSERT INTO Aluno (nome) VALUES ('João')");
  await db.execute("INSERT INTO Aluno (nome) VALUES ('Maria')");

  // Fecha o banco de dados
  await db.close();

  // Abre novamente o banco de dados
  db = await openDatabase(path);

  // Insere mais registros na tabela Aluno
  await db.execute("INSERT INTO Aluno (nome) VALUES ('Marcos')");
  await db.execute("INSERT INTO Aluno (nome) VALUES ('Samyra')");

  // Consulta e exibe os registros da tabela Aluno
  print("Alunos:");
  var alunos = await db.query("Aluno");
  for (var aluno in alunos) {
    print(aluno['nome']);
  }

  // Fecha o banco de dados
  await db.close();
}
