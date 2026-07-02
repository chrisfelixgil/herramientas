import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String fullName = 'Christian Gil';
  static const String email = '20121036@itla.edu.do';
  static const String githubUrl = 'https://github.com/chrisfelixgil';
  static const String linkedInUrl =
      'https://www.linkedin.com/in/christianfgilc/';

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Contacto desde la aplicación Caja de Herramientas',
      },
    );

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1D3557), Color(0xFF457B9D)],
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 72,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 68,
                    backgroundImage: const AssetImage(
                      'assets/images/perfil.jpg',
                    ),
                    onBackgroundImageError: (_, __) {},
                    child: const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  fullName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Desarrollador en formación, analista de sistemas y entusiasta de la creación de soluciones móviles modernas, funcionales y bien organizadas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _ContactButton(
            icon: Icons.email_rounded,
            title: 'Correo institucional',
            subtitle: email,
            onTap: _openEmail,
          ),
          _ContactButton(
            icon: Icons.code_rounded,
            title: 'GitHub',
            subtitle: 'Ver repositorios y proyectos',
            onTap: () => _openUrl(githubUrl),
          ),
          _ContactButton(
            icon: Icons.business_center_rounded,
            title: 'LinkedIn',
            subtitle: 'Ver perfil profesional',
            onTap: () => _openUrl(linkedInUrl),
          ),
        ],
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        onTap: onTap,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2A9D8F).withOpacity(0.14),
          child: Icon(icon, color: const Color(0xFF2A9D8F)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.open_in_new_rounded),
      ),
    );
  }
}
