import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
 final controller;
 final bool obscureText;

 const MyTextField({
 Key? key,
 required this.controller,
 required this.obscureText,
 }) : super(key: key);

 @override
 Widget build(BuildContext context) {
 return Padding(
   padding: const EdgeInsets.symmetric(horizontal: 25.0),
   child: Container(
     width: 350, // Set the width of the container
     height: 60, // Set the height of the container
     child: TextField(
       controller: controller,
       obscureText: obscureText,
       decoration: InputDecoration(
         enabledBorder: OutlineInputBorder(
           borderSide: BorderSide(color: const Color(0xFFb6bbc4), width: 2),
           borderRadius: BorderRadius.circular(10),
         ),
         focusedBorder: OutlineInputBorder(
           borderSide: BorderSide(color: const Color(0xFFb6bbc4), width: 2),
           borderRadius: BorderRadius.circular(10),
         ),
         fillColor: const Color(0xFFF0EBE5),
         filled: true,
         hintStyle: TextStyle(color: Colors.grey[500]),
       ),
     ),
   ),
 );
 }
}
