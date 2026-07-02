class AgePrediction {
  AgePrediction({required this.name, required this.age, required this.count});

  final String name;
  final int? age;
  final int count;

  factory AgePrediction.fromJson(Map<String, dynamic> json) {
    return AgePrediction(
      name: json['name'] ?? '',
      age: json['age'],
      count: json['count'] ?? 0,
    );
  }
}
