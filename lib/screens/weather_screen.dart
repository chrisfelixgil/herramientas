import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_info.dart';
import '../services/api_service.dart';
import '../widgets/result_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherInfo? _weather;
  bool _isLoading = false;
  String? _error;

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await ApiService.getDominicanWeather();
      setState(() {
        _weather = result;
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

  IconData _weatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny_rounded;
    if ([1, 2, 3].contains(code)) return Icons.cloud_queue_rounded;
    if ([45, 48].contains(code)) return Icons.foggy;
    if ([61, 63, 65, 80, 81, 82].contains(code)) {
      return Icons.water_drop_rounded;
    }
    if ([95, 96, 99].contains(code)) return Icons.thunderstorm_rounded;

    return Icons.cloud_rounded;
  }

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('EEEE, d MMMM yyyy', 'es').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('Clima en RD')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Consulta del clima actual en República Dominicana usando Santo Domingo como referencia.',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _loadWeather,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Actualizar clima'),
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
          else if (_weather != null)
            ResultCard(
              color: const Color(0xFFE3F2FD),
              child: Column(
                children: [
                  Icon(
                    _weatherIcon(_weather!.weatherCode),
                    size: 120,
                    color: const Color(0xFF0288D1),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    date,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF6C757D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_weather!.temperature.toStringAsFixed(1)} °C',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF01579B),
                    ),
                  ),
                  Text(
                    _weather!.description,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sensación térmica: ${_weather!.apparentTemperature.toStringAsFixed(1)} °C',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _weather!.friendlyMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF455A64),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
