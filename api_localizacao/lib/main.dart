import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const FormExampleApp());

class FormExampleApp extends StatelessWidget {
  const FormExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Localizador')),
        body: const FormExample(),
      ),
    );
  }
}

class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();
  LatLng? _coordinates;

  Future<void> _searchLocation() async {
    final query = _locationController.text;
    if (query.isEmpty) return;

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);
        setState(() {
          _coordinates = LatLng(lat, lon);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: 'Coloque sua localização',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira alguma localização';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _searchLocation();
                    }
                  },
                  child: const Text('Procurar'),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: _coordinates ?? LatLng(0, 0),
              initialZoom: _coordinates != null ? 15 : 2,
            ),

            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              if (_coordinates != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _coordinates!,
                      width: 80.0,
                      height: 80.0,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),

                  ],
                )

            ],
          ),
        ),
      ],
    );
  }
}
