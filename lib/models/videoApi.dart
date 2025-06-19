import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> verifyVideo(File videoFile) async {
  final url = Uri.parse("http://159.89.10.1:8080/api/v1/video/verify");

  try {
    final request = http.MultipartRequest('POST', url);

    // Attach video file
    request.files
        .add(await http.MultipartFile.fromPath('video', videoFile.path));

    // Send the request
    final response = await request.send();

    // Convert streamed response to regular response
    final responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final result = jsonDecode(responseBody.body);
      print("Prediction: ${result['prediction']}");
      print("Is Real: ${result['is_real']}");
      print("Confidence: ${result['confidence']}%");
    } else {
      print("Failed with status: ${response.statusCode}");
      print(responseBody.body);
    }
  } catch (e) {
    print("Error verifying video: $e");
  }
}
