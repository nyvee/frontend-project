import 'dart:convert';
import 'package:flutter/material.dart';
import '../components/appbar.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchProfile() async {
  final response = await http.get(Uri.parse(
      'https://gjq3q54r-8080.asse.devtunnels.ms/user/:id')); // Url testing

  if (response.statusCode == 200) {
    Map<String, dynamic> profile = jsonDecode(response.body);
    return profile['data']; // Return the profile data
  } else {
    throw Exception('Failed to load profile');
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 236, 229),
      appBar: MyAppBar(title: 'Profile', showSettingsButton: true),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProfile(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            String? avatarUrl = snapshot.data!['avatar'];
            String? username = snapshot.data!['username'];
            String? firstName = snapshot.data!['firstName'];
            String? lastName = snapshot.data!['lastName'];
            String? email = snapshot.data!['email'];

            return Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    avatarUrl != null
                        ? buildProfilePicture(avatarUrl)
                        : Container(),
                    buildProfileInfo(
                      username ?? 'Username',
                      firstName ?? 'First Name',
                      lastName ?? 'Last Name',
                      email ?? 'Email',
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // If there's an error, display the error
            return Text('Error: ${snapshot.error}');
          } else {
            // If the data is still loading, display a loading indicator
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget buildProfilePicture(String avatarUrl) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 120,
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 49, 48, 77),
            radius: 20,
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProfileInfo(
    String username,
    String firstName,
    String lastName,
    String email,
  ) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildInfoRow('Username', username),
          buildInfoRow('First Name', firstName),
          buildInfoRow('Last Name', lastName),
          buildInfoRow('Email', email),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 8.0, 8.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
