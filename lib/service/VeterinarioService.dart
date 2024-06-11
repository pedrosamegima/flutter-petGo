import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petgo/model/Veterinario.dart';

class VeterinarioService{
  static const String baseUrl = 'http://10.121.138.130:8080/veterinario/';

  Future<List<Veterinario>> buscarVeterinarios() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200){
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Veterinario.fromJson(item)).toList();
    }else{
      throw Exception('Falha ao carregar os veterinarios');
    }
  }

  Future<void> criarVeterinario(Veterinario veterinario) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(veterinario.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Falha ao criar o veterinario');
    }
  }
  Future<void> atualizarVeterinario(Veterinario veterinario) async{
    final response = await http.put(
      Uri.parse('$baseUrl${veterinario.id}'),
      headers: <String, String>{'Content-Type' : 'application/json; charset=UTF-8'},
      body: jsonEncode(veterinario.toJson()),
    );
    if(response.statusCode != 200){
      throw Exception('Falha ao atualizar as veterinario');
    }
  }
  Future<void> deletarVeterinario(int id) async{
    final response = await http.delete(Uri.parse('$baseUrl$id'));
    if(response.statusCode == 204){
      print('Veterinario deletado com sucesso');
    }else{
      print('Erro ao deletar veterinario: ${response.statusCode} ${response.body}');
      throw Exception('Falha ao deletar a veterinario');
    }
  }

}