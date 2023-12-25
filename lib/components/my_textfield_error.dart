import 'package:flutter/material.dart';

class MyTextFieldE extends StatelessWidget {
 final TextEditingController controller;
 final bool obscureText;
 final Color borderColor;

 const MyTextFieldE({
   Key? key,
   required this.controller,
   required this.obscureText,
   required this.borderColor,
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
         decoration: InputDecoration(
           enabledBorder: OutlineInputBorder(
             borderSide: BorderSide(color: borderColor, width: 2),
             borderRadius: BorderRadius.circular(10),
           ),
           focusedBorder: OutlineInputBorder(
             borderSide: BorderSide(color: borderColor, width: 2),
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
