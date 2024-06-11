import 'package:flutter/material.dart';
import 'package:petgo/service/ProprietarioService.dart';
import 'package:petgo/model/Proprietario.dart';


class TelaProprietario extends StatefulWidget {
  @override
  _TelaProprietarioState createState() => _TelaProprietarioState();
}

class _TelaProprietarioState extends State<TelaProprietario> {
  late Future<List<Proprietario>> _proprietario;
  final ProprietarioService _proprietarioService = ProprietarioService();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _rgController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _numCasaController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _telefone1Controller = TextEditingController();
  final TextEditingController _telefone2Controller = TextEditingController();

  Proprietario? _proprietarioAtual;

  @override
  void initState() {
    super.initState();
    _atualizarProprietario();
  }

  void _atualizarProprietario() {
    setState(() {
      _proprietario = _proprietarioService.buscarProprietarios();
    });
  }

  void _mostrarFormulario({Proprietario? proprietario}) {
    if (proprietario != null) {
      _proprietarioAtual = proprietario;
      _nomeController.text = proprietario.nome;
      _cpfController.text = proprietario.cpf;
      _rgController.text = proprietario.rg;
      _logradouroController.text = proprietario.logradouro;
      _cepController.text = proprietario.cep;
      _ufController.text = proprietario.uf;
      _numCasaController.text = proprietario.numCasa;
      _complementoController.text = proprietario.complemento;
      _cidadeController.text = proprietario.cidade;
      _telefone1Controller.text = proprietario.telefone1;
      _telefone2Controller.text = proprietario.telefone2;
    } else {
      _proprietarioAtual = null;
      _nomeController.clear();
      _cpfController.clear();
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
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _cpfController,
              decoration: InputDecoration(labelText: 'Cpf'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submeter,
              child: Text(_proprietarioAtual == null ? 'Criar' : 'Atualizar'),
            ),
          ],
        ),
      ),
    );
  }

  void _submeter() async {
    final nome = _nomeController.text;
    final cpf = _cpfController.text;
    final rg = _rgController.text;
    final logradouro = _logradouroController.text;
    final cep = _cepController.text;
    final uf = _ufController.text;
    final numCasa = _numCasaController.text;
    final complemento = _complementoController.text;
    final cidade = _cidadeController.text;
    final telefone1 = _telefone1Controller.text;
    final telefone2 = _telefone2Controller.text;

    if (_proprietarioAtual == null) {
      final novoProprietario = Proprietario(nome: nome, cpf: cpf, rg: rg, logradouro: logradouro, cep: cep,
        uf: uf, numCasa: numCasa, complemento: complemento, cidade: cidade, telefone1: telefone1, telefone2: telefone2
      );
      await _proprietarioService.criarProprietario(novoProprietario);
    }
    else {
      final proprietarioAtualizado = Proprietario(
        id: _proprietarioAtual!.id,
        nome: nome,
        cpf: cpf,
        rg: rg,
        logradouro: logradouro,
        cep: cep,
        uf: uf,
        numCasa: numCasa,
        complemento: complemento,
        cidade: cidade,
        telefone1: telefone1,
        telefone2: telefone2,
      );
      await _proprietarioService.atualizarProprietario(proprietarioAtualizado);
    }

    Navigator.of(context).pop();
    _atualizarProprietario();
  }

  void _deletarProprietario(int id) async {
    try {
      await _proprietarioService.deletarProprietario(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Proprietario deletado com sucesso!')));
      _atualizarProprietario();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Falha ao deletar proprietario: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PROPRIETARIOS'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _mostrarFormulario(),
          ),
        ],
      ),
      body: FutureBuilder<List<Proprietario>>(
        future: _proprietario,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final proprietario = snapshot.data![index];
                return ListTile(
                  title: Text(proprietario.nome),
                  subtitle: Text('R\$${proprietario.cpf}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _mostrarFormulario(proprietario: proprietario),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deletarProprietario(proprietario.id!),
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