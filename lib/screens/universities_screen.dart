import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/university.dart';
import '../services/api_service.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  final TextEditingController _controller = TextEditingController(
    text: 'Dominican Republic',
  );

  List<University> _universities = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _searchUniversities() async {
    final country = _controller.text.trim();

    if (country.isEmpty) {
      setState(() {
        _error = 'Debes escribir el país en inglés.';
        _universities = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _universities = [];
    });

    try {
      final result = await ApiService.getUniversities(country);

      setState(() {
        _universities = result;
        if (result.isEmpty) {
          _error =
              'No se encontraron universidades. Revisa el nombre del país.';
        }
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

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void initState() {
    super.initState();
    _searchUniversities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universidades por país')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Escribe el nombre del país en inglés. Ejemplo: Dominican Republic, Mexico, Spain o United States.',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              labelText: 'País en inglés',
              prefixIcon: Icon(Icons.public_rounded),
            ),
            onSubmitted: (_) => _searchUniversities(),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _searchUniversities,
            icon: const Icon(Icons.search_rounded),
            label: const Text('Buscar universidades'),
          ),
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Text(
              _error!,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 12),
          ..._universities.map((university) {
            final domain = university.domains.isNotEmpty
                ? university.domains.first
                : 'Sin dominio';

            final webPage = university.webPages.isNotEmpty
                ? university.webPages.first
                : '';

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE6EAF0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.school_rounded,
                    color: Color(0xFF2A9D8F),
                    size: 34,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    university.name,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1D3557),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    university.country,
                    style: const TextStyle(color: Color(0xFF6C757D)),
                  ),
                  const SizedBox(height: 10),
                  Chip(
                    label: Text(domain),
                    avatar: const Icon(Icons.language_rounded, size: 18),
                  ),
                  const SizedBox(height: 12),
                  if (webPage.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () => _openUrl(webPage),
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: const Text('Visitar página web'),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
