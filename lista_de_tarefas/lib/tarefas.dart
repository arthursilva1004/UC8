import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String tarefasTitle;
  final List<Map<String, String>> tarefas;

  const Home({
    super.key,
    required this.tarefasTitle,
    required this.tarefas,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Map<String, dynamic>> _tarefas;
  final int _limiteTarefas = 5;
  final int _minimoTarefas = 2;

  @override
  void initState() {
    super.initState();
    _tarefas = widget.tarefas.map((tarefa) => {
          "tarefa": tarefa["tarefa"],
          "descricao": tarefa["descricao"],
          "horario": tarefa["horario"],
          "feito": false,
        }).toList();
  }

  void _removerTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
    });

    if (_tarefas.length < _minimoTarefas) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Você deve ter pelo menos $_minimoTarefas tarefas!")),
      );
    }
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
        title: Text(widget.tarefasTitle),
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
