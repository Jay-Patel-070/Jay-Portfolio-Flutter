class SkillModel {
  final String skillName;
  final String iconUrl;
  final double proficiency;
  final String category;

  SkillModel({
    required this.skillName,
    required this.iconUrl,
    required this.proficiency,
    required this.category,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      skillName: json['skillName'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
      proficiency: (json['proficiency'] ?? 0.0).toDouble(),
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skillName': skillName,
      'iconUrl': iconUrl,
      'proficiency': proficiency,
      'category': category,
    };
  }
}
