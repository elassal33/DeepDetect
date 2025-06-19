import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://159.89.10.1:8080/api/v1/users/profile";

  Future<dynamic> fetchUserData(String token) async {
    final Uri url = Uri.parse(baseUrl);

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("API Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        return {"error": "Unauthorized - Invalid token", "status": 401};
      } else if (response.statusCode == 500) {
        return {"error": "Server Error - Try again later", "status": 500};
      } else {
        return {"error": "Unexpected Error", "status": response.statusCode};
      }
    } catch (e) {
      return {"error": "Exception: $e"};
    }
  }
}
