class GenderPrediction {
  GenderPrediction({
    required this.name,
    required this.gender,
    required this.probability,
    required this.count,
  });

  final String name;
  final String? gender;
  final double? probability;
  final int count;

  factory GenderPrediction.fromJson(Map<String, dynamic> json) {
    final probability = json['probability'];

    return GenderPrediction(
      name: json['name'] ?? '',
      gender: json['gender'],
      probability: probability is num ? probability.toDouble() : null,
      count: json['count'] ?? 0,
    );
  }
}
