import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:jgamer/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth with ChangeNotifier {
  Map userData;
  final varFacebookLogin = FacebookLogin();
  final varGoogleLogin = GoogleSignIn();
  final signUpUrl =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key= AIzaSyCf7uZkyXA1EL8B9y6nMqhIAXkL73F-7jo";
  final signInUrl =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key= AIzaSyCf7uZkyXA1EL8B9y6nMqhIAXkL73F-7jo";
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

  Future loginWithGoogle() async {
    await varGoogleLogin.signIn().then(
      (value) {
        userData = {
          "name": value.displayName,
          "id": value.id,
          "imgUrl": value.photoUrl,
          "email": value.email
        };
      },
    );
    return userData;
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

  Future logInWithEmail(String email, String password) async {
    var signUpRes = await http.post(
      signUpUrl,
      body: jsonEncode(
        {
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
      ),
    );
    var signInRes = await http.post(
      signInUrl,
      body: jsonEncode(
        {
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
      ),
    );
    var finalres = jsonDecode(signInRes.body);
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(
      "userData",
      jsonEncode({"email": email}),
    );
    return finalres.keys.contains("idToken");
  }

  Future<void> logOut(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => LoginScreen(),
      ),
    );
  }
}
