class ExperienceModel {
  final String company;
  final String role;
  final String duration;
  final String description;

  ExperienceModel({
    required this.company,
    required this.role,
    required this.duration,
    required this.description,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      company: json['company'] ?? '',
      role: json['role'] ?? '',
      duration: json['duration'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'role': role,
      'duration': duration,
      'description': description,
    };
  }
}
