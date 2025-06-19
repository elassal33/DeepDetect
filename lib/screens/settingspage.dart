import 'package:flutter/material.dart';
import 'package:grad_project/helper/loggedin_api.dart';
import 'package:grad_project/screens/login_page.dart';
import 'package:grad_project/widgets/custom_bottom_nav_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.token}) : super(key: key);
  static String id = 'SettingsPage';
  final String token; // Auth token

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 60),
            _buildUserInfo(),
            const SizedBox(height: 20),
            _buildSettingsOptions(),
          ],
        ),
      ),
      bottomNavigationBar:
          CustomBottomNavBar(selectedIndex: 3, token: widget.token),

    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFF4A5DF4),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 50),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -50,
          left: MediaQuery.of(context).size.width / 2 - 50,
          child:  CircleAvatar(
            backgroundColor: Color.fromARGB(255, 189, 211, 221),
            radius: 50,
            child: Text(
              firstName.isNotEmpty ? firstName[0].toUpperCase() : '',
              style: TextStyle(fontSize: 40),
              // backgroundImage:
              //     AssetImage('assets/images/moh.png'), // Your profile image
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          isLoading ? "Loading..." : firstName ,
          style: TextStyle(
            color: isError ? Colors.red : const Color(0xff4447EB),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          isLoading ? "Loading..." : email,
          style: const TextStyle(
            color: Color(0xff7F6E6E),
            fontSize: 14,
          ),
        ),
        if (isError)
          ElevatedButton.icon(
            onPressed: fetchUserData,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
      ],
    );
  }


  Widget _buildSettingsOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("  General"),
          _buildSettingsCard([
            _buildListTile(Icons.logout, "Logout", () {
              Navigator.pop(context);
              Navigator.pushNamed(context, LoginPage.id);
            }),
            _buildListTile(Icons.security, "Allow to access", () {}),
            _buildListTile(Icons.save, "Save media files", () {}),
          ]),
          const SizedBox(height: 20),
          _buildSectionTitle("  Help & Support"),
          _buildSettingsCard([
            _buildListTile(Icons.mail, "Contact us", () {}),
            _buildListTile(Icons.privacy_tip, "Privacy policy", () {}),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(children: children),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: onTap,
    );
  }
}
