import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String tarefasTitle;
  final String tarefa;
  final String descricao;
  final String horario;

  const Home({
    super.key,
    required this.tarefasTitle,
    required this.tarefa,
    required this.descricao,
    required this.horario,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> _tarefas = [];
  final int _limiteTarefas = 5;
  final int _minimoTarefas = 2;

  @override
  void initState() {
    super.initState();
    _adicionarTarefa(widget.tarefa, widget.descricao, widget.horario);
  }

  void _adicionarTarefa(String tarefa, String descricao, String horario) {
    if (_minimoTarefas < _tarefas.length || _tarefas.length < _limiteTarefas) {
      setState(() {
        _tarefas.add({
          "tarefa": tarefa,
          "descricao": descricao,
          "horario": horario,
          "feito": false,
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Limite de $_limiteTarefas tarefas atingido!")),
      );
    }
  }

  void _removerTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
    });
  }

  void _marcarFeito(int index, bool? value) {
    setState(() {
      _tarefas[index]["feito"] = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('{_tarefasTitle}'),
        backgroundColor: Color.fromARGB(255, 124, 196, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, index) {
                  final tarefa = _tarefas[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        tarefa['tarefa']!,
                        style: TextStyle(
                          decoration: tarefa['feito']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        "Descrição: ${tarefa['descricao']} - Horário: ${tarefa['horario']}",
                      ),
                      leading: Checkbox(
                        value: tarefa['feito'],
                        onChanged: (value) => _marcarFeito(index, value),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removerTarefa(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_tarefas.isEmpty)
              Text(
                "Nenhuma tarefa cadastrada.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
