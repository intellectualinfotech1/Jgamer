import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Coins with ChangeNotifier {
  int coins;
  Map user;

  Future<void> loadUser(Map newUser) async {
    var prefs = await SharedPreferences.getInstance();
    user = newUser;
    coins = prefs.getInt("coins");
    notifyListeners();
  }

  addCoins(int value) async {
    var prefs = await SharedPreferences.getInstance();
    coins = coins + value;
    prefs.setInt("coins", coins);
    notifyListeners();
  }

  int get getCoins {
    return coins;
  }
}
