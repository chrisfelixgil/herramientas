import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/wordpress_post.dart';
import '../services/api_service.dart';

class WordPressNewsScreen extends StatefulWidget {
  const WordPressNewsScreen({super.key});

  @override
  State<WordPressNewsScreen> createState() => _WordPressNewsScreenState();
}

class _WordPressNewsScreenState extends State<WordPressNewsScreen> {
  static const String _remolachaUrl = 'https://remolacha.net';

  List<WordPressPost> _posts = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _posts = [];
    });

    try {
      final result = await ApiService.getLatestPosts(_remolachaUrl);

      setState(() {
        _posts = result;
        if (result.isEmpty) {
          _error = 'No se encontraron noticias en Remolacha.';
        }
      });
    } catch (error) {
      setState(() {
        _error =
            'No se pudieron cargar las noticias de Remolacha. Verifica tu conexión o si la API REST está disponible.';
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
    _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias Remolacha')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Image.asset(
              'assets/images/wp_news.png',
              height: 70,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ClipOval(
              child: Image.asset(
                'assets/images/remolacha.png',
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Últimas noticias de Remolacha.net consumidas desde la WordPress REST API (/wp-json/wp/v2/posts).',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.4),
          ),
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ..._posts.map(
            (post) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.article_rounded,
                    color: Color(0xFF21759B),
                    size: 34,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1D3557),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    post.excerpt,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF6C757D),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () => _openUrl(post.link),
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: const Text('Visitar noticia'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
