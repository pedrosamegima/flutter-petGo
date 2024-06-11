class Tipo{
  final int? id;
  final String tipo;

  Tipo({this.id, required this.tipo});

  factory Tipo.fromJson(Map<String, dynamic>json){
    return Tipo(
      id: json['id'],
      tipo: json['tipo'],
    );
  }
  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'tipo': tipo,
    };
  }
}