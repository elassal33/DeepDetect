import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Uploads a signature image for verification for a specific customer.
Future<void> verifyCustomerSignature({
  required int customerId,
  required File signatureFile,
  required String token, // optional if your API requires authentication
}) async {
  final uri =
      Uri.parse("http://159.89.10.1:8080/api/v1/signature/$customerId/verify");

  var request = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $token' // Remove if not needed
    ..files.add(await http.MultipartFile.fromPath(
      'signatureToVerify',
      signatureFile.path,
    ));

  final response = await request.send();
  final resBody = await http.Response.fromStream(response);

  if (resBody.statusCode == 200) {
    final data = jsonDecode(resBody.body);

    print("✅ Signature Verified:");
    print("Similarity: ${data['similarityPercentage']}%");
    print("Probability: ${data['probabilityPercentage']}%");
    print("Forged: ${data['signatureWasNotForged'] == false ? 'Yes' : 'No'}");
  } else {
    print("❌ Failed to verify signature: ${resBody.body}");
    throw Exception('Verification failed with status ${resBody.statusCode}');
  }
}
