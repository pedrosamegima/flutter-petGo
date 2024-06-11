class Consulta{
  final int? id;
  final String data;
  final String hora;
  final String descricao;

  Consulta({this.id, required this.data, required this.hora, required this.descricao});

  factory Consulta.fromJson(Map<String, dynamic>json){
    return Consulta(
      id: json['id'],
      data: json['data'],
      hora: json['hora'],
      descricao: json['descricao'],
    );
  }
  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'data': data,
      'hora': hora,
      'descricao': descricao,
    };
  }
}