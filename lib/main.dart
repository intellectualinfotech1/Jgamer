import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jgamer/Home.dart';
import 'package:jgamer/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
  var containsKey = prefs.containsKey("userData");
  Map userData;
  if (containsKey) {
    var tempUserData = prefs.getString("userData");
    userData = jsonDecode(tempUserData);
  }
  runApp(MaterialApp(
    home: containsKey ? Home(userData) : MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "jGamer",
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
