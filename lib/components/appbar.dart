import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSettingsButton;

  MyAppBar({required this.title, this.showSettingsButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5.0,
      backgroundColor: const Color.fromARGB(255, 240, 236, 229),
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            color: Color.fromARGB(255, 49, 48, 77),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Color.fromARGB(255, 49, 48, 77),
          size: 40,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: showSettingsButton
          ? [
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                color: Color.fromARGB(255, 49, 48, 77),
                onPressed: () {
                  // Handle settings button pressed
                },
              ),
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
