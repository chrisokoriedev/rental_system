import 'dart:convert';

class AuthProfileModel {
  const AuthProfileModel({
    required this.fullName,
    required this.email,
  });

  final String fullName;
  final String email;

  String get initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return 'GU';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
    };
  }

  String toEncodedJson() => jsonEncode(toJson());

  factory AuthProfileModel.fromJson(Map<String, dynamic> json) {
    return AuthProfileModel(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
    );
  }

  factory AuthProfileModel.fromEncodedJson(String source) {
    return AuthProfileModel.fromJson(jsonDecode(source) as Map<String, dynamic>);
  }
}