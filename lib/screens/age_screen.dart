import 'package:flutter/material.dart';

import '../models/age_prediction.dart';
import '../services/api_service.dart';
import '../widgets/result_card.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  final TextEditingController _controller = TextEditingController();
  AgePrediction? _result;
  bool _isLoading = false;
  String? _error;

  Future<void> _searchAge() async {
    final name = _controller.text.trim();

    if (name.isEmpty) {
      setState(() {
        _error = 'Debes escribir un nombre.';
        _result = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final result = await ApiService.predictAge(name);
      setState(() {
        _result = result;
      });
    } catch (error) {
      setState(() {
        _error = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _category(int age) {
    if (age <= 25) return 'Joven';
    if (age <= 59) return 'Adulto';
    return 'Anciano';
  }

  String _imageByAge(int age) {
    if (age <= 25) return 'assets/images/young.png';
    if (age <= 59) return 'assets/images/adult.webp';
    return 'assets/images/elder.png';
  }

  Color _colorByAge(int age) {
    if (age <= 25) return const Color(0xFF2A9D8F);
    if (age <= 59) return const Color(0xFFE76F51);
    return const Color(0xFF6D597A);
  }

  @override
  Widget build(BuildContext context) {
    final age = _result?.age;

    return Scaffold(
      appBar: AppBar(title: const Text('Predicción de edad')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Rangos utilizados: joven de 0 a 25 años, adulto de 26 a 59 años y anciano desde 60 años en adelante.',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              prefixIcon: Icon(Icons.cake_rounded),
            ),
            onSubmitted: (_) => _searchAge(),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _searchAge,
            icon: const Icon(Icons.search_rounded),
            label: const Text('Consultar edad'),
          ),
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            ResultCard(
              child: Text(
                _error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else if (_result != null && age == null)
            const ResultCard(
              child: Text(
                'La API no pudo estimar una edad para este nombre.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          else if (_result != null && age != null)
            ResultCard(
              child: Column(
                children: [
                  Image.asset(
                    _imageByAge(age),
                    height: 150,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person_rounded,
                        size: 120,
                        color: _colorByAge(age),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _result!.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$age años',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: _colorByAge(age),
                    ),
                  ),
                  Text(
                    'Esta persona parece ser ${_category(age).toLowerCase()}.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Registros analizados: ${_result!.count}',
                    style: const TextStyle(color: Color(0xFF6C757D)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
