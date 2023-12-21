import 'package:flutter/material.dart';
import 'package:frontend_project/components/my_textfield.dart';
import 'package:frontend_project/pages/forgot_pass.dart';
import 'package:frontend_project/pages/home_page.dart';
import 'package:frontend_project/pages/sign_up.dart';
import 'package:frontend_project/components/square_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginuserController = TextEditingController();
  final loginpassController = TextEditingController();
  bool isLoading = false;

  void signIn() {
    setState(() {
      isLoading = true;
    });

    authenticateUser(loginuserController.text, loginpassController.text)
        .then((result) {
      setState(() {
        isLoading = false;
      });

      if (result) {
        // Navigate to the home page if authentication is successful
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Show an error message or handle authentication failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid username or password'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
  }

  Future<bool> authenticateUser(String username, String password) async {
  try {
    final dio = Dio();
    final response = await dio.post(
      'https://gjq3q54r-8080.asse.devtunnels.ms/user/login',
      data: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final responseData = response.data;
      final status = responseData['status'];
      if (status != null && status['code'] == 200) {
        // Authentication successful
        return true;
      }
    }
  } catch (error) {
    // Handle any errors during the API call
    print('Error during authentication: $error');
  }

  // Authentication failed
  return false;
}



  @override
Widget build(BuildContext context) {
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
                            // Navigate back to the login page
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
                          fontSize: 33,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),

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

              // Username/Email Label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Username/Email',
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

              // Username/Email TextField
              MyTextField(
                controller: loginuserController,
                obscureText: false,
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
              MyTextField(
                controller: loginpassController,
                obscureText: true,
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
                        // Navigate to the sign-up page
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPass()));
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

              GestureDetector(
  onTap: () {
    authenticateUser(loginuserController.text, loginpassController.text);
  },
  child: Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 10,
          offset: const Offset(10, 10),
        ),
      ],
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF31314D),
        minimumSize: const Size(350, 60),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: isLoading
          ? null
          : () {
              authenticateUser(loginuserController.text, loginpassController.text);
            },
      child: isLoading
          ? const CircularProgressIndicator()
          : Text(
              "Sign In",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
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
                        // Navigate to the sign-up page
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpPage()));
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

              // Social Sign In Buttons Section
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Sign In Button
                  SquareTile(buttonText: 'Continue With Google'),
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
