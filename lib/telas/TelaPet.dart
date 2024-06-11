import 'package:flutter/material.dart';
import 'package:petgo/service/PetService.dart';
import 'package:petgo/model/Pet.dart';


class TelaPet extends StatefulWidget {
  @override
  _TelaPetState createState() => _TelaPetState();
}

class _TelaPetState extends State<TelaPet> {
  late Future<List<Pet>> _pet;
  final PetService _petService = PetService();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataNascController = TextEditingController();
  final TextEditingController _NumDocController = TextEditingController();
  final TextEditingController _racaController = TextEditingController();
  final TextEditingController _corController = TextEditingController();
  Pet? _petAtual;

  @override
  void initState() {
    super.initState();
    _atualizarPet();
  }

  void _atualizarPet() {
    setState(() {
      _pet = _petService.buscarPets();
    });
  }

  void _mostrarFormulario({Pet? pet}) {
    if (pet != null) {
      _petAtual = pet;
      _nomeController.text = pet.nome;
      _dataNascController.text = pet.dataNasc;
      _NumDocController.text = pet.NumDoc;
      _racaController.text = pet.raca;
      _corController.text = pet.cor;
    } else {
      _petAtual = null;
      _nomeController.clear();
      _dataNascController.clear();
      _NumDocController.clear();
      _racaController.clear();
      _corController.clear();
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
              controller: _dataNascController,
              decoration: InputDecoration(labelText: 'Data de nascimento'),
            ),
            TextField(
              controller: _NumDocController,
              decoration: InputDecoration(labelText: 'Numero do documento'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _racaController,
              decoration: InputDecoration(labelText: 'Raça do pet'),
            ),
            TextField(
              controller: _corController,
              decoration: InputDecoration(labelText: 'Cor do pet'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submeter,
              child: Text(_petAtual == null ? 'Criar' : 'Atualizar'),
            ),
          ],
        ),
      ),
    );
  }

  void _submeter() async {
    final nome = _nomeController.text;
    final dataNasc = _dataNascController.text;
    final NumDoc = _NumDocController.text;
    final raca = _racaController.text;
    final cor = _corController.text;

    if (_petAtual == null) {
      final novoPet = Pet(nome: nome, dataNasc: dataNasc, NumDoc: NumDoc, raca: raca, cor: cor);
      await _petService.criarPet(novoPet);
    }
    else {
      final petAtualizado = Pet(
        id: _petAtual!.id,
        nome: nome,
        dataNasc: dataNasc,
        NumDoc: NumDoc,
        raca: raca,
        cor: cor,
      );
      await _petService.atualizarPet(petAtualizado);
    }

    Navigator.of(context).pop();
    _atualizarPet();
  }

  void _deletarPet(int id) async {
    try {
      await _petService.deletarPet(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pet deletado com sucesso!')));
      _atualizarPet();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Falha ao deletar pet: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PET'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _mostrarFormulario(),
          ),
        ],
      ),
      body: FutureBuilder<List<Pet>>(
        future: _pet,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pet = snapshot.data![index];
                return ListTile(
                  title: Text(pet.nome),
                  subtitle: Text('pet.NumDoc'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _mostrarFormulario(pet: pet),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deletarPet(pet.id!),
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