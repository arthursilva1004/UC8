import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _message = 'Clique para receber uma nova mensagem !';

  List<String> messages = [
    "Bem vindo !",
    "Tudo bem ?",
    "Boas Vindas !",
    "Saudações !",
    "Como vai ?"
  ];

  void _generateText() {
    int i = Random().nextInt(messages.length);

    setState(() {
      this._message = messages[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frase Aleatória'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset(
                "images/title.png",
                fit: BoxFit.fill,
                scale: 1.5,
                width: 250,
              ),
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  _message,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: ElevatedButton(
                  onPressed: () => _generateText(),
                  child: Text(
                    "Nova Frase",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
