import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grad_project/models/action_card.dart';
import 'package:grad_project/screens/customer_page.dart';
import 'package:grad_project/screens/homepage2.dart';
import 'package:grad_project/screens/search_page.dart';
import 'package:grad_project/screens/settingspage.dart';
import 'package:grad_project/services/verify_segnature.dart';
import 'package:grad_project/widgets/custom_bottom_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grad_project/helper/loggedin_api.dart';

class HomePage extends StatefulWidget {
  final String token;
  HomePage({required this.token});
  static String id = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String firstName = ""; // Store first name
  String lastName = ""; // Store last name
  String email = ""; // Store email
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when screen loads
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4447EB),
        title: Text(
          "Secure Signature",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomersPage(token: widget.token),
                  ));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xff4447EB)),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                       onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SettingsPage(token: widget.token),
                            ));
                      },
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 189, 211, 221),
                        radius: 30,
                        child: Text(
                          firstName.isNotEmpty ? firstName[0].toUpperCase() : '',
                          style: TextStyle(fontSize: 30),
                          // backgroundImage:
                          //     AssetImage('assets/images/moh.png'), // Your profile image
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLoading? "Loading..." : firstName, // ✅ Dynamic First & Last Name
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(width: 5),
                        Text(
                          isLoading
                              ? ""
                              : lastName, // ✅ Dynamic First & Last Name
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  isLoading ? "Loading..." : "$email", // ✅ Dynamic Email
                  style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 240, 237, 237)),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage2(token: widget.token),
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(token: widget.token),
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Customers"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomersPage(token: widget.token),
                  ));
            },
          ),
        ]),
      ),
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            SectionHeader(title: "Signature Detection"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionCard(
                  title: "Import Genuine Signature",
                  buttonLabel: "Import",
                  color: Color(0xff4447EB),
                  icon: Icons.photo_camera,
                  onPressed: () async {
                    await BottomSheet(context, isGenuineSignature: true);
                  },
                ),
                ActionCard(
                  title: "Import Signature to Verify",
                  buttonLabel: "Import",
                  color: Color(0xff4447EB),
                  icon: Icons.file_download,
                  onPressed: () async {
                    await BottomSheet(context, isGenuineSignature: false);
                  },
                ),
              ],
            
            ),

            SizedBox(height: 30,),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _verifySignatures(context, widget.token);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff4447EB)),
                child: Text("Verify Signatures",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          CustomBottomNavBar(selectedIndex: 1, token: widget.token),

    );
  }

  File? selectedImage1; // Genuine signature
  File? selectedImage2; // Signature to verify

  Future<void> BottomSheet1(BuildContext context,
      {required bool isGenuineSignature}) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.search),
                title: Text("Search Customer"),
                onTap: () async {
                  Navigator.pop(context); // Close BottomSheet before navigating
                  final selectedCustomer = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(token: widget.token),
                    ),
                  );

                  if (selectedCustomer != null &&
                      selectedCustomer.signatureUrl != null) {
                    setState(() {
                      selectedImage1 = File(selectedCustomer.signatureUrl!);
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _PickImage(
                      isGenuineSignature: isGenuineSignature, fromCamera: true);
                },
              ),
              ListTile(
                leading: Icon(Icons.file_download),
                title: Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _PickImage(
                      isGenuineSignature: isGenuineSignature,
                      fromCamera: false);
                },
              ),
            ],
          ),
        );
      },
    );
  }
   Future<void> BottomSheet(BuildContext context,
      {required bool isGenuineSignature}) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _PickImage(
                      isGenuineSignature: isGenuineSignature, fromCamera: true);
                },
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.file_download),
                title: Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _PickImage(
                      isGenuineSignature: isGenuineSignature,
                      fromCamera: false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _PickImage(
      {required bool isGenuineSignature, required bool fromCamera}) async {
    var image = await ImagePicker().pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 30,
    );

    if (image == null) return;

    setState(() {
      if (isGenuineSignature) {
        selectedImage1 = File(image.path);
      } else {
        selectedImage2 = File(image.path);
      }
    });
  }

  void _verifySignatures(BuildContext context, String token) async {
    if (selectedImage1 == null || selectedImage2 == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Error",
        desc:
            "Please select both the genuine signature and the signature to verify.",
        btnOkOnPress: () {},
      ).show();
      return;
    }

    await verifySignature(selectedImage1!, selectedImage2!, token, context);
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800),
      ),
    );
  }
}
