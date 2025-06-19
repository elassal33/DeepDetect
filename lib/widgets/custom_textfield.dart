import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.hintText,
      this.labelText,
      this.icon,
      this.icon2,
      this.controller,
      this.isPassword = false});

  final String? hintText;
  final String? labelText;
  final Icon? icon;
  final Icon? icon2;
  final TextEditingController? controller;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style:TextStyle(backgroundColor: Color(0xffF1F4FF),height: 1),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffF1F4FF),
          prefixIcon: icon,
          suffixIcon: icon2,
          labelText: labelText,
          hintText: hintText,
          enabledBorder:const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)),  borderSide: BorderSide(color: Colors.white,width: 1),),
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))

          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(10),
          //   borderSide: BorderSide(color: Colors.blue),
          // ),
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(10),
          //   borderSide: BorderSide(color: Colors.white),
          // ),
        ),
      ),
    );
  }
}
