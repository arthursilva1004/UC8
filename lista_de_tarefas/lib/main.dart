import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/tarefas.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda de Tarefas',
      home: Scaffold(
        appBar: AppBar(title: Text("Sistema de Agenda")),
        body: InputExample(),
      ),
    );
  }
}

class InputExample extends StatefulWidget {
  @override
  _InputExampleState createState() => _InputExampleState();
}

class _InputExampleState extends State<InputExample> {
  TextEditingController _controllerListaTarefa = TextEditingController();
  TextEditingController _controllerTarefa = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();
  TextEditingController _controllerHorario = TextEditingController();
  
  List<Map<String, String>> _tarefas = [];

  void _adicionarTarefa(BuildContext context) {
    String tarefasTitle = _controllerListaTarefa.text;
    String tarefa = _controllerTarefa.text;
    String descricao = _controllerDescricao.text;
    String horario = _controllerHorario.text;

    if (tarefasTitle.isEmpty || tarefa.isEmpty || descricao.isEmpty || horario.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos!")),
      );
      return;
    }

    if (_tarefas.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Você só pode adicionar até 5 tarefas!")),
      );
      return;
    }

    setState(() {
      _tarefas.add({
        "tarefa": tarefa,
        "descricao": descricao,
        "horario": horario,
      });
    });

    if (_tarefas.length >= 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Home(
            tarefasTitle: tarefasTitle,
            tarefas: _tarefas,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controllerListaTarefa,
            decoration: InputDecoration(
              labelText: "Nome da Lista de Tarefas",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _controllerTarefa,
            decoration: InputDecoration(
              labelText: "Nome da sua tarefa",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _controllerDescricao,
            decoration: InputDecoration(
              labelText: "Descrição da sua tarefa",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _controllerHorario,
            decoration: InputDecoration(
              labelText: "Horário da sua tarefa",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _adicionarTarefa(context),
            child: Text("Adicionar Tarefa"),
          ),
        ],
      ),
    );
  }
}
