class AchievementModel {
  final String title;
  final String description;
  final String date;

  AchievementModel({
    required this.title,
    required this.description,
    required this.date,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
    };
  }
}
