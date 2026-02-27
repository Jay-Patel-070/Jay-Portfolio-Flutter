class UserModel {
  final String name;
  final String title;
  final String bio;
  final String profileImage;
  final String resumeLink;

  UserModel({
    required this.name,
    required this.title,
    required this.bio,
    required this.profileImage,
    required this.resumeLink,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      bio: json['bio'] ?? '',
      profileImage: json['profileImage'] ?? '',
      resumeLink: json['resumeLink'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'bio': bio,
      'profileImage': profileImage,
      'resumeLink': resumeLink,
    };
  }
}
