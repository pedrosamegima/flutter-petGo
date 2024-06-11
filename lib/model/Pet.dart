class Pet{
  final int? id;
  final String nome;
  final String dataNasc;
  final String NumDoc;
  final String raca;
  final String cor;

  Pet({this.id, required this.nome, required this.dataNasc, required this.NumDoc, required this.raca, required this.cor});

  factory Pet.fromJson(Map<String, dynamic>json){
    return Pet(
      id: json['id'],
      nome: json['nome'],
      dataNasc: json['dataNasc'],
      NumDoc: json['NumDoc'],
      raca: json['raca'],
      cor: json['cor'],
    );
  }
  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'nome': nome,
      'dataNasc': dataNasc,
      'NumDoc': NumDoc,
      'raca': raca,
      'cor':cor,

    };
  }
}
