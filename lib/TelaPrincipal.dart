import 'package:flutter/material.dart';
import 'package:petgo/telas/TelaConsulta.dart';
import 'package:petgo/telas/TelaEspecialidade.dart';
import 'package:petgo/telas/TelaProprietario.dart';
import 'package:petgo/telas/TelaTipo.dart';
import 'package:petgo/telas/TelaVeterinario.dart';
import 'package:petgo/telas/TelaPet.dart';

class TelaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veterinaria PetGo'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.cyan,
              ),
              child: Text(
                'Menu Principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Consulta'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TelaConsulta()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Especialidade'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TelaEspecialidade()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Pet'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TelaPet()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Proprietario'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TelaProprietario()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Tipo'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TelaTipo()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Veterinario'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TelaVeterinario()),
                );
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Text('Bem-vindo à Tela Principal!',
            style: TextStyle(color: Colors.blueGrey,fontSize: 20,)
        ),
      ),
    );
  }
}