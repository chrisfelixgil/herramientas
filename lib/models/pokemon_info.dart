class PokemonInfo {
  PokemonInfo({
    required this.name,
    required this.imageUrl,
    required this.baseExperience,
    required this.abilities,
    required this.cryUrl,
  });

  final String name;
  final String imageUrl;
  final int baseExperience;
  final List<String> abilities;
  final String? cryUrl;

  factory PokemonInfo.fromJson(Map<String, dynamic> json) {
    final officialArtwork =
        json['sprites']?['other']?['official-artwork']?['front_default'];

    final fallbackImage = json['sprites']?['front_default'];

    final abilitiesJson = json['abilities'] as List<dynamic>;

    return PokemonInfo(
      name: json['name'] ?? '',
      imageUrl: officialArtwork ?? fallbackImage ?? '',
      baseExperience: json['base_experience'] ?? 0,
      abilities: abilitiesJson
          .map((item) => item['ability']['name'].toString())
          .toList(),
      cryUrl: json['cries']?['latest'] ?? json['cries']?['legacy'],
    );
  }
}
