import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:jgamer/login_screen.dart';
import 'package:jgamer/coins.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  Map userData;
  int coins = 0;
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
  }

  Future loginWithGoogle() async {
    var userList;
    await varGoogleLogin.signIn().then(
      (value) async {
        var prefs = await SharedPreferences.getInstance();
        userData = {
          "name": value.displayName,
          "id": value.id,
          "imgUrl": value.photoUrl,
          "email": value.email
        };

        userList = await registerUser(
            userData["id"], userData["name"], userData["email"]);
        prefs.setString(
          "userData",
          jsonEncode({
            "name": value.displayName,
            "id": value.id,
            "email": value.email,
            "imgUrl": value.photoUrl,
            "key": userList[0],
            "coins": userList[1],
            "user": userList[2],
            "name": userList[2]["Name"],
          }),
        );
        prefs.setInt("coins", userList[1]);
      },
    );
    return [
      userData,
      userList,
    ];
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

        var userList = await registerUser(id, name, email);
        prefs.setString(
          "userData",
          jsonEncode(
            {
              "name": name,
              "id": id,
              "email": email,
              "imgUrl": imgUrl,
              "key": userList[0],
              "coins": userList[1],
              "user": userList[2],
              "name": userList[2]["Name"],
            },
          ),
        );
        prefs.setInt("coins", userList[1]);

        return {"status": true, "data": userData, "keys": userList};
        break;
      case FacebookLoginStatus.cancelledByUser:
        return {"status": false, "data": null};
      case FacebookLoginStatus.error:
        return {"status": false, "data": null};
        break;
    }
  }

  Future logInWithEmail(String email, String password, String name) async {
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
    print(finalres);
    var userList =
        await registerUser(jsonDecode(signUpRes.body)["localId"], name, email);
    prefs.setString(
      "userData",
      jsonEncode(
        {
          "email": email,
          "key": userList[0],
          "coins": userList[1],
          "user": userList[2],
          "name": userList[2]["Name"],
        },
      ),
    );
    prefs.setInt("coins", userList[1]);
    prefs.setString("userKeys", userList.toString());
    return [finalres.keys.contains("idToken"), userList];
  }

  Future<void> logOut(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => LoginScreen(),
      ),
    );
  }

  Future<List> registerUser(String uId, String name, String email) async {
    var user;
    var userKey;
    var userKey2;
    var d;
    var databaseUrl =
        "https://jgamer-347e6-default-rtdb.firebaseio.com/users.json";
    await http.get(databaseUrl).then(
      (value) async {
        var users = jsonDecode(value.body);
        if (users != null) {
          user = null;
          userKey = null;
          for (var key in users.keys) {
            if ((users[key]["userId"] == uId) ||
                (users[key]["Email"] == email)) {
              user = users[key];
              user["Name"] = name;
              userKey = key;
            }
          }
        }
        if (user == null) {
          var refId = await getRefData();
          await http.post(
            databaseUrl,
            body: jsonEncode(
              {
                "userId": uId,
                "Name": name,
                "Email": email,
                "Coins": coins,
                "referId": refId,
                "refrenceOffered": false,
              },
            ),
          );
          await http.get(databaseUrl).then(
            (value) async {
              var users = jsonDecode(value.body);
              for (var key in users.keys) {
                if ((users[key]["userId"] == uId && uId.isNotEmpty) ||
                    (users[key]["Email"] == email && email.isNotEmpty)) {
                  user = users[key];
                  user["Name"] = name;
                  userKey = key;
                }
              }
            },
          );
        }
      },
    );
    return [userKey, user["Coins"], user];
  }

  getRefData() async {
    var refId = await http.get(
        "https://jgamer-347e6-default-rtdb.firebaseio.com/latestRefId.json");
    var temp = jsonDecode(refId.body);
    var temp2 = int.parse(temp["latestId"]);
    var temp3 = (temp2 + 1).toString();
    await http.patch(
      "https://jgamer-347e6-default-rtdb.firebaseio.com/latestRefId.json",
      body: jsonEncode(
        {"latestId": temp3},
      ),
    );
    return temp2.toString();
  }
}
