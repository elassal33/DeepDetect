import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final Color color;
  final String buttonLabel;
  final IconData icon;
  final VoidCallback onPressed;

  const ActionCard({
    required this.title,
    required this.buttonLabel,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      height: 200,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xff4749EF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Icon(icon, size: 40, color: Colors.white),
          SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 14, 15, 93),
              minimumSize: Size(double.infinity, 35),
            ),
            child: Text(
              buttonLabel,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
