import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Frases Aleatórias',
      home: Scaffold(
        appBar: AppBar(title: Text("Input em Variável")),
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
  TextEditingController _controller = TextEditingController();
  String nome = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "Digite algo",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                nome = _controller.text;
              });
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Home(nome: nome)));
            },
            child: Text("Salvar"),
          ),
          SizedBox(height: 16),
          Text(
            "Texto digitado: $nome",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  final String nome;

  Home({required this.nome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Página Home")),
      body: Center(
        child: Text(
          "Olá, $nome!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
