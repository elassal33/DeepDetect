import 'package:flutter/material.dart';
import 'package:grad_project/screens/audioPage.dart';
import 'package:grad_project/screens/camera.dart';
import 'package:grad_project/screens/customerImage.dart';
import 'package:grad_project/screens/customer_page.dart';
import 'package:grad_project/screens/get_started.dart';
import 'package:grad_project/screens/home_page.dart';
import 'package:grad_project/screens/homepage2.dart';
import 'package:grad_project/screens/login_page.dart';
import 'package:grad_project/screens/regester_page.dart';
import 'package:grad_project/screens/search_page.dart';
import 'package:grad_project/screens/settingspage.dart';
import 'package:grad_project/screens/signin_page.dart';
import 'package:grad_project/screens/splash_screen.dart';
import 'package:grad_project/screens/verify_video.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(GraduationProject());
}

class GraduationProject extends StatelessWidget {
  const GraduationProject({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          LoginPage.id: (context) => LoginPage(),
          RegisterPage.id: (context) => RegisterPage(),
          GetStarted.id: (context) => GetStarted(),
          SigninScreen.id: (context) => SigninScreen(),
          UploadVideoPage.id: (context) => UploadVideoPage(token: 'token',),
          UploadAudioPage.id: (context) => UploadAudioPage(token: 'token',),
          //SignatureUploadPage.id: (context) => SignatureUploadPage(token: 'token',customerId: customer.id!,),
          HomePage.id: (context) => HomePage(token: 'token',),
          HomePage2.id: (context) => HomePage2(token: 'token',),
          SettingsPage.id: (context) => SettingsPage(token: 'token',),
          SearchPage.id: (context) => SearchPage(token: 'token'),
          CustomersPage.id: (context) => CustomersPage(token: 'token'),
        },
        home:  SplashScreen(),
        
        
        // FloatingActionButton(onPressed: () async {
        //   http.Response response = await http.post(
        //       Uri.parse('http://34.163.3.57:8080/api/v1/signature/verify/test'),
        //       body: {
        //         'genuineSignature':
        //             'WhatsApp Image 2024-12-28 at 11.36.10_520ce398.jpg',
        //         'genuineSignature':
        //             'WhatsApp Image 2024-12-28 at 11.36.10_f0320ed4.jpg',
        //       }, headers: {});

        //       print(response.body);
        // })

        

        );
  }
}
