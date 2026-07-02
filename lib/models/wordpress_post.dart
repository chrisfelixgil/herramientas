class WordPressPost {
  WordPressPost({
    required this.title,
    required this.excerpt,
    required this.link,
  });

  final String title;
  final String excerpt;
  final String link;

  factory WordPressPost.fromJson(Map<String, dynamic> json) {
    return WordPressPost(
      title: _cleanHtml(json['title']?['rendered']),
      excerpt: _cleanHtml(json['excerpt']?['rendered']),
      link: json['link'] ?? '',
    );
  }

  static String _cleanHtml(String? value) {
    if (value == null) return '';

    return value
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&hellip;', '...')
        .replaceAll('&amp;', '&')
        .replaceAll('&#8217;', "'")
        .replaceAll('&#8216;', "'")
        .replaceAll('&#8220;', '"')
        .replaceAll('&#8221;', '"')
        .replaceAll('&#8211;', '-')
        .replaceAll('&#8212;', '-')
        .trim();
  }
}
