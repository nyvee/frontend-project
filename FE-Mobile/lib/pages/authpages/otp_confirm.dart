// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'change_pass.dart';
import 'package:logger/logger.dart';

class OtpCode extends StatefulWidget {
  const OtpCode({Key? key}) : super(key: key);

  @override
  OtpCodeState createState() => OtpCodeState();
}

class OtpCodeState extends State<OtpCode> {
  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  bool isLoading = false;
  String? errorMessage;
  final logger = Logger();
  bool isError = false;

  void sendOtp() async {
    setState(() {
      isLoading = true;
    });

    const apiEndpoint =
        'https://ecommerce-api-ofvucrey6a-uc.a.run.app/user/otp';

    try {
      String otp = otpControllers.map((controller) => controller.text).join();

      final response = await http.post(Uri.parse(apiEndpoint), body: {
        'otp': otp,
      });

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['status']['token'];
        logger.d('Token: $token');
        final box = Hive.box('myBox');
        box.put('token', token);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ChangePass(),
          ),
        );
      } else {
        setState(() {
          errorMessage = 'OTP you entered is incorrect';
          isError = true;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'OTP you entered is incorrect';
        isError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleBackspace(int index) {
    if (index > 0 && otpControllers[index].text.isEmpty) {
      FocusScope.of(context).previousFocus();
    }
  }

  Row buildOtpFieldsRow() {
    List<Widget> otpFields = [];

    for (int i = 0; i < otpControllers.length; i++) {
      otpFields.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: otpControllers[i],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: const TextStyle(fontSize: 24),
              decoration: InputDecoration(
                counterText: "",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isError ? Colors.red : Colors.black,
                    width: 2.0,
                  ),
                ),
              ),
              onChanged: (value) {
                // Move to the next TextField when a digit is entered
                if (value.isNotEmpty && i < otpControllers.length - 1) {
                  FocusScope.of(context).nextFocus();
                } else if (value.isEmpty) {
                  handleBackspace(i);
                }
              },
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: otpFields,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF0EBE5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 85,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.black,
                              size: 60,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Lu\u2019mercé',
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 75),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Insert OTP Here!',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 75),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: buildOtpFieldsRow(),
                ),
                const SizedBox(height: 20),
                if (isError)
                  Text(
                    errorMessage!,
                    style: GoogleFonts.montserrat(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF31314D),
                    minimumSize: Size(
                      screenWidth > 600
                          ? screenWidth * 0.4
                          : screenWidth * 0.85,
                      63,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
