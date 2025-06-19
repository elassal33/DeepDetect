import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
   CustomButton({required this.text});

  String text;
  @override
  Widget build(BuildContext context) {
    return  Container(
              decoration: BoxDecoration(
                color: Color(0xff1F41BB),
                borderRadius: BorderRadius.circular(20)
              ),
              width: 300,
              height: 56,
              child: Center(child: Text(text,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight:FontWeight.bold),)),
            );
  }
}