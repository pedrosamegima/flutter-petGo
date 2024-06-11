import 'package:flutter/material.dart';
import 'package:petgo/service/ConsultaService.dart';
import 'package:petgo/model/Consulta.dart';


class TelaConsulta extends StatefulWidget {
  @override
  _TelaConsultaState createState() => _TelaConsultaState();
}

class _TelaConsultaState extends State<TelaConsulta> {
  late Future<List<Consulta>> _consulta;
  final ConsultaService _consultaService = ConsultaService();

  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  Consulta? _consultaAtual;

  @override
  void initState() {
    super.initState();
    _atualizarConsultas();
  }

  void _atualizarConsultas() {
    setState(() {
      _consulta = _consultaService.buscarConsultas();
    });
  }

  void _mostrarFormulario({Consulta? consulta}) {
    if (consulta != null) {
      _consultaAtual = consulta;
      _dataController.text = consulta.data;
      _horaController.text = consulta.hora;
      _descricaoController.text = consulta.descricao;
    } else {
      _consultaAtual = null;
      _dataController.clear();
      _horaController.clear();
      _descricaoController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _dataController,
              decoration: InputDecoration(labelText: 'data'),
            ),
            TextField(
              controller: _horaController,
              decoration: InputDecoration(labelText: 'hora'),
            ),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'descrição'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submeter,
              child: Text(_consultaAtual == null ? 'Criar' : 'Atualizar'),
            ),
          ],
        ),
      ),
    );
  }

  void _submeter() async {
    final data = _dataController.text;
    final hora = _horaController.text;
    final descricao= _descricaoController.text;

    if (_consultaAtual == null) {
      final novoConsulta = Consulta(data: data, hora: hora, descricao: descricao);
      await _consultaService.criarConsulta(novoConsulta);
    }
    else {
      final consultaAtualizado = Consulta(
        id: _consultaAtual!.id,
        data: data,
        hora: hora,
        descricao: descricao,
      );
      await _consultaService.atualizarConsulta(consultaAtualizado);
    }

    Navigator.of(context).pop();
    _atualizarConsultas();
  }

  void _deletarConsulta(int id) async {
    try {
      await _consultaService.deletarConsulta(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Consulta deletado com sucesso!')));
      _atualizarConsultas();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Falha ao deletar a consulta: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CONSULTA'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _mostrarFormulario(),
          ),
        ],
      ),
      body: FutureBuilder<List<Consulta>>(
        future: _consulta,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final consulta = snapshot.data![index];
                return ListTile(
                  title: Text(consulta.data),
                  subtitle: Text(consulta.hora),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _mostrarFormulario(consulta: consulta),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deletarConsulta(consulta.id!),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}