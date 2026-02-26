class ProjectModel {
  final String title;
  final String description;
  final List<String> techStack;
  final String githubUrl;
  final String liveUrl;
  final List<String> images;
  final bool featured;

  ProjectModel({
    required this.title,
    required this.description,
    required this.techStack,
    required this.githubUrl,
    required this.liveUrl,
    required this.images,
    required this.featured,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      techStack: List<String>.from(json['techStack'] ?? []),
      githubUrl: json['githubUrl'] ?? '',
      liveUrl: json['liveUrl'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      featured: json['featured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'techStack': techStack,
      'githubUrl': githubUrl,
      'liveUrl': liveUrl,
      'images': images,
      'featured': featured,
    };
  }
}
