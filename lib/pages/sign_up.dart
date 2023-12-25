import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart';
import 'package:frontend_project/pages/login.dart';
import 'package:frontend_project/components/square_tile.dart';
import 'package:frontend_project/components/my_textfield.dart';
import 'package:frontend_project/components/my_textfield_username.dart';
import 'package:frontend_project/components/password_text_field_conf.dart';
import 'package:frontend_project/utils/size_config.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final signupuserController = TextEditingController();
  final signupemailController = TextEditingController();
  final signupfirstNameController = TextEditingController();
  final signuplastNameController = TextEditingController();
  final signuppassController = TextEditingController();
  final signupconfirmpassController = TextEditingController();
  bool _isLoading = false;
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  bool isPasswordMatch = true;
  SizeConfig sizeConfig = SizeConfig();
  bool isUsernameTaken = false;

  final InputDecoration normalInputDecoration = InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFb6bbc4), width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFb6bbc4), width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  final InputDecoration usernameInputDecoration = InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  void signUp(
    String username,
    String email,
    String firstName,
    String lastName,
    String password,
    String confirmPassword,
  ) async {
    setState(() {
      _isLoading = true;
    });

    setState(() {
      if (password != confirmPassword) {
        isPasswordMatch = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match!')),
        );
        _isLoading = false;
        return;
      } else {
        isPasswordMatch = true;
      }
    });

    if (!isPasswordMatch) return;

    try {
      Response response = await post(
        Uri.parse('https://ecommerce-api-ofvucrey6a-uc.a.run.app/user/register'),
        body: {
          'username': username,
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        var logger = Logger();
        logger.d('Account Created');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else if (response.statusCode == 400) {
        setState(() {
          isUsernameTaken = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The username is used, use another username!')),
        );
      } else {
        var logger = Logger();
        logger.d('Failed to create account');
      }
    } catch (e) {
      var logger = Logger();
      logger.d(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                SizedBox(
                  width: sizeConfig.widthSize(context, 97),
                  child: MyTextFieldU(
                    controller: signupuserController,
                    obscureText: false,
                    decoration: isUsernameTaken ? usernameInputDecoration : normalInputDecoration,
                  ),
                ),
                const SizedBox(height: 10),
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
                SizedBox(
                  width: sizeConfig.widthSize(context, 97),
                  child: MyTextField(
                    controller: signupemailController,
                    obscureText: false,
                  ),
                ),
                const SizedBox(height: 10),
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
                SizedBox(
                  width: sizeConfig.widthSize(context, 97),
                  child: MyTextField(
                    controller: signupfirstNameController,
                    obscureText: false,
                  ),
                ),
                const SizedBox(height: 10),
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
                SizedBox(
                  width: sizeConfig.widthSize(context, 97),
                  child: MyTextField(
                    controller: signuplastNameController,
                    obscureText: false,
                  ),
                ),
                const SizedBox(height: 10),
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
                SizedBox(
                  width: sizeConfig.widthSize(context, 97),
                  child: PasswordTextFieldE(
                    controller: signuppassController,
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
                const SizedBox(height: 10),
                SizedBox(
                  width: sizeConfig.widthSize(context, 97),
                  child: PasswordTextFieldE(
                    controller: signupconfirmpassController,
                    isObscure: _isObscureConfirmPassword,
                    onVisibilityChanged: (value) {
                      setState(() {
                        _isObscureConfirmPassword = value;
                      });
                    },
                    isPasswordMatch: isPasswordMatch,
                  ),
                ),
                const SizedBox(height: 50),
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
                        screenWidth > 600 ? screenWidth * 0.4 : screenWidth * 0.85,
                        63,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: !_isLoading
                        ? () {
                            signUp(
                              signupuserController.text.toString(),
                              signupemailController.text.toString(),
                              signupfirstNameController.text.toString(),
                              signuplastNameController.text.toString(),
                              signuppassController.text.toString(),
                              signupconfirmpassController.text.toString(),
                            );
                          }
                        : null,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text(
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
