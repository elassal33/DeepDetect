import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/helper/signup_api.dart';
import 'package:grad_project/screens/home_page.dart';
import 'package:grad_project/models/user_model.dart';
import 'package:grad_project/screens/login_page.dart';
import 'package:grad_project/screens/signin_page.dart';
import 'package:grad_project/widgets/constants.dart';
import 'package:grad_project/widgets/custom_button.dart';
import 'package:grad_project/widgets/custom_textfield.dart';
import 'package:grad_project/widgets/encrypted_textfield.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});
  static String id = 'RegisterPage';

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final ApiService _apiService = ApiService();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  bool _isPasswordValidNow = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _isPasswordValidNow = _isPasswordValid(_passwordController.text);
      });
    });
  }

  bool _isPasswordValid(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'\d'));
    final hasMinLength = password.length >= 8;

    return hasUppercase && hasLowercase && hasNumber && hasMinLength;
  }

  Future<void> _handleSignUp() async {
    setState(() {
      isLoading = true;
    });

    UserModel user = UserModel(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    String response = await _apiService.signUp(user);

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response)));

    if (response.contains("successful")) {
      Navigator.pushNamed(context, LoginPage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: ListView(
        children: [
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Create Account',
              style: TextStyle(
                fontSize: 30,
                color: Color(0xFF1F41BB),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: const [
                Text(
                  'Create an account so you can explore all the ',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                Text(
                  'existing jobs',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          CustomTextField(
            hintText: 'First Name',
            labelText: 'First Name',
            controller: _firstNameController,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            hintText: 'Last Name',
            labelText: 'Last Name',
            controller: _lastNameController,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            hintText: 'Email',
            labelText: 'Email',
            controller: _emailController,
          ),
          const SizedBox(height: 10),
          CustomPasswordTextField(
            hintText: 'Enter your password',
            labelText: 'Password',
            icon: Icon(Icons.lock),
            controller: _passwordController,
          ),
          const SizedBox(height: 5),

          // Optional: Display password requirement error
          if (!_isPasswordValidNow && _passwordController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Password must be at least 8 characters,\ninclude upper and lower case letters and a number.',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),

          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: isLoading || !_isPasswordValidNow ? null : _handleSignUp,
                child: isLoading
                    ? CircularProgressIndicator()
                    : Opacity(
                        opacity: _isPasswordValidNow ? 1.0 : 0.5,
                        child: AbsorbPointer(
                          absorbing: !_isPasswordValidNow,
                          child: CustomButton(text: 'Register'),
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, LoginPage.id);
                  },
                  child: const Text(
                    'Already have an account!',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Center(
            child: Text(
              "Or continue with",
              style: TextStyle(color: Color(0xff1F41BB)),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton('assets/images/google-icon.png'),
              const SizedBox(width: 10),
              _buildSocialButton('assets/images/OIP.jpeg'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
