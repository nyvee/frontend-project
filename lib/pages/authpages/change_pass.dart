import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'login.dart';
import 'package:logger/logger.dart';
import 'package:frontend_project/components/password_text_field_conf.dart';
import 'package:frontend_project/utils/size_config.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({Key? key}) : super(key: key);

  @override
  ChangePassState createState() => ChangePassState();
}

class ChangePassState extends State<ChangePass> {
  final rppassController = TextEditingController();
  final rpcpassController = TextEditingController();
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  bool isLoading = false;
  bool isPasswordMatch = true;
  final logger = Logger();
  SizeConfig sizeConfig = SizeConfig();

  Future<void> changepass() async {
    setState(() {
      isLoading = true;
    });

    final box = Hive.box('myBox');
    if (!box.containsKey('token')) {
      logger.d('Token is not in the box');
      setState(() {
        isLoading = false;
      });
      return;
    }

    final String? token = box.get('token');

    if (token != null) {
      final headers = {'Authorization': 'Bearer $token'};

      if (rppassController.text != rpcpassController.text) {
        setState(() {
          isPasswordMatch = false;
          isLoading = false; 
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      } else {
        setState(() {
          isPasswordMatch = true;
        });
      }

      try {
        final response = await http.post(
          Uri.parse('https://ecommerce-api-ofvucrey6a-uc.a.run.app/user/reset'),
          body: {
            'password': rppassController.text,
          },
          headers: headers,
        );

        if (response.statusCode == 200) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
          logger.d('Password Changed');
        } else {
          logger.d('Failed to change password');
        }
      } catch (e) {
        logger.d('Error changing password: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('Token is null');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        'Reset password',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 45),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your new password must be different',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'from your previously used password.',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 73),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                SizedBox(
                  width: sizeConfig.widthSize(context, 97),
                  child: PasswordTextFieldE(
                    controller: rppassController,
                    isObscure: _isObscurePassword,
                    onVisibilityChanged: (value) {
                      setState(() {
                        _isObscurePassword = value;
                      });
                    },
                    isPasswordMatch: isPasswordMatch,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Password',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                SizedBox(
                  width: sizeConfig.widthSize(context, 97),
                  child: PasswordTextFieldE(
                    controller: rpcpassController,
                    isObscure: _isObscureConfirmPassword,
                    onVisibilityChanged: (value) {
                      setState(() {
                        _isObscureConfirmPassword = value;
                      });
                    },
                    isPasswordMatch: isPasswordMatch,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(10, 10),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : changepass,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF31314D),
                      minimumSize: const Size(350, 60),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                      "Reset Password",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
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

class TokenModel extends HiveObject {
  @HiveField(0)
  late String token;
}
