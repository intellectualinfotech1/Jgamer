import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Coins with ChangeNotifier {
  int coins;
  Map user;
  String userKey;

  Future<void> loadUser(Map newUser, String newUserKey) async {
    var prefs = await SharedPreferences.getInstance();
    user = newUser;
    userKey = newUserKey;
    coins = prefs.getInt("coins");
    notifyListeners();
  }

  addCoins(int value) async {
    var prefs = await SharedPreferences.getInstance();
    coins = coins + value;
    var databaseUrl =
        "https://jgamer-347e6-default-rtdb.firebaseio.com/users/$userKey.json";
    prefs.setInt("coins", coins);
    var res =
        await http.get(databaseUrl).then((value) => jsonDecode(value.body));
    res["Coins"] = coins;
    await http.patch(databaseUrl, body: jsonEncode(res));
  }

  int get getCoins {
    return coins;
  }
}
