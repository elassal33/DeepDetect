import 'package:flutter/material.dart';

class CustomPasswordTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final Icon icon;
  final TextEditingController? controller;

  const CustomPasswordTextField({
    Key? key,
    required this.hintText,
    required this.labelText,
    required this.icon,
    this.controller,
  }) : super(key: key);

  @override
  _CustomPasswordTextFieldState createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        controller: widget.controller, // Ensure controller is properly linked
        obscureText: _obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffF1F4FF),
          labelText: widget.labelText,
          hintText: widget.hintText,
         // prefixIcon: widget.icon,
           enabledBorder:const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)),  borderSide: BorderSide(color: Colors.white,width: 1),),
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          suffixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}
