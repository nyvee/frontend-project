import 'package:flutter/material.dart';

class PasswordTextFieldE extends StatelessWidget {
 final TextEditingController controller;
 final bool isObscure;
 final Function(bool) onVisibilityChanged;
 final bool isPasswordMatch;

 const PasswordTextFieldE({
   Key? key,
   required this.controller,
   required this.isObscure,
   required this.onVisibilityChanged,
   required this.isPasswordMatch,
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
         obscureText: isObscure,
         decoration: InputDecoration(
           enabledBorder: OutlineInputBorder(
             borderSide: BorderSide(
               color: isPasswordMatch ? Color(0xFFb6bbc4) : Colors.red,
               width: 2,
             ),
             borderRadius: BorderRadius.circular(10),
           ),
           focusedBorder: OutlineInputBorder(
             borderSide: BorderSide(
               color: isPasswordMatch ? Color(0xFFb6bbc4) : Colors.red,
               width: 2,
             ),
             borderRadius: BorderRadius.circular(10),
           ),
           fillColor: const Color(0xFFF0EBE5),
           filled: true,
           suffixIcon: IconButton(
             icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
             onPressed: () {
               onVisibilityChanged(!isObscure);
             },
           ),
         ),
       ),
     ),
   );
 }
}
