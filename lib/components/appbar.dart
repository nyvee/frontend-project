import 'package:flutter/material.dart';

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
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Handle back button pressed
        },
      ),
      actions: showSettingsButton
          ? [
              IconButton(
                icon: const Icon(Icons.settings_rounded),
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
