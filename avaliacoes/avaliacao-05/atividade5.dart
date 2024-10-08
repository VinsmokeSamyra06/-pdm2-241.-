import 'dart:io';
import 'package:path/path.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  // Inicializa o banco de dados
  final dbPath = join(Directory.current.path, 'alunos.db');
  final database = sqlite3.open(dbPath);

  // Cria a tabela se não existir
  database.execute(
    'CREATE TABLE IF NOT EXISTS TB_ALUNO(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT)',
  );

  // Menu para interação com o usuário
  while (true) {
    print('Escolha uma opção:');
    print('1 - Inserir aluno');
    print('2 - Listar alunos');
    print('3 - Sair');

    String? escolha = stdin.readLineSync();

    if (escolha == '1') {
      inserirAluno(database);
    } else if (escolha == '2') {
      listarAlunos(database);
    } else if (escolha == '3') {
      break;
    } else {
      print('Opção inválida, tente novamente.');
    }
  }

  database.dispose();
}

void inserirAluno(Database database) {
  print('Digite o nome do aluno:');
  String? nome = stdin.readLineSync();

  if (nome != null && nome.isNotEmpty) {
    final stmt = database.prepare('INSERT INTO TB_ALUNO (nome) VALUES (?)');
    stmt.execute([nome]);
    stmt.dispose();
    print('Aluno inserido com sucesso.');
  } else {
    print('Nome inválido, tente novamente.');
  }
}

void listarAlunos(Database database) {
  final ResultSet result = database.select('SELECT id, nome FROM TB_ALUNO');

  print('Alunos cadastrados:');
  for (final Row row in result) {
    print('ID: ${row['id']}, Nome: ${row['nome']}');
  }
}