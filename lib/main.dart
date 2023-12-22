import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

import 'pages/login.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('myBox');
  var logger = Logger();
  logger.d('Box opened: ${box.isOpen}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
