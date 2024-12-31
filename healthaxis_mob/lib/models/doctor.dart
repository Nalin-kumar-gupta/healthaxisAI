class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String imageUrl;
  final double reviewScore;
  final double totalScore;
  final double satisfaction;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.imageUrl,
    required this.reviewScore,
    required this.totalScore,
    required this.satisfaction,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      imageUrl: json['imageUrl'],
      reviewScore: json['reviewScore'],
      totalScore: json['totalScore'],
      satisfaction: json['satisfaction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'imageUrl': imageUrl,
      'reviewScore': reviewScore,
      'totalScore': totalScore,
      'satisfaction': satisfaction,
    };
  }
}
