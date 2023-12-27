// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../components/top_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:mime/mime.dart';

final logger = Logger();

String token = Hive.box('myBox').get('token');

Future<Map<String, dynamic>> fetchProfile(String token, String id) async {
  final url = Uri.parse(
      'https://ecommerce-api-ofvucrey6a-uc.a.run.app/user/profile/$id');
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
    logger.e('Status code: ${response.statusCode}');
    logger.e('Response body: ${response.body}');
    throw Exception('Failed to load profile');
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 236, 229),
      appBar: const MyAppBar(title: 'Profile', showSettingsButton: true),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProfile(token, ''),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            String id = snapshot.data!['_id'];
            String avatarUrl =
                'https://ecommerce-api-ofvucrey6a-uc.a.run.app/user/avatar/$id';
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
                    buildProfilePicture(avatarUrl, id),
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
                        decoration: const BoxDecoration(
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

  Widget buildProfilePicture(String avatarUrl, String id) {
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
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  logger.i('Image selected: ${image.path}');

                  // Extract the file name from the path
                  final fileName = image.path.split('/').last;
                  logger.i('File name: $fileName');

                  logger.i("File extension: ${path.extension(image.path)}");
                  final mimeType = lookupMimeType(image.path);
                  if (mimeType != null && mimeType.startsWith('image/')) {
                    // File is an image
                    try {
                      final imageFile = File(image.path);
                      img.decodeImage(imageFile.readAsBytesSync());
                      final url = Uri.parse(
                          'https://ecommerce-api-ofvucrey6a-uc.a.run.app/user/avatar');
                      final request = http.MultipartRequest('POST', url)
                        ..headers['Authorization'] = 'Bearer $token'
                        ..files.add(await http.MultipartFile.fromPath(
                            'avatar', image.path));
                      try {
                        final response = await request.send();
                        if (response.statusCode == 200) {
                          logger.i('Avatar updated');
                          setState(() {});
                        } else {
                          logger.e('Status code: ${response.statusCode}');
                          logger.e(
                              'Response body: ${await response.stream.bytesToString()}');
                        }
                      } catch (error) {
                        logger.e('Error uploading avatar: $error');
                      }
                    } catch (e) {
                      logger.e("Error: File is not an image - $e");
                    }
                  } else {
                    logger.e('Selected file is not an image');
                  }
                } else {
                  logger.e('Image selection cancelled');
                }
              },
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
