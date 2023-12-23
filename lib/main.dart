import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'components/navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      debugShowCheckedModeBanner: false, // Hide the debug banner
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ), // Set the default font family
        primarySwatch: Colors.grey, // Set the primary color of the app to white
      ),
      home: MyBottomNavBar(
        controller: _controller,
        currentIndex: _controller.index,
        onItemSelected: (index) {
          _controller.index = index;
        },
      ),
    );
  }
}
