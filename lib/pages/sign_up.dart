//import dependencies
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart';
//import pages
import 'package:frontend_project/pages/login.dart';
//import components
import 'package:frontend_project/components/square_tile.dart';
import 'package:frontend_project/components/my_textfield.dart';
import 'package:frontend_project/components/password_text_field.dart';
//import utils
import 'package:frontend_project/utils/size_config.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final signupuserController = TextEditingController();
  final signupemailController = TextEditingController();
  final signupfirstnameController = TextEditingController();
  final signuplastnameController = TextEditingController();
  final signuppassController = TextEditingController();
  final signupconfirmpassController = TextEditingController();
  bool isLoading = false;
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  SizeConfig sizeConfig = SizeConfig();

  void signUp(
    String username,
    String email,
    String firstname,
    String lastname,
    String password,
    String confirmPassword,
  ) async {
    if (password != confirmPassword) {
      var logger = Logger();
      logger.d('Passwords do not match');
      return;
    }

    try {
      Response response = await post(
        Uri.parse('https://gjq3q54r-8080.asse.devtunnels.ms/user/register'),
        body: {
          'username': username,
          'email': email,
          'firstname': firstname,
          'lastname': lastname,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Handle success if needed
      } else {
        var logger = Logger();
        logger.d('Failed to create account');
      }
    } catch (e) {
      var logger = Logger();
      logger.d(e.toString());
    }
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

                // Back Arrow Icon
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.0),
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

                const SizedBox(height: 35),

                // Gateway Text
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          'Your Gateway to!',
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, left: 40),
                        child: Text(
                          'Shopping Bliss',
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, left: 70),
                        child: Text(
                          'Join Us Now!',
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 45),

                // Username
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

                const SizedBox(height: 7),

                // Username TextField
                SizedBox(
                  width: sizeConfig.widthSize(context, 97),
                  child: MyTextField(
                    controller: signupuserController,
                    obscureText: false,
                  ),
                ),

                const SizedBox(height: 10),

                // Email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
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

                // Email TextField
                SizedBox(
                  width: sizeConfig.widthSize(context, 97),
                  child: MyTextField(
                    controller: signupemailController,
                    obscureText: false,
                  ),
                ),

                const SizedBox(height: 10),

                // First Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'First Name',
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

                // First Name TextField
                SizedBox(
                  width: sizeConfig.widthSize(context, 97),
                  child: MyTextField(
                    controller: signupfirstnameController,
                    obscureText: false,
                  ),
                ),

                const SizedBox(height: 10),

                // Last Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Last Name (optional)',
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

                // Last Name TextField
                SizedBox(
                  width: sizeConfig.widthSize(context, 97),
                  child: MyTextField(
                    controller: signuplastnameController,
                    obscureText: false,
                  ),
                ),

                const SizedBox(height: 10),

                // Password
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
                    controller: signuppassController,
                    isObscure: _isObscurePassword,
                    onVisibilityChanged: (value) {
                      setState(() {
                        _isObscurePassword = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // Confirm Password
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

                const SizedBox(height: 10),

                // Confirm Password TextField
                SizedBox(
                  width: sizeConfig.widthSize(context, 97),
                  child: PasswordTextField(
                    controller: signupconfirmpassController,
                    isObscure: _isObscureConfirmPassword,
                    onVisibilityChanged: (value) {
                      setState(() {
                        _isObscureConfirmPassword = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 50),

                // Sign Up Button
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
                  child:ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF31314D),
                    minimumSize: Size(
                        screenWidth > 600 ? screenWidth * 0.4 : screenWidth * 0.85,
                        63),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    signUp(
                      signupuserController.text.toString(),
                      signupemailController.text.toString(),
                      signupfirstnameController.text.toString(),
                      signuplastnameController.text.toString(),
                      signuppassController.text.toString(),
                      signupconfirmpassController.text.toString(),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                ),
                ),

                const SizedBox(height: 10),

                // Already Have an Account Label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                        },
                        child: Text(
                          'Already have an account?',
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

                const SizedBox(height: 50),

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

                // Social Sign Up Buttons Section
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google Sign Up Button
                    SquareTile(buttonText: 'Sign Up With Google'),
                  ],
                ),

                const SizedBox(height: 50),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
