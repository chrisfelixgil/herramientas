import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/age_prediction.dart';
import '../models/gender_prediction.dart';
import '../models/pokemon_info.dart';
import '../models/university.dart';
import '../models/weather_info.dart';
import '../models/wordpress_post.dart';

class ApiService {
  static const Duration _timeout = Duration(seconds: 12);

  static Future<dynamic> _getJson(Uri uri) async {
    try {
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      if (response.statusCode == 404) {
        throw Exception('No se encontró información para la búsqueda.');
      }

      if (response.statusCode == 429) {
        throw Exception(
          'La API alcanzó su límite de consultas. Espera unos minutos e intenta de nuevo.',
        );
      }

      throw Exception('Error del servidor. Código: ${response.statusCode}');
    } on TimeoutException {
      throw Exception('La solicitud tardó demasiado. Revisa tu conexión.');
    } on FormatException {
      throw Exception('La respuesta recibida no tiene un formato válido.');
    } on Exception {
      rethrow;
    } catch (error) {
      if (kIsWeb) {
        throw Exception(
          'No se pudo conectar desde el navegador. Algunas APIs bloquean peticiones web (CORS). Prueba con Windows o Android: flutter run -d windows',
        );
      }

      throw Exception('No se pudo conectar con el servicio. ($error)');
    }
  }

  static Future<GenderPrediction> predictGender(String name) async {
    final uri = Uri.https('api.genderize.io', '/', {'name': name});
    final data = await _getJson(uri);
    return GenderPrediction.fromJson(data);
  }

  static Future<AgePrediction> predictAge(String name) async {
    final uri = Uri.https('api.agify.io', '/', {'name': name});
    final data = await _getJson(uri);
    return AgePrediction.fromJson(data);
  }

  static Future<List<University>> getUniversities(String country) async {
    // adamix.net/proxy.php suele estar caído; Hipolabs es la API original del curso.
    final uri = Uri.http('universities.hipolabs.com', '/search', {
      'country': country,
    });
    final data = await _getJson(uri);

    return (data as List).map((item) => University.fromJson(item)).toList();
  }

  static Future<WeatherInfo> getDominicanWeather() async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '18.4861',
      'longitude': '-69.9312',
      'current': 'temperature_2m,apparent_temperature,weather_code,is_day',
      'timezone': 'America/Santo_Domingo',
    });

    final data = await _getJson(uri);
    return WeatherInfo.fromJson(data);
  }

  static Future<PokemonInfo> getPokemon(String pokemonName) async {
    final cleanName = pokemonName.trim().toLowerCase();
    final uri = Uri.https('pokeapi.co', '/api/v2/pokemon/$cleanName');
    final data = await _getJson(uri);

    return PokemonInfo.fromJson(data);
  }

  static Future<List<WordPressPost>> getLatestPosts(String baseUrl) async {
    final cleanBaseUrl = baseUrl.replaceAll(RegExp(r'/+$'), '');
    final uri = Uri.parse(
      '$cleanBaseUrl/wp-json/wp/v2/posts?per_page=3&_fields=title,excerpt,link',
    );

    final data = await _getJson(uri);

    return (data as List).map((item) => WordPressPost.fromJson(item)).toList();
  }
}
