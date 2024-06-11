import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petgo/model/Consulta.dart';

class ConsultaService{
  static const String baseUrl = 'http://10.121.138.130:8080/consulta/';

  Future<List<Consulta>> buscarConsultas() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200){
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Consulta.fromJson(item)).toList();
    }else{
      throw Exception('Falha ao carregar as consultas');
    }
  }

  Future<void> criarConsulta(Consulta consulta) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(consulta.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Falha ao criar a consulta');
    }
  }
  Future<void> atualizarConsulta(Consulta consulta) async{
    final response = await http.put(
      Uri.parse('$baseUrl${consulta.id}'),
      headers: <String, String>{'Content-Type' : 'application/json; charset=UTF-8'},
      body: jsonEncode(consulta.toJson()),
    );
    if(response.statusCode != 200){
      throw Exception('Falha ao atualizar as consultas');
    }
  }
  Future<void> deletarConsulta(int id) async{
    final response = await http.delete(Uri.parse('$baseUrl$id'));
    if(response.statusCode == 204){
      print('Consulta deletado com sucesso');
    }else{
      print('Erro ao deletar consulta: ${response.statusCode} ${response.body}');
      throw Exception('Falha ao deletar a consulta');
    }
  }

}