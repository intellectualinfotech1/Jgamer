import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jgamer/Home.dart';
import 'package:jgamer/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
  var containsKey = prefs.containsKey("userData");
  var userKeys;
  Map userData;
  if (containsKey) {
    var tempUserData = prefs.getString("userData");
    userData = jsonDecode(tempUserData);
    var tempKey = userData["key"];
    var tempCoins = userData["coins"];
    userKeys = [tempKey, tempCoins];
  }
  runApp(MaterialApp(
    title: "jGamer",
    debugShowCheckedModeBanner: false,
    home: containsKey ? Home(userData, userKeys) : MyApp(),
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
