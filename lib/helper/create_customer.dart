import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'package:grad_project/models/customer.dart';

class ApiService {
  final String baseUrl = "http://159.89.10.1:8080/api/v1/customers";
  final String searchUrl = "http://159.89.10.1:8080/api/v1/customers/search";

  // Fetch all customers
  Future<List<Customer>> getCustomers(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Customer.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  // Create a new customer
  Future<Customer> createCustomer(Customer customer, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Customer.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create customer: ${response.body}');
    }
  }

  // Delete a customer
  Future<void> deleteCustomer(int customerId, String token) async {
    final response = await http.delete(
      Uri.parse("http://159.89.10.1:8080/api/v1/customers/$customerId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete customer: ${response.body}");
    }
  }



  // Search customers
  Future<List<Map<String, dynamic>>> searchCustomers(
      String query, String token) async {
    final response = await http.get(
      Uri.parse("$searchUrl?query=$query"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch customers');
    }
  }

  // Upload signature file
  Future<String> uploadSignature(
      String customerId, String filePath, String token) async {
    final uri = Uri.parse("$baseUrl/$customerId/signature");

    final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
    final mimeSplit = mimeType.split('/');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          filePath,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        ),
      );

    final streamedResponse = await request.send();
    final body = await http.Response.fromStream(streamedResponse);

    if (body.statusCode == 200) {
      final jsonResponse = jsonDecode(body.body);
      return jsonResponse['signatureUrl'] ?? '';
    } else {
      throw Exception('Failed to upload signature: ${body.body}');
    }
  }
}
