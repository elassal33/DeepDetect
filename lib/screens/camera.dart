import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image (Simulating Camera Preview)
          Positioned.fill(
            child: Image.asset(
              'assets/images/moh.png', // Replace with your image asset or camera preview widget
              fit: BoxFit.cover,
            ),
          ),

          // Header Icons
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {}, // Back button functionality
                ),
                // IconButton(
                //   icon: const Icon(Icons.emoji_emotions, color: Colors.white),
                //   onPressed: () {}, // Emoji functionality
                // ),
                IconButton(
                  icon: const Icon(Icons.photo_library, color: Colors.white),
                  onPressed: () {}, // Open gallery functionality
                ),
              ],
            ),
          ),

          // Footer Icons
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 30),
                  onPressed: () {}, // Navigate to Home
                ),
                GestureDetector(
                  onTap: () {}, // Capture button functionality
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(color: Colors.blue, width: 4),
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.blue, size: 30),
                  ),
                ),
                IconButton(
                  icon:
                      const Icon(Icons.settings, color: Colors.white, size: 30),
                  onPressed: () {}, // Navigate to Settings
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
