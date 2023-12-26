import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_project/components/top_app_bar.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  PrivacyPageState createState() => PrivacyPageState();
}

class PrivacyPageState extends State<PrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Privacy Policy', showSettingsButton: false),
      body: const BodyPage(),
      backgroundColor: const Color(0xffF0ECE5),
    );
  }
}

class BodyPage extends StatelessWidget {
  const BodyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        top: 30,
        right: 38,
        left: 37,
        bottom: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: const Color(0xff31304D),
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 8),
          buildListItem(
              'WHO is Responsible for the Processing of Your Personal Data?'),
          buildListItem('WHAT Personal Data Do We Collect and WHEN?'),
          buildListItem('WHY and HOW Do We Use Your Personal Data?'),
          buildListItem('SHARING of Your Personal Data'),
          buildListItem('PROTECTION and MANAGEMENT of Your Personal Data'),
          buildListItem('YOUR RIGHTS Relating to Your Personal Data?'),
          buildListItem('CHANGES to Our Privacy Policy'),
          buildListItem('QUESTIONS and Feedback'),
        ],
      ),
    );
  }

  Widget buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          const Text(
            '\u2022', // Karakter titik
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
