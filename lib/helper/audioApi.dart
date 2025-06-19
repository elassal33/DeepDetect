import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<void> verifyAudio() async {
  // API endpoint
  final url = Uri.parse('http://159.89.10.1:8080/api/v1/audio/verify');

  // Replace with your actual authorization token
  final authToken = 'your_auth_token_here';

  // Path to the audio file you want to upload
  final audioFile =
      File('path/to/your/4jdi-k9ki0.mp3'); // Replace with actual path

  // Create multipart request
  var request = http.MultipartRequest('POST', url);

  // Add headers
  request.headers['Authorization'] = authToken;
  request.headers['Content-Type'] = 'multipart/form-data';

  // Add audio file to the request
  request.files.add(await http.MultipartFile.fromPath(
    'audio', // Field name from your API
    audioFile.path,
    contentType: MediaType('audio', 'mpeg'), // Adjust for your audio type
  ));

  // Add other fields if needed
  request.fields['Key'] = 'Value'; // As shown in your Key-Value table

  try {
    // Send the request
    final response = await request.send();

    // Get the response
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print('Success! Response: $responseBody');
      // The response appears to contain a "prediction" field
      // Example: {"prediction": "Real audio"}
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response: $responseBody');
    }
  } catch (e) {
    print('Error making the request: $e');
  }
}
