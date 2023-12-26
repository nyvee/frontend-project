import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'router/navbar.dart';
import 'pages/authpages/login.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('myBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppEntryPoint(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  void _onItemSelected(int index) {
    setState(() {
      _controller.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyBottomNavBar(
        controller: _controller,
        currentIndex: _controller.index,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}

class AppEntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var box = Hive.box('myBox');
    var token = box.get('token');

    if (token == null) {
      return LoginPage();
    } else {
      return MyHomePage();
    }
  }
}
