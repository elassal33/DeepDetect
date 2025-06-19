import 'package:flutter/material.dart';
import 'package:grad_project/screens/login_page.dart';
import 'package:grad_project/screens/regester_page.dart';
import 'package:grad_project/widgets/custom_button.dart';



class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});
  static String id = 'SigninScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FB), // Light grey background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              // Icon and Title
              Column(
                children: [
                  const SizedBox(height: 40),
                Image.asset(
                    'assets/images/welcome image.png', // Ensure the image is in assets
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Detection System',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1F41BB), // Purple color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
        
              // Question Text
              const Padding(
                padding: const EdgeInsets.only(left: 35),
                child: const Text(
                  'easily verify and detect fake signatur \n            sesusing smart technology',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 30),
        
              // Login Button
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, LoginPage.id);
                },
                child: CustomButton(
                  text: 'Login',
                ),
              ),
              const SizedBox(height: 10),
        
              // Register Button
             GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RegisterPage.id);
                },
                child: CustomButton(
                  text: 'Register',
                ),
              ),
              const SizedBox(height: 20),
        
            ],
          ),
        ),
      ),
    );
  }
}
