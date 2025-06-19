import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class UploadAudioPage extends StatefulWidget {
  static String id = 'UploadAudioPage';
  final String token;

  const UploadAudioPage({super.key, required this.token});
  @override
  _UploadAudioPageState createState() => _UploadAudioPageState();
}

class _UploadAudioPageState extends State<UploadAudioPage> {
  String? _audioPath;
  bool _isLoading = false;
  String? _fileName;

  Future<void> _pickAudioFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _audioPath = result.files.single.path;
          _fileName = result.files.single.name;
        });
      }
    } catch (e) {
      _showErrorDialog('File selection error', e.toString());
    }
  }

  Future<void> _verifyAudio() async {
    if (_audioPath == null || _audioPath!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an audio file first")),
      );
      return;
    }

    setState(() => _isLoading = true);

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
              Text("Verifying Audio..."),
            ],
          ),
        );
      },
    );

    try {
      final url = Uri.parse('http://159.89.10.1:8080/api/v1/audio/verify');
      final audioFile = File(_audioPath!);

      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer ${widget.token}'
        ..files.add(await http.MultipartFile.fromPath(
          'audio',
          audioFile.path,
          contentType: MediaType('audio', 'mpeg'),
        ))
        ..fields['Key'] = 'Value';

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (!mounted) return;

      // Dismiss loading dialog
      Navigator.pop(context);

      setState(() => _isLoading = false);
      _handleResponse(response.statusCode, responseBody);
    } catch (e) {
      if (!mounted) return;

      // Dismiss loading dialog
      Navigator.pop(context);

      setState(() => _isLoading = false);
      _showErrorDialog('Verification failed', e.toString());
    }
  }


  void _handleResponse(int statusCode, String responseBody) {
    if (statusCode == 200) {
      try {
        final result = json.decode(responseBody);
        final prediction = result['prediction']?.toString() ?? 'Unknown';

        AwesomeDialog(
          context: context,
          dialogType: prediction.toLowerCase().contains('real')
              ? DialogType.success
              : DialogType.warning,
          animType: AnimType.scale,
          title: 'Verification Complete',
          desc: 'Prediction: $prediction',
          btnOkText: 'OK',
          btnOkColor: Colors.green,
          btnOkOnPress: () {},
        ).show();
      } catch (e) {
        _showErrorDialog('Data parsing error', e.toString());
      }
    } else {
      _showErrorDialog('API Error',
          'Status: $statusCode\nResponse: ${responseBody.length > 100 ? '${responseBody.substring(0, 100)}...' : responseBody}');
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        //title: const Text('Audio Verification'),
        backgroundColor: const Color(0xff1F41BB),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Upload an audio file for verification',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildFilePicker(),
                const SizedBox(height: 40),
                _buildVerifyButton(),
              ],
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildFilePicker() {
    return GestureDetector(
      onTap: _pickAudioFile,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.blue.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/audio.png', // Your main image
              height: 40,
            ),
            const SizedBox(height: 16),
            Text(
              _fileName ?? 'Tap to select audio file',
              style: TextStyle(
                fontSize: 18,
                // color: _fileName != null
                //     ? Colors.grey.shade800
                //     : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (_fileName != null) ...[
              const SizedBox(height: 8),
              Text(
                '${_audioPath != null ? (File(_audioPath!).lengthSync() / (1024 * 1024)).toStringAsFixed(2) : '0'} MB',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _verifyAudio,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        //shape: RoundedRectangleBorder(
        //borderRadius: BorderRadius.circular(10),
        //),
        elevation: 3,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ),
            )
          : const Text(
              'Verify',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
    );
  }

  // Widget _buildLoadingOverlay() {
  //   return Container(
  //     color: Colors.black.withOpacity(0.5),
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           const CircularProgressIndicator(
  //             valueColor: AlwaysStoppedAnimation(Colors.white),
  //             strokeWidth: 5,
  //           ),
  //           const SizedBox(height: 20),
  //           Text(
  //             'Verifying audio...',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 18,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
