import 'package:flutter/material.dart';

class ContactFormModel {
  final String name;
  final String email;
  final String subject;
  final String message;

  ContactFormModel({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
