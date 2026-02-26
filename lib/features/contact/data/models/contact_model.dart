class ContactModel {
  final String email;
  final String linkedin;
  final String github;
  final String phone;

  ContactModel({
    required this.email,
    required this.linkedin,
    required this.github,
    required this.phone,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      email: json['email'] ?? '',
      linkedin: json['linkedin'] ?? '',
      github: json['github'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'linkedin': linkedin,
      'github': github,
      'phone': phone,
    };
  }
}
