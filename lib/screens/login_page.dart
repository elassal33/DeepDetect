import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grad_project/screens/homepage2.dart';
import 'package:grad_project/screens/regester_page.dart';
import 'package:grad_project/widgets/constants.dart';
import 'package:grad_project/widgets/custom_button.dart';
import 'package:grad_project/widgets/custom_textfield.dart';
import 'package:grad_project/widgets/encrypted_textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  static String id = 'LoginPage';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse('http://159.89.10.1:8080/api/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage2(token: token)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed! ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children:[ 
            // Image.asset(
            //   'assets/images/9f7ab93042c586c405572f45435f1df7.png', // Ensure the image is in assets
            //   width: 200,
            //   height: 200,
            // ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       'Secure Signature',
            //       style: TextStyle(
            //           fontSize: 32,
            //           color: Color(0xFF1F41BB),
            //           fontFamily: 'Pacifico'),
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 140,
                ),
                Text(
                  'Login here',
                  style: TextStyle(
                      fontSize: 30,
                      color: Color(0xFF1F41BB),
                      fontWeight: FontWeight.bold,
                      //fontFamily: 'Pacifico',
                      ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome back you’ve',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'been missed!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            CustomTextField(
              controller: emailController,
              hintText: 'Email',
              labelText: 'Email',
             // icon: Icon(Icons.email),
            ),
            SizedBox(height: 10),
            CustomPasswordTextField(
              controller: passwordController,
              hintText: 'Enter your password',
              labelText: 'Password',
              icon: Icon(Icons.lock),
            ),


            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot your password?     ",
                  style: TextStyle(
                    color: Color(0xff1F41BB),
                    fontSize: 14,
                  ),
                ),
              ),
            ),


            const SizedBox(
              height: 10,
            ),
           
              //mainAxisAlignment: MainAxisAlignment.center,
              
                Padding(
                  padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(  
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      
                    
                    backgroundColor: Color(0xff1F41BB), // Set your desired background color here
                    ),
                      onPressed: isLoading ? null : login,
                      child:
                          isLoading ? CircularProgressIndicator() : Text('Login',style:TextStyle(color: Colors.white,fontSize: 18)),
                    ),
                  ),
                ),
            
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    
                    onTap: () {
                      Navigator.pushNamed(context, RegisterPage.id);
                    },
                    child: Text(
                      'Create new account!',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                         // decoration: TextDecoration.underline
                          ),
                    ),
                  ),
                ],
              ),
              
            ),
            const SizedBox(height: 30),

            Center(
              child: const Text(
                "Or continue with",
                style: TextStyle(color: Color(0xff1F41BB)),
              ),
            ),

            const SizedBox(height: 15),

            // Social Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton('assets/images/google-icon.png'),
                const SizedBox(width: 10),
                _buildSocialButton('assets/images/OIP.jpeg'),
                // const SizedBox(width: 15),
                // _buildSocialButton('assets/apple.png'),
              ],
            ),
          ],
        ));
  }
}


Widget _buildSocialButton(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(
        assetPath,
        height: 30,
        width: 30,
      ),
    );
  }
