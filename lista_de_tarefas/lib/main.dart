import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'tarefas.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda de Tarefas',
      home: ListaDeTarefasScreen(),
    );
  }
}

class ListaDeTarefasScreen extends StatefulWidget {
  @override
  _ListaDeTarefasScreenState createState() => _ListaDeTarefasScreenState();
}

class _ListaDeTarefasScreenState extends State<ListaDeTarefasScreen> {
  List<Map<String, dynamic>> _listasDeTarefas = [];
  TextEditingController _nomeListaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarListas();
  }

  Future<void> _carregarListas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dados = prefs.getString("listasDeTarefas");
    if (dados != null) {
      setState(() {
        _listasDeTarefas = List<Map<String, dynamic>>.from(json.decode(dados));
      });
    }
  }

  Future<void> _salvarListas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("listasDeTarefas", json.encode(_listasDeTarefas));
  }

  void _adicionarLista() {
    if (_nomeListaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Digite um nome para a lista!")),
      );
      return;
    }
    setState(() {
      _listasDeTarefas.add({
        "nome": _nomeListaController.text,
        "tarefas": [],
      });
      _nomeListaController.clear();
    });
    _salvarListas();
  }

  void _excluirLista(int index) {
    setState(() {
      _listasDeTarefas.removeAt(index);
    });
    _salvarListas();
  }

  void _editarLista(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TarefasScreen(
          nomeLista: _listasDeTarefas[index]["nome"],
          tarefas: List<Map<String, dynamic>>.from(
              _listasDeTarefas[index]["tarefas"]),
          salvarTarefas: (List<Map<String, dynamic>> tarefasAtualizadas) {
            setState(() {
              _listasDeTarefas[index]["tarefas"] = tarefasAtualizadas;
            });
            _salvarListas();
          },
          excluirLista: () {
            _excluirLista(index);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sistema de Agenda")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeListaController,
              decoration: InputDecoration(
                labelText: "Nome da Lista",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _adicionarLista,
              child: Text("Adicionar Lista"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _listasDeTarefas.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_listasDeTarefas[index]["nome"]),
                      onTap: () => _editarLista(index),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _excluirLista(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
