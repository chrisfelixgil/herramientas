import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/about_screen.dart';
import 'screens/age_screen.dart';
import 'screens/gender_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pokemon_screen.dart';
import 'screens/universities_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/wordpress_news_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
  runApp(const ToolboxApp());
}

class ToolboxApp extends StatelessWidget {
  const ToolboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caja de Herramientas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/gender': (context) => const GenderScreen(),
        '/age': (context) => const AgeScreen(),
        '/universities': (context) => const UniversitiesScreen(),
        '/weather': (context) => const WeatherScreen(),
        '/pokemon': (context) => const PokemonScreen(),
        '/news': (context) => const WordPressNewsScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}
