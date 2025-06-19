import 'package:flutter/material.dart';
import 'package:grad_project/screens/login_page.dart';
import 'package:grad_project/screens/signin_page.dart';
import 'package:grad_project/widgets/custom_button.dart';


class GetStarted extends StatelessWidget {
  const GetStarted({super.key});
  static String id = 'GetStarted';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FB), // Light grey background
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 50),
            Text(
              'Secure Signature',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff1F41BB),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'An innovative application powered by artificial intelligence to detect forged signatures with accuracy and speed. It aims to enhance trust in transactions by analyzing signatures and providing detailed reports. With a user-friendly interface, it ensures everyone can verify document authenticity easily and securely.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            Image.asset(
              'assets/images/9f7ab93042c586c405572f45435f1df7.png', // Ensure the image is in assets
              width: 250,
              height: 250,
            ),

            
            const SizedBox(height: 35),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, SigninScreen.id);
              },
              child: CustomButton(
                text: 'Get Started',
              ),
            ),
            //const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}