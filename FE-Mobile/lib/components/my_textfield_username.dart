import 'package:flutter/material.dart';

class MyTextFieldU extends StatelessWidget {
 final TextEditingController controller;
 final bool obscureText;
 final InputDecoration? decoration;

 const MyTextFieldU({
 Key? key,
 required this.controller,
 required this.obscureText,
 this.decoration,
 }) : super(key: key);

 @override
 Widget build(BuildContext context) {
 return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 25.0),
  child: SizedBox(
    width: 350,
    height: 60,
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: decoration,
    ),
  ),
 );
 }
}
