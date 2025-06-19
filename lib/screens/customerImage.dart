import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;

class SignatureUploadPage extends StatefulWidget {
  final String token;
  final int customerId;

  static String id = 'SignatureUploadPage';
  const SignatureUploadPage({required this.token, required this.customerId});

  @override
  _SignatureUploadPageState createState() => _SignatureUploadPageState();
}

class _SignatureUploadPageState extends State<SignatureUploadPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  bool _isVerifying = false;
  String? _fileName;
  double? _fileSizeMB;

  Future<void> _pickFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 30,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
          _fileName = pickedFile.name;
          _fileSizeMB = File(pickedFile.path).lengthSync() / (1024 * 1024);
        });
      }
    } catch (e) {
      _showErrorDialog('File selection error', e.toString());
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
          _fileName = pickedFile.name;
          _fileSizeMB = File(pickedFile.path).lengthSync() / (1024 * 1024);
        });
      }
    } catch (e) {
      _showErrorDialog('Camera error', e.toString());
    }
  }

  void _verify() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a signature first')),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Verifying Signature..."),
            ],
          ),
        );
      },
    );

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://159.89.10.1:8080/api/v1/signature/${widget.customerId}/verify'),
      );

      request.headers['Authorization'] = 'Bearer ${widget.token}';
      request.files.add(await http.MultipartFile.fromPath(
        'signatureToVerify',
        _imageFile!.path,
      ));

      var response = await request.send();

      Navigator.of(context).pop(); // Close loading dialog

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = jsonDecode(respStr);

        AwesomeDialog(
          context: context,
          dialogType: data['signatureWasNotForged'] == true
              ? DialogType.success
              : DialogType.error,
          title: data['signatureWasNotForged'] == true
              ? "Verified"
              : "Not Verified",
          desc: """
Similarity: ${data['similarityPercentage']}%
Probability: ${data['probabilityPercentage']}%
Genuine: ${data['signatureWasNotForged'] ? "Yes" : "No"}""",
          btnOkOnPress: () {},
          btnOkColor: data['signatureWasNotForged'] ? Colors.green : Colors.red,
        ).show();
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      _showErrorDialog('Verification failed', e.toString());
    }
  }

  void _showErrorDialog(String title, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkText: 'OK',
      btnOkColor: Colors.red,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xff1F41BB),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Upload a photo of your\nSignature",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _pickFromGallery,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff1F41BB)),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Image.asset('assets/images/addpic.png', height: 40),
                        const SizedBox(height: 10),
                        Text(
                          _fileName ?? "select file",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_fileName != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            '${_fileSizeMB?.toStringAsFixed(2) ?? '0'} MB',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("or"),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("open camera"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _verify,
                  child: const Text("verify"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                  ),
                ),
              ],
            ),
          ),
          if (_isVerifying)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
