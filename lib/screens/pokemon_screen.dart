import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../models/pokemon_info.dart';
import '../services/api_service.dart';
import '../widgets/result_card.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final TextEditingController _controller = TextEditingController(
    text: 'pikachu',
  );

  final AudioPlayer _audioPlayer = AudioPlayer();

  PokemonInfo? _pokemon;
  bool _isLoading = false;
  String? _error;

  Future<void> _searchPokemon() async {
    final name = _controller.text.trim();

    if (name.isEmpty) {
      setState(() {
        _error = 'Debes escribir el nombre de un Pokémon.';
        _pokemon = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _pokemon = null;
    });

    try {
      final result = await ApiService.getPokemon(name);
      setState(() {
        _pokemon = result;
      });
    } catch (error) {
      setState(() {
        _error = 'No se encontró ese Pokémon. Revisa el nombre.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _playCry() async {
    final cryUrl = _pokemon?.cryUrl;

    if (cryUrl == null || cryUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este Pokémon no tiene sonido disponible.'),
        ),
      );
      return;
    }

    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(cryUrl));
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  void initState() {
    super.initState();
    _searchPokemon();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7D6),
      appBar: AppBar(
        title: const Text('Pokémon'),
        backgroundColor: const Color(0xFFFFF7D6),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              labelText: 'Nombre del Pokémon',
              prefixIcon: Icon(Icons.catching_pokemon_rounded),
            ),
            onSubmitted: (_) => _searchPokemon(),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _searchPokemon,
            icon: const Icon(Icons.search_rounded),
            label: const Text('Buscar Pokémon'),
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
          else if (_pokemon != null)
            ResultCard(
              color: Colors.white,
              child: Column(
                children: [
                  Image.network(
                    _pokemon!.imageUrl,
                    height: 190,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.catching_pokemon_rounded,
                        size: 120,
                        color: Colors.red,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _capitalize(_pokemon!.name),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFD62828),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Experiencia base: ${_pokemon!.baseExperience}',
                    style: const TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Habilidades',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _pokemon!.abilities.map((ability) {
                      return Chip(
                        label: Text(_capitalize(ability)),
                        avatar: const Icon(Icons.flash_on_rounded, size: 18),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _playCry,
                    icon: const Icon(Icons.volume_up_rounded),
                    label: const Text('Reproducir sonido'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
