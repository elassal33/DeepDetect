import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:grad_project/screens/home_page.dart';
import 'package:grad_project/screens/customer_page.dart';
import 'package:grad_project/screens/homepage2.dart';
import 'package:grad_project/screens/settingspage.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final String token;

  const CustomBottomNavBar(
      {super.key, required this.selectedIndex, required this.token});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: Colors.white,
      buttonBackgroundColor: const Color(0xff3B82F6),
      height: 70,
      animationDuration: const Duration(milliseconds: 300),
      index: selectedIndex,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, FadePageRoute(page: HomePage2(token: token)));
        } else if (index == 1) {
          Navigator.pushReplacement(
              context, FadePageRoute(page: HomePage(token: token)));
        } else if (index == 2) {
          Navigator.pushReplacement(
              context, FadePageRoute(page: CustomersPage(token: token)));
        } else if (index == 3) {
          Navigator.pushReplacement(
              context, FadePageRoute(page: SettingsPage(token: token)));
        }
      },

      items: <Widget>[
        Icon(Icons.home_outlined,
            size: 30, color: selectedIndex == 0 ? Colors.white : Colors.black),
        Icon(Icons.document_scanner_outlined,
            size: 30, color: selectedIndex == 1 ? Colors.white : Colors.black),
        Icon(Icons.person_outline,
            size: 30, color: selectedIndex == 2 ? Colors.white : Colors.black),
        Icon(Icons.settings,
            size: 30, color: selectedIndex == 3 ? Colors.white : Colors.black),
      ],
    );
  }
}

class FadePageRoute extends PageRouteBuilder {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
