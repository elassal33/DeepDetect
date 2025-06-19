import 'dart:convert';
import 'package:grad_project/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://159.89.10.1:8080/api/v1/auth";

  Future<String> signUp(UserModel user) async {
    final Uri url = Uri.parse('$baseUrl/signup');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: user.toRawJson(), // Convert user data to JSON string
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return "Signup successful!";
      } else {
        return "Signup failed: ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
