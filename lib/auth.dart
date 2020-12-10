import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:jgamer/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  Map userData;
  final varFacebookLogin = FacebookLogin();
  bool isLoggedIn = false;

  bool get loginStatus {
    return isLoggedIn;
  }

  void toggleLoginStatus() {
    if (isLoggedIn) {
      isLoggedIn = false;
    } else {
      isLoggedIn = true;
    }
    notifyListeners();
  }

  Future<Map> loginWithFB() async {
    final res = await varFacebookLogin.logIn(["email"]);

    switch (res.status) {
      case FacebookLoginStatus.loggedIn:
        final token = res.accessToken.token;
        final graphUrl =
            "https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token";
        final graphResTemp = await http.get(graphUrl);
        final graphRes = jsonDecode(graphResTemp.body);
        var name = graphRes["name"];
        var imgUrl = graphRes["picture"]["data"]["url"];
        var email = graphRes.keys.contains("email") ? graphRes["email"] : null;
        var id = graphRes["id"];
        userData = {"name": name, "id": id, "imgUrl": imgUrl, "email": email};
        var prefs = await SharedPreferences.getInstance();
        prefs.setString(
          "userData",
          jsonEncode(
              {"name": name, "id": id, "email": email, "imgUrl": imgUrl}),
        );
        notifyListeners();
        return {"status": true, "data": userData};
        break;
      case FacebookLoginStatus.cancelledByUser:
        return {"status": false, "data": null};
      case FacebookLoginStatus.error:
        return {"status": false, "data": null};
        break;
    }
  }

  Future<void> logOut(BuildContext context) async {
    varFacebookLogin.logOut();
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => LoginScreen(),
      ),
    );
  }
}
