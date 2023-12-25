import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'components/navbar.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller =
        PersistentTabController(initialIndex: 0);

    return MaterialApp(
      title: 'My Flutter App',
      debugShowCheckedModeBanner: false, // Hide the debug banner
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ), // Set the default font family
        primarySwatch: Colors.grey, // Set the primary color of the app to white
      ),
      home: AppBottomNavBar(controller: _controller),
    );
  }
}

class AppBottomNavBar extends StatefulWidget {
  final PersistentTabController controller;

  const AppBottomNavBar({Key? key, required this.controller}) : super(key: key);

  @override
  _AppBottomNavBarState createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyBottomNavBar(
        controller: widget.controller,
        currentIndex: widget.controller.index,
        onItemSelected: (index) {
          setState(() {
            widget.controller.index = index;
          });
        },
      ),
    );
  }
}
