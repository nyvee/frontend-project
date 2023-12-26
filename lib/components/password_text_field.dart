import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isObscure;
  final Function(bool) onVisibilityChanged;

  const PasswordTextField({
    Key? key,
    required this.controller,
    required this.isObscure,
    required this.onVisibilityChanged,
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
              borderSide: const BorderSide(color: Color(0xFFb6bbc4), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 49, 48, 77), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: const Color(0xFFF0EBE5),
            filled: true,
            suffixIcon: IconButton(
              icon: Icon(
                isObscure ? Icons.visibility : Icons.visibility_off,
                color: isObscure
                    ? const Color(0xFFb6bbc4)
                    : const Color.fromARGB(255, 49, 48, 77),
              ),
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
