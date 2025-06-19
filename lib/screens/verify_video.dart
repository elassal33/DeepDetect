import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http_parser/http_parser.dart';

class UploadVideoPage extends StatefulWidget {
  static String id = 'UploadVideoPage';
  final String token;

  const UploadVideoPage({super.key, required this.token});
  @override
  _UploadVideoPageState createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  String? _videoPath;
  bool _isUploading = false;
  String? _fileName;
  double? _fileSizeMB;

  Future<void> _pickVideoFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        setState(() {
          _videoPath = file.path;
          _fileName = result.files.single.name;
          _fileSizeMB = file.lengthSync() / (1024 * 1024);
        });
      }
    } catch (e) {
      _showErrorDialog(
          'File Selection Error', 'Failed to select video: ${e.toString()}');
    }
  }

  Future<void> _verifyVideo() async {
    if (_videoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a video first")),
      );
      return;
    }

    // Validate file before upload
    try {
      final file = File(_videoPath!);
      if (!_videoPath!.toLowerCase().endsWith('.mp4')) {
        throw Exception('Only MP4 videos are supported');
      }
      if (_fileSizeMB! > 100) {
        throw Exception('Video must be smaller than 100MB');
      }
    } catch (e) {
      _showErrorDialog('Invalid Video File', e.toString());
      return;
    }

    setState(() => _isUploading = true);

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
              Text("Verifying Video..."),
            ],
          ),
        );
      },
    );

    try {
      final uri = Uri.parse("http://159.89.10.1:8080/api/v1/video/verify");
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Authorization': 'Bearer ${widget.token}',
          'Accept': 'application/json',
          'Connection': 'keep-alive',
        })
        ..files.add(await http.MultipartFile.fromPath(
          'video',
          _videoPath!,
          contentType: MediaType('video', 'mp4'),
        ))
        ..fields['filename'] = _fileName ?? 'uploaded_video.mp4';

      final response = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw SocketException('Connection timeout');
        },
      );

      if (!mounted) return;
      setState(() => _isUploading = false);
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss dialog

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        _handleSuccessResponse(responseBody);
      } else {
        _handleErrorResponse(response.statusCode, responseBody);
      }
    } on SocketException catch (e) {
      if (!mounted) return;
      setState(() => _isUploading = false);
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss dialog

      _showErrorDialog(
        'Connection Error',
        'Failed to connect to server:\n${e.message}\n\nPlease check your network and try again.',
        dialogType: DialogType.warning,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploading = false);
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss dialog

      _showErrorDialog(
        'Verification Failed',
        'An unexpected error occurred:\n${e.toString()}',
      );
    }
  }


  void _handleSuccessResponse(String responseBody) {
    try {
      final result = jsonDecode(responseBody);

      // Validate required fields
      if (result['prediction'] == null || result['confidence'] == null) {
        throw FormatException('Model server response missing required fields');
      }

      final prediction = result['prediction'].toString();
      final confidence =
          double.tryParse(result['confidence'].toString()) ?? 0.0;
      final isReal = result['is_real'] == true ||
          prediction.toLowerCase().contains('real');

      AwesomeDialog(
        context: context,
        dialogType: isReal ? DialogType.success : DialogType.error,
        animType: AnimType.scale,
        title: isReal ? 'Authentic Video' : 'Potential Fake',
        desc:
            'Prediction: ${prediction.capitalize()}\nConfidence: ${confidence.toStringAsFixed(2)}%',
        btnOkText: 'OK',
        btnOkColor: isReal ? Colors.green : Colors.red,
        btnOkOnPress: () {},
      ).show();
    } on FormatException catch (e) {
      _showErrorDialog(
        'Invalid Response',
        'Error parsing model server response:\n${e.message}',
        dialogType: DialogType.info,
      );
    } catch (e) {
      _showErrorDialog(
        'Result Processing Error',
        'Failed to process verification results:\n${e.toString()}',
      );
    }
  }

  void _handleErrorResponse(int statusCode, String responseBody) {
    String errorMessage;
    try {
      final errorBody = jsonDecode(responseBody);
      errorMessage = errorBody['error'] ??
          errorBody['message'] ??
          'Error $statusCode: ${_getStatusMessage(statusCode)}';
    } catch (_) {
      errorMessage = 'Error $statusCode: ${_getStatusMessage(statusCode)}';
    }

    _showErrorDialog(
      'Verification Failed',
      errorMessage,
      dialogType: statusCode == 401 ? DialogType.warning : DialogType.error,
    );
  }

  String _getStatusMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request - Invalid video format';
      case 401:
        return 'Unauthorized - Please login again';
      case 500:
        return 'Server error - Please try later';
      default:
        return 'Unexpected error occurred';
    }
  }

  void _showErrorDialog(String title, String message,
      {DialogType dialogType = DialogType.error}) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkText: 'OK',
      btnOkColor: dialogType == DialogType.error
          ? Colors.red
          : dialogType == DialogType.warning
              ? Colors.orange
              : Colors.blue,
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
        //title: const Text('Video Verification'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Upload a video to verify',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: _pickVideoFile,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xff1F41BB), width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/video.png', // Your main image
                            height: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _fileName ?? "Select file",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (_fileSizeMB != null)
                            Text(
                              '${_fileSizeMB!.toStringAsFixed(2)} MB',
                              style: const TextStyle(fontSize: 14),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isUploading ? null : _verifyVideo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                  ),
                  child: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Verify"),
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
