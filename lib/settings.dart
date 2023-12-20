import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_project/privasi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF0ECE5),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Settings',
          style: TextStyle() = GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        shadowColor: const Color(0xff636363),
      ),
      body: const ButtonList(),
      backgroundColor: const Color(0xffF0ECE5),
    );
  }
}

class ButtonList extends StatelessWidget {
  const ButtonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {},
          child: Container(
            padding: const EdgeInsets.only(top: 17.0, bottom: 17.0, left: 29),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.5, color: Colors.black),
                bottom: BorderSide(width: 0.5, color: Colors.black),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Address Book',
                style: TextStyle() = GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        TextButton(
          onPressed: () {},
          child: Container(
            padding: const EdgeInsets.only(top: 17.0, bottom: 17.0, left: 29),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.5, color: Colors.black),
                bottom: BorderSide(width: 0.5, color: Colors.black),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Language',
                style: TextStyle() = GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        TextButton(
          onPressed: () {},
          child: Container(
            padding: const EdgeInsets.only(top: 17.0, bottom: 17.0, left: 29),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.5, color: Colors.black),
                bottom: BorderSide(width: 0.5, color: Colors.black),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Switch Theme',
                style: TextStyle() = GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        TextButton(
          onPressed: () {},
          child: Container(
            padding: const EdgeInsets.only(top: 17.0, bottom: 17.0, left: 29),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.5, color: Colors.black),
                bottom: BorderSide(width: 0.5, color: Colors.black),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Feedback',
                style: TextStyle() = GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        TextButton(
          onPressed: () {},
          child: Container(
            padding: const EdgeInsets.only(top: 17.0, bottom: 17.0, left: 29),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.5, color: Colors.black),
                bottom: BorderSide(width: 0.5, color: Colors.black),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contact/Support',
                style: TextStyle() = GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrivacyPage()),
            );
          },
          child: Container(
            padding: const EdgeInsets.only(top: 17.0, bottom: 17.0, left: 29),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.5, color: Colors.black),
                bottom: BorderSide(width: 0.5, color: Colors.black),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Privacy Policy',
                style: TextStyle() = GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        const SizedBox(height: 100),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 100,
            left: 41,
            right: 41,
          ),
          child: SizedBox(
            height: 56,
            width: 311,
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff31304D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Log Out",
                  style: TextStyle() = GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ),
        )
      ],
    );
  }
}
