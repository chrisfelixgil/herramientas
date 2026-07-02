import 'package:flutter/material.dart';

import '../models/gender_prediction.dart';
import '../services/api_service.dart';
import '../widgets/result_card.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final TextEditingController _controller = TextEditingController();
  GenderPrediction? _result;
  bool _isLoading = false;
  String? _error;

  Future<void> _searchGender() async {
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
      final result = await ApiService.predictGender(name);
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

  Color get _mainColor {
    if (_result?.gender == 'male') return const Color(0xFF2196F3);
    if (_result?.gender == 'female') return const Color(0xFFE91E63);
    return const Color(0xFF6C757D);
  }

  IconData get _genderIcon {
    if (_result?.gender == 'female') return Icons.female_rounded;
    if (_result?.gender == 'male') return Icons.male_rounded;
    return Icons.person_rounded;
  }

  String get _genderText {
    if (_result?.gender == 'male') return 'Masculino';
    if (_result?.gender == 'female') return 'Femenino';
    return 'No determinado';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Predicción de género')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _mainColor.withValues(alpha: 0.15),
              const Color(0xFFF5F7FB),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Escribe un nombre y la app intentará predecir el género.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                prefixIcon: Icon(Icons.person_search_rounded),
              ),
              onSubmitted: (_) => _searchGender(),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _searchGender,
              icon: const Icon(Icons.search_rounded),
              label: const Text('Consultar género'),
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
            else if (_result != null)
              ResultCard(
                color: Colors.white,
                child: Column(
                  children: [
                    Icon(_genderIcon, size: 110, color: _mainColor),
                    const SizedBox(height: 14),
                    Text(
                      _result!.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: _mainColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _genderText,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _result!.probability == null
                          ? 'La API no pudo determinar una probabilidad.'
                          : 'Probabilidad: ${(_result!.probability! * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Color(0xFF6C757D),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Registros analizados: ${_result!.count}',
                      style: const TextStyle(color: Color(0xFF6C757D)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
