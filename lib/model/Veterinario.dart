class Veterinario{
  final int? id;
  final String nome;
  final String cpf;
  final String rg;
  final String telefone1;
  final String telefone2;
  final String logradouro;
  final String cep;
  final String uf;
  final String numCasa;
  final String cidade;
  final String complemento;
  final String crmv;

  Veterinario({this.id, required this.nome, required this.cpf, required this.rg, required this.logradouro, required this.cep, required this.uf, required this.numCasa, required this.complemento, required this.cidade, required this.telefone1, required this.telefone2, required this.crmv
  });

  factory Veterinario.fromJson(Map<String, dynamic>json){
    return Veterinario(
      id: json['id'],
      nome: json['nome'],
      cpf: json['rg'],
      rg: json['rg'],
      logradouro: json['logradouro'],
      cep: json['cep'],
      uf: json['uf'],
      numCasa: json['numCasa'],
      complemento: json['complemento'],
      cidade: json['cidade'],
      telefone1: json['telefone1'],
      telefone2: json['telefone2'],
      crmv: json['crmv'],
    );
  }
  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'rg': rg,
      'logradouro':logradouro,
      'cep':cep,
      'uf': uf,
      'numCasa': numCasa,
      'complemento': complemento,
      'cidade': cidade,
      'telefone1': telefone1,
      'telefone2': telefone2,
      'crmv': crmv,
    };
  }
}

