import 'dart:convert';

class UserModel {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  UserModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "firstName": firstName,
      "lastName": lastName,
    };
  }

  // Convert object to raw JSON string
  String toRawJson() => jsonEncode(toJson());
}
