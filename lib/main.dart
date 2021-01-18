import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jgamer/Home.dart';
import 'package:jgamer/coins.dart';
import 'package:jgamer/login_screen.dart';
import 'package:provider/provider.dart';
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
    var tempCoins = prefs.getInt("coins");
    var user = userData["user"];
    userKeys = [
      tempKey,
      tempCoins,
      user,
    ];
  }
  runApp(ChangeNotifierProvider(
    create: ( context) => Coins(),
    child: MaterialApp(
      title: "jGamer",
      debugShowCheckedModeBanner: false,
      home: containsKey ? Home(userData, userKeys) : MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Coins(),
      child: MaterialApp(
        title: "jGamer",
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );

  }
}