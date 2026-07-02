import 'package:flutter/material.dart';

import '../widgets/feature_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<_ModuleInfo> modules = [
    _ModuleInfo(
      title: 'Género',
      subtitle: 'Predice el género por nombre',
      icon: Icons.wc_rounded,
      route: '/gender',
      color: Color(0xFF457B9D),
    ),
    _ModuleInfo(
      title: 'Edad',
      subtitle: 'Estima la edad por nombre',
      icon: Icons.cake_rounded,
      route: '/age',
      color: Color(0xFFE76F51),
    ),
    _ModuleInfo(
      title: 'Universidades',
      subtitle: 'Busca universidades por país',
      icon: Icons.school_rounded,
      route: '/universities',
      color: Color(0xFF2A9D8F),
    ),
    _ModuleInfo(
      title: 'Clima RD',
      subtitle: 'Consulta el clima actual',
      icon: Icons.cloud_rounded,
      route: '/weather',
      color: Color(0xFF00A6FB),
    ),
    _ModuleInfo(
      title: 'Pokémon',
      subtitle: 'Busca datos y sonido',
      icon: Icons.catching_pokemon_rounded,
      route: '/pokemon',
      color: Color(0xFFFFB703),
    ),
    _ModuleInfo(
      title: 'Noticias',
      subtitle: 'Últimas noticias de Remolacha.net',
      icon: Icons.newspaper_rounded,
      route: '/news',
      color: Color(0xFF6D597A),
    ),
    _ModuleInfo(
      title: 'Acerca de',
      subtitle: 'Perfil profesional',
      icon: Icons.person_rounded,
      route: '/about',
      color: Color(0xFF1D3557),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caja de Herramientas')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 700 ? 3 : 2;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF264653), Color(0xFF2A9D8F)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/toolbox.png',
                            height: 150,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.handyman_rounded,
                                size: 100,
                                color: Colors.white,
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Una app, varias utilidades',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Consulta APIs públicas desde módulos modernos, simples y fáciles de usar.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final module = modules[index];

                      return FeatureCard(
                        title: module.title,
                        subtitle: module.subtitle,
                        icon: module.icon,
                        color: module.color,
                        onTap: () {
                          Navigator.pushNamed(context, module.route);
                        },
                      );
                    }, childCount: modules.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.95,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ModuleInfo {
  _ModuleInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color color;
}
