//Dupla -> Ana Carla e Samyra Vitoria

import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }
  Map<String, dynamic> toJson() {
    return {"nome": _nome};
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }
  Map<String, dynamic> toJson() {
    return {
      "nome": _nome,
      "dependentes": _dependentes.map((d) => d.toJson()).toList()
    };
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }
  Map<String, dynamic> toJson() {
    return {
      "nomeProjeto": _nomeProjeto,
      "funcionarios": _funcionarios.map((f) => f.toJson()).toList()
    };
  }
}

// --------------------- // --------------//

void main() {
  var dependente1 = Dependente("Dependente 1");
  var dependente2 = Dependente("Dependente 2");
  var dependente3 = Dependente("Dependente 3");
  var dependente4 = Dependente("Dependente 4");
  var dependente5 = Dependente("Dependente 5");
  var dependente6 = Dependente("Dependente 6");
  var dependente7 = Dependente("Dependente 7");
  var dependente8 = Dependente("Dependente 8");

// --------------------- //

  var funcionario1 = Funcionario("Tiago", [dependente1]);
  var funcionario2 = Funcionario("Maria", [dependente2]);
  var funcionario3 = Funcionario("Matheus", [dependente3]);
  var funcionario4 = Funcionario("Simão", [dependente4]);
  var funcionario5 = Funcionario("André", [dependente5]);
  var funcionario6 = Funcionario("Tamá", [dependente6]);
  var funcionario7 = Funcionario("Ramá", [dependente7]);
  var funcionario8 = Funcionario("Pedro", [dependente8]);

  // --------------------- //
  var funcionarios = [
    funcionario1,
    funcionario2,
    funcionario3,
    funcionario4,
    funcionario5,
    funcionario6,
    funcionario7,
    funcionario8
  ];

  // --------------------- //

  var equipeProjeto = EquipeProjeto("Meu Projeto", funcionarios);
 equipeProjeto = EquipeProjeto("Meu Projeto", funcionarios);
  var equipeProjetoJson = jsonEncode(equipeProjeto.toJson());
  print(equipeProjetoJson);
}