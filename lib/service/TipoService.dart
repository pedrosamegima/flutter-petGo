import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petgo/model/Tipo.dart';

class TipoService{
  static const String baseUrl = 'http://10.121.138.130:8080/tipo/';

  Future<List<Tipo>> buscarTipos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200){
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Tipo.fromJson(item)).toList();
    }else{
      throw Exception('Falha ao carregar os tipos do animal');
    }
  }

  Future<void> criarTipo(Tipo tipo) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(tipo.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Falha ao criar o tipo do animal');
    }
  }
  Future<void> atualizarTipo(Tipo tipo) async{
    final response = await http.put(
      Uri.parse('$baseUrl${tipo.id}'),
      headers: <String, String>{'Content-Type' : 'application/json; charset=UTF-8'},
      body: jsonEncode(tipo.toJson()),
    );
    if(response.statusCode != 200){
      throw Exception('Falha ao atualizar os proprietario');
    }
  }
  Future<void> deletarTipo(int id) async{
    final response = await http.delete(Uri.parse('$baseUrl$id'));
    if(response.statusCode == 204){
      print('Tipo do animla deletado com sucesso');
    }else{
      print('Erro ao deletar tipo: ${response.statusCode} ${response.body}');
      throw Exception('Falha ao deletar o tipo');
    }
  }

}