import 'package:flutter/material.dart';

class Textbox extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final IconData icons;
  final String? errormsg;
  final bool obscureText;
  final Widget? suffixIcon; //optional suffix icon for visibility toggle

  Textbox({
    super.key,
    required this.name,
    required this.controller,
    required this.obscureText,
    required this.icons,
    this.errormsg, 
    this.suffixIcon, // Accepting the optional suffic icon

  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TextFormField(
        obscureText: obscureText,
        cursorColor: const Color.fromRGBO(18, 79, 43, 1),
        style: const TextStyle(
          color: Color.fromARGB(255, 18, 79, 43),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        controller: controller,
        decoration: InputDecoration(
          hintText: name,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 18, 79, 43),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          errorText: errormsg,
          errorBorder: InputBorder.none,
          errorStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          errorMaxLines: 3,  // Allows error text to wrap to 3 lines
          focusedErrorBorder: InputBorder.none,
          prefixIcon: Icon(
            icons,
            size: 20,
          ),
          prefixIconColor: const Color.fromARGB(255, 18, 79, 43),
          suffixIcon: suffixIcon,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          fillColor: Colors.white60,
          filled: true,
        ),
      ),
    );
  }
}
