import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_model.dart';

class ApiService {
  final Uri url = Uri.parse("http://159.89.10.1:8080/api/v1/auth/login");


  Future<String?> login(LoginRequest loginRequest) async {


    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(loginRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['token']; 
      
      } else {
        print("Login failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
