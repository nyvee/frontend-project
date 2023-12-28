// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jwt_decode/jwt_decode.dart';

// Import Pages
import '/pages/authpages/forgot_pass.dart';
import '/main.dart';
import '/pages/authpages/sign_up.dart';

// Import Components
import 'package:frontend_project/components/my_textfield.dart';
import 'package:frontend_project/components/square_tile.dart';
import 'package:frontend_project/components/password_text_field.dart';

// Import Utils
import 'package:frontend_project/utils/size_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // Controllers for TextFields
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Loading State
  bool _isLoading = false;
  bool _isObscurePassword = true;

  // logger
  final logger = Logger();

  // Instantiate SizeConfig
  SizeConfig sizeConfig = SizeConfig();

  void login(String username, password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Response response = await post(
        Uri.parse('https://ecommerce-api-ofvucrey6a-uc.a.run.app/user/login'),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String token = responseBody['token'];

        Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
        String? userId = decodedToken['_id'];

        var box = Hive.box('myBox');
        box.put('token', token);
        box.put('userId', userId);
        logger.d('Login successfully');
        printToken();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
      } else {
        logger.d('Failed to login');
      }
    } catch (e) {
      logger.d(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void printToken() async {
    var box = Hive.box('myBox');
    String? token = box.get('token');
    logger.d('Token: $token');
    logger.d('ID: ${box.get('userId')}');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF0EBE5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 15),

                // Welcome Message
                Padding(
                  padding: const EdgeInsets.only(left: 45),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          'Welcome Back!',
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, right: 30),
                        child: Text(
                          'Let\u2019s Continue the',
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      Text(
                        'Shopping Spree!',
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

                // Username Label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Username TextField
                SizedBox(
                  width: sizeConfig.widthSize(context, 97),
                  child: MyTextField(
                    controller: usernameController,
                    obscureText: false,
                  ),
                ),

                const SizedBox(height: 10),

                // Password Label
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

                const SizedBox(height: 10),

                // Password TextField
                SizedBox(
                  width: sizeConfig.widthSize(context, 97),
                  child: PasswordTextField(
                    controller: passwordController,
                    isObscure: _isObscurePassword,
                    onVisibilityChanged: (value) {
                      setState(() {
                        _isObscurePassword = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // Forgot Password Label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ForgotPass()));
                        },
                        child: Text(
                          'Forgot your password?',
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF1414ed),
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF31314D),
                      minimumSize: Size(
                          screenWidth > 600
                              ? screenWidth * 0.4
                              : screenWidth * 0.85,
                          63),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: !_isLoading
                        ? () {
                            login(usernameController.text.toString(),
                                passwordController.text.toString());
                          }
                        : null,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            'Sign In',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 15),

                // Don't Have an Account Label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignUpPage()));
                        },
                        child: Text(
                          'Don\'t have an account yet?',
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF1414ed),
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Divider Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          indent: 7,
                          thickness: 1.3,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'or',
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          endIndent: 7,
                          thickness: 1.3,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 23),

                // Google Sign In Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SquareTile(
                          buttonText: 'Continue With Google',
                          onPressed: () {
                            // Navigate to the Google login link
                            final Uri googleUri = Uri.parse(
                                'https://ecommerce-api-ofvucrey6a-uc.a.run.app/auth/google');
                            launchUrl(googleUri);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
