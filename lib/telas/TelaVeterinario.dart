import 'package:flutter/material.dart';
import 'package:petgo/service/VeterinarioService.dart';
import 'package:petgo/model/Veterinario.dart';


class TelaVeterinario extends StatefulWidget {
  @override
  _TelaVeterinarioState createState() => _TelaVeterinarioState();
}

class _TelaVeterinarioState extends State<TelaVeterinario> {
  late Future<List<Veterinario>> _veterinario;
  final VeterinarioService _veterinarioService = VeterinarioService();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _rgController = TextEditingController();
  final TextEditingController _telefone1Controller = TextEditingController();
  final TextEditingController _telefone2Controller = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _numCasaController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _crmvController = TextEditingController();

  Veterinario? _veterinarioAtual;

  @override
  void initState() {
    super.initState();
    _atualizarVeterinario();
  }

  void _atualizarVeterinario() {
    setState(() {
      _veterinario = _veterinarioService.buscarVeterinarios();
    });
  }

  void _mostrarFormulario({Veterinario? veterinario}) {
    if (veterinario != null) {
      _veterinarioAtual = veterinario;
      _nomeController.text = veterinario.nome;
      _crmvController.text = veterinario.crmv;
    } else {
      _veterinarioAtual = null;
      _nomeController.clear();
      _crmvController.clear();
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
              controller: _crmvController,
              decoration: InputDecoration(labelText: 'Crmv'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submeter,
              child: Text(_veterinarioAtual == null ? 'Criar' : 'Atualizar'),
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
    final telefone1 = _telefone1Controller.text;
    final telefone2 = _telefone2Controller.text;
    final logradouro = _logradouroController.text;
    final cep = _cepController.text;
    final uf = _ufController.text;
    final numCasa = _numCasaController.text;
    final cidade = _cidadeController.text;
    final complemento = _complementoController.text;
    final crmv = _crmvController.text;
    if (_veterinarioAtual == null) {
      final novoVeterinario = Veterinario(nome: nome, cpf: cpf, rg: rg, telefone1: telefone1, telefone2: telefone2, logradouro: logradouro, cep: cep, uf: uf, numCasa: numCasa, cidade: cidade, complemento: complemento, crmv: crmv);
      await _veterinarioService.criarVeterinario(novoVeterinario);
    }
    else {
      final veterinarioAtualizado = Veterinario(
        id: _veterinarioAtual!.id,
        nome: nome,
        cpf: cpf,
          rg: rg,
          telefone1: telefone1,
          telefone2: telefone2,
        logradouro: logradouro,
        cep: cep,
        uf: uf,
        numCasa: numCasa,
        cidade: cidade,
        complemento: complemento,
        crmv: crmv,
      );
      await _veterinarioService.atualizarVeterinario(veterinarioAtualizado);
    }

    Navigator.of(context).pop();
    _atualizarVeterinario();
  }

  void _deletarVeterinario(int id) async {
    try {
      await _veterinarioService.deletarVeterinario(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veterinario deletado com sucesso!')));
      _atualizarVeterinario();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Falha ao deletar veterinario: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VETERINARIO'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _mostrarFormulario(),
          ),
        ],
      ),
      body: FutureBuilder<List<Veterinario>>(
        future: _veterinario,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final veterinario = snapshot.data![index];
                return ListTile(
                  title: Text(veterinario.nome),
                  subtitle: Text('R\$${veterinario.crmv}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _mostrarFormulario(veterinario: veterinario),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deletarVeterinario(veterinario.id!),
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
