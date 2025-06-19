import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grad_project/screens/audioPage.dart';
import 'package:grad_project/screens/customer_page.dart';
import 'package:grad_project/screens/home_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:grad_project/screens/settingspage.dart';
import 'package:grad_project/screens/verify_video.dart';
import 'package:grad_project/widgets/custom_bottom_nav_bar.dart';
import 'package:grad_project/helper/loggedin_api.dart';

class HomePage2 extends StatefulWidget {
  final String token;
  HomePage2({required this.token});
  static String id = 'HomePage2';

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  int _selectedIndex = 0;
  String firstName = "Loading...";
  String lastName = "";
  String email = "Loading...";
  bool isLoading = true;
  bool isError = false;

  @override
   void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    print("Token: ${widget.token}"); // Debugging

    final apiService = ApiService();
    final response = await apiService.fetchUserData(widget.token);

    print("Response: $response"); // Debugging

    if (response is Map<String, dynamic> && response.containsKey("firstName")) {
      setState(() {
        firstName = response["firstName"] ?? "Unknown";
        lastName = response["lastName"] ?? "";
        email = response["email"] ?? "No Email";
        isLoading = false;
        isError = false;
      });
    } else {
      setState(() {
        firstName = "Error";
        email = "Could not fetch data";
        isLoading = false;
        isError = true;
      });
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xff1F41BB),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(token: widget.token),
                    ));
              },
              child:  CircleAvatar(
                backgroundColor: Color.fromARGB(255, 189, 211, 221),
                radius: 20,
                child: Text(
                  firstName.isNotEmpty ? firstName[0].toUpperCase() : '',
                // backgroundImage:
                //     AssetImage('assets/images/moh.png'), // Your profile image
              ),
            ),
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                const Text(
                  'Hello, ',
                  style: TextStyle(color: Colors.white,),
                ),
                Text(
                  isLoading ? "Loading..." : firstName,
                  style: TextStyle(
                    color: isError ? Colors.red : Color.fromARGB(255, 255, 255, 255),
                    fontSize: 22,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: (){
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CustomersPage(token: widget.token),
                      ));
              },
              child: const Icon(Icons.search, color: Colors.white, size: 30)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color:  Colors.grey[200],
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/images/Illustration.png', // Your main image
                    height: 200,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome, to Deep Detect!',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1F41BB)),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "The Signature Fraud Detection App helps you verify the authenticity of customer signatures in real-time. Ensuring secure and accurate transactions.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromARGB(255, 77, 115, 237),fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Start Verifying",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1F41BB)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(token: widget.token)),
                        );
                      },
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 6)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                             Image.asset(
                              'assets/images/pic.png', // Your main image
                              height: 30,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Secure &\nValidate\nSignatures",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 10, vertical: 4),
                            //   decoration: BoxDecoration(
                            //     color: Color(0xff1F41BB),
                            //     borderRadius: BorderRadius.circular(8),
                            //   ),
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: const [
                            //       Text(
                            //         "validate now",
                            //         style: TextStyle(
                            //             color: Colors.white, fontSize: 12),
                            //       ),
                            //       SizedBox(width: 4),
                            //       Icon(Icons.arrow_outward,
                            //           color: Colors.white, size: 14),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UploadVideoPage(
                                        token: widget.token,
                                      )),
                            );
                          },
                          child: Container(
                            height: 85,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 6)
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                                Image.asset(
                              'assets/images/video.png', // Your main image
                              height: 30,
                            ),
                                SizedBox(width: 8),
                                Text("Fake Video",style: TextStyle(fontSize: 16,fontWeight:FontWeight.w600),),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UploadAudioPage(token: widget.token,)),
                            );
                          },
                          child: Container(
                            height: 85,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 6)
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                                 Image.asset(
                                  'assets/images/audio.png', // Your main image
                                  height: 30,
                                ),
                                SizedBox(width: 8),
                                Text("Fake Audio",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar:
          CustomBottomNavBar(selectedIndex: 0, token: widget.token),


      
    );
  }

  // Widget _buildVerificationCard(String imagePath, String label) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: const Color(0xffDEDDEF),
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: Column(
  //       children: [
  //         Image.asset(imagePath, height: 100),
  //         const SizedBox(height: 8),
  //         Container(
  //           margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  //           padding: const EdgeInsets.symmetric(vertical: 6),
  //           decoration: BoxDecoration(
  //             color: const Color(0xff1F41BB),
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: Center(
  //             child: Text(
  //               label,
  //               style: const TextStyle(
  //                   color: Colors.white, fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
