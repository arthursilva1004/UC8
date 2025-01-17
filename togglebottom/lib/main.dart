import 'package:flutter/material.dart';

const List<String> corNomes = ['blue', 'red', 'yellow'];
const List<Color> corValores = [Colors.blue, Colors.red, Colors.yellow];

void main() => runApp(const ToggleButtonsExampleApp());

class ToggleButtonsExampleApp extends StatelessWidget {
  const ToggleButtonsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const ToggleButtonsSample(title: 'ToggleButtons Sample'),
    );
  }
}

class ToggleButtonsSample extends StatefulWidget {
  const ToggleButtonsSample({super.key, required this.title});

  final String title;

  @override
  State<ToggleButtonsSample> createState() => _ToggleButtonsSampleState();
}

class _ToggleButtonsSampleState extends State<ToggleButtonsSample> {
  final List<bool> _coresSelecionadas = <bool>[true, false, false];
  bool vertical = false;

  void _abrirTelaDeCores(BuildContext context) {
    final List<Color> coresSelecionadas = [];
    for (int i = 0; i < _coresSelecionadas.length; i++) {
      if (_coresSelecionadas[i]) {
        coresSelecionadas.add(corValores[i]);
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoresSelecionadasTela(cores: coresSelecionadas),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Mistura das cores primárias',
                  style: theme.textTheme.titleSmall),
              const SizedBox(height: 50),
              ToggleButtons(
                direction: vertical ? Axis.vertical : Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    _coresSelecionadas[index] = !_coresSelecionadas[index];
                  });
                },
                selectedBorderColor: Colors.green[700],
                selectedColor: Colors.black,
                fillColor: Colors.green[200],
                color: Colors.green[400],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                isSelected: _coresSelecionadas,
                children: corNomes
                    .map((nome) => Text(nome, style: theme.textTheme.bodyLarge))
                    .toList(),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _abrirTelaDeCores(context),
                child: const Text('Exibir cores selecionadas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CoresSelecionadasTela extends StatelessWidget {
  final List<Color> cores;

  const CoresSelecionadasTela({super.key, required this.cores});

  Color _calcularMistura() {
    if (cores.isEmpty) return Colors.white;
    if (cores.length == 1) return cores.first;

    // Calcular a média das cores
    int r = 0, g = 0, b = 0;
    for (final cor in cores) {
      r += cor.red;
      g += cor.green;
      b += cor.blue;
    }
    r ~/= cores.length;
    g ~/= cores.length;
    b ~/= cores.length;

    return Color.fromARGB(255, r, g, b);
  }

  @override
  Widget build(BuildContext context) {
    final Color corFinal = _calcularMistura();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Resultado das cores selecionadas',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: corFinal,
                border: Border.all(color: Colors.black, width: 3),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
