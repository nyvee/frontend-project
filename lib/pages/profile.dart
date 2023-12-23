import 'dart:convert';
import 'package:flutter/material.dart';
import '../components/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTg2ZGI2YjA1OTBhZGE4YjhmOWI1MDEiLCJpYXQiOjE3MDMzNDY2NTksImV4cCI6MTcwNTkzODY1OX0.X1eZMjOa0qse1yFOHz5593JXMUvn7ETzbki7MPcZghc';

Future<Map<String, dynamic>> fetchProfile(String token, String id) async {
  final url =
      Uri.parse('https://gjq3q54r-8080.asse.devtunnels.ms/user/profile/$id');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> profile = jsonDecode(response.body);
    return profile['data'];
  } else {
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
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
        future: fetchProfile(token, ''),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            String id = snapshot.data!['_id'];
            String avatarUrl =
                'https://gjq3q54r-8080.asse.devtunnels.ms/user/avatar/$id';
            String username = snapshot.data!['username'];
            String firstName = snapshot.data!['firstName'];
            String lastName = snapshot.data!['lastName'];
            String email = snapshot.data!['email'];

            return Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    buildProfilePicture(avatarUrl),
                    buildProfileInfo(
                      username,
                      firstName,
                      lastName,
                      email,
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildShimmerProfileInfo(),
                    ],
                  ),
                ),
              ),
            );
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

  Widget buildShimmerProfileInfo() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildShimmerInfoRow(),
          buildShimmerInfoRow(),
          buildShimmerInfoRow(),
          buildShimmerInfoRow(),
        ],
      ),
    );
  }

  Widget buildShimmerInfoRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 8.0, 8.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 15,
            color: Colors.white,
          ),
          const SizedBox(height: 5),
          Container(
            width: double.infinity,
            height: 20,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
