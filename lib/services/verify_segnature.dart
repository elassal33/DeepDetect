import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<void> verifySignature(
    File? image1, File? image2, String token, BuildContext context) async {
  if (image1 == null ||
      image2 == null ||
      !image1.existsSync() ||
      !image2.existsSync()) {
    print("DEBUG: One or both image files are missing!");
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: "Warning",
      desc: "Please select both signature images before verifying.",
      btnOkOnPress: () {},
    ).show();
    return;
  }

  // Show loading dialog
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent user from closing
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("Verifying Signature..."),
          ],
        ),
      );
    },
  );

  print(
      "DEBUG: Image1 Path -> ${image1.path}, Size: ${image1.lengthSync()} bytes");
  print(
      "DEBUG: Image2 Path -> ${image2.path}, Size: ${image2.lengthSync()} bytes");

  try {
    var uri = Uri.parse("http://159.89.10.1:8080/api/v1/signature/verify");
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate';
    request.headers['Pragma'] = 'no-cache';
    request.headers['Expires'] = '0';

    request.files.add(await http.MultipartFile.fromPath(
      'genuineSignature',
      image1.path,
      contentType: MediaType('image', 'jpeg'),
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'signatureToVerify',
      image2.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    print("DEBUG: Sending Request...");
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    print("DEBUG: Server Response Code: ${response.statusCode}");
    print("DEBUG: Response Body: $responseBody");

    // Close loading dialog
    Navigator.pop(context);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseBody);

      if (jsonResponse.containsKey('signatureWasNotForged') &&
          jsonResponse.containsKey('similarityPercentage') &&
          jsonResponse.containsKey('probabilityPercentage')) {
        AwesomeDialog(
          context: context,
          dialogType: jsonResponse['signatureWasNotForged']
              ? DialogType.success
              : DialogType.error,
          animType: AnimType.bottomSlide,
          title: jsonResponse['signatureWasNotForged']
              ? "Verified"
              : "Not Verified",
          desc:
              "Similarity Percentage: ${jsonResponse['similarityPercentage']}%\n"
              "Probability Percentage: ${jsonResponse['probabilityPercentage']}%\n"
              "Signature Was Not Forged: ${jsonResponse['signatureWasNotForged'] ? 'Yes' : 'No'}",
          btnOkOnPress: () {},
          btnOkColor:
              jsonResponse['signatureWasNotForged'] ? Colors.green : Colors.red,
        ).show();
      } else {
        print("DEBUG: Invalid response format!");
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: "Error",
          desc: "Unexpected response format from the server.",
          btnOkOnPress: () {},
        ).show();
      }
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Error",
        desc:
            "Server responded with error code: ${response.statusCode}\n$responseBody",
        btnOkOnPress: () {},
      ).show();
    }
  } catch (e) {
    print("DEBUG: Exception -> $e");

    // Close loading dialog in case of exception
    Navigator.pop(context);

    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: "Error",
      desc: "An unexpected error occurred: $e",
      btnOkOnPress: () {},
    ).show();
  }
}
