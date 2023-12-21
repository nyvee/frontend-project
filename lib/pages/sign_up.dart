import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_project/components/my_textfield.dart';
import 'package:frontend_project/pages/login.dart';
import 'package:frontend_project/components/square_tile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State <SignUpPage> {
  final signupuserController = TextEditingController();
  final signupemailController = TextEditingController();
  final signupfirstnameController = TextEditingController();
  final signuplastnameController = TextEditingController();
  final signuppassController = TextEditingController();
  final signupconfirmpassController = TextEditingController();
  bool isLoading = false;



    void signUpUser() {
    setState(() {
    isLoading = true;
    });

    // Create a Map of user data
    Map<String, String> userData = {
    'username': signupuserController.text,
    'email': signupemailController.text,
    'firstName': signupfirstnameController.text,
    'lastName': signuplastnameController.text,
    'password': signuppassController.text,
    'confirmPassword': signupconfirmpassController.text,
    };

    // Convert the Map to a JSON string
    String jsonData = json.encode(userData);

    // Send a POST request to the sign-up endpoint
    http.post(Uri.parse('https://gjq3q54r-8080.asse.devtunnels.ms/user/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonData,
    ).then((http.Response response) {
    setState(() {
      isLoading = false;
    });

 // Check the status code for the result
 if (response.statusCode == 200) {
   // If the server returns a 200 OK response, parse the JSON.
   Map<String, dynamic> jsonResponse = json.decode(response.body);
   print(jsonResponse);
   // You can now use the data in the JSON response to update your app's state
 } else {
   // If the server returns an error response, throw an exception.
   throw Exception('Failed to load user');
 }

 // Navigate to the login screen after a successful sign-up
 Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
 }).catchError((error) {
 // Handle any errors that occur during the request
 print('An error occurred: $error');
 });
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
                MyTextField(
                  controller: signupuserController,
                  obscureText: false,
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
                MyTextField(
                  controller: signupemailController,
                  obscureText: false,
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
                MyTextField(
                  controller: signupfirstnameController,
                  obscureText: false,
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
                MyTextField(
                  controller: signuplastnameController,
                  obscureText: false,
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

                // Password textfield
                MyTextField(
                  controller: signuppassController,
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // Confir Pass
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

                // Conf Pass Text field
                MyTextField(
                  controller: signupconfirmpassController,
                  obscureText: false,
                ),

                const SizedBox(height: 50),
                
                // Sign In Button
              Container(
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
                onPressed: isLoading ? null : signUpUser,
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
                  "Create Account",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Don't Have an Account Label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigate to the sign-up page
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
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

              // Social Sign In Buttons Section
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Sign In Button
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
