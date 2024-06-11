class Especialidade{
  final int? id;
  final String nome;

  Especialidade({this.id, required this.nome});

  factory Especialidade.fromJson(Map<String, dynamic>json){
    return Especialidade(
      id: json['id'],
      nome: json['nome'],
    );
  }
  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'nome': nome,
    };
  }
}
