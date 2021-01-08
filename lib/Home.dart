import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jgamer/QuizScreen.dart';
import 'package:jgamer/Spinner_wheel.dart';
import 'package:jgamer/coins.dart';
import 'package:jgamer/constants.dart';
import 'package:jgamer/firstpage.dart';
import 'package:jgamer/games_front_page.dart';
import 'package:jgamer/sloat_machine.dart';
import 'package:jgamer/store.dart';
import 'package:jgamer/third_page.dart';
import 'package:jgamer/user_profile.dart';
import 'package:jgamer/scratch_card.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final Map userData;
  List userKeys;
  Home(this.userData, this.userKeys);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currenIndex = 0;
  int score = 0;
  var currentCoins;
  http.Response linkData;
  http.Response leaderBoard;
  var shown = false;

  @override
  void initState() {
    currentCoins = widget.userKeys[1];
    loadData();
    getLeaderBoard();
    if (!widget.userKeys[2]["refrenceOffered"]) {
      Future.delayed(Duration.zero, () {
        var codeController = TextEditingController();
        showDialog(
          context: context,
          barrierDismissible: false,
          child: AlertDialog(
            title: Text(
              "Do you have a refferal code ? Enter here to get 50 diamonds now",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: codeController,
              decoration: InputDecoration(
                labelText: "Refferal Code",
                labelStyle: TextStyle(
                  fontFamily: "Quicksand",
                ),
              ),
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  refferalShown();
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.cancel),
                      SizedBox(width: 5),
                      Text(
                        "I don't have a code",
                        style: TextStyle(
                          fontFamily: "Quicksand",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  if (codeController.text.length >= 4 &&
                      codeController.text.length <= 6) {
                    await makeRefrence(codeController.text, context);
                    refferalShown();
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      child: AlertDialog(
                        title: Text(
                          "Invalid Refrence Code",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: klightDeepBlue,
                          child: Text(
                            "OK",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.check),
                      SizedBox(width: 5),
                      Text(
                        "OK",
                        style: TextStyle(
                          fontFamily: "Quicksand",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
    }
    super.initState();
  }

  Future<void> refferalShown() async {
    var temp = await http.get(
        "https://jgamer-347e6-default-rtdb.firebaseio.com/users/${widget.userKeys[0]}.json");
    var temp2 = jsonDecode(temp.body);
    temp2["refrenceOffered"] = true;
    widget.userKeys[2] = temp2;
    await http.patch(
        "https://jgamer-347e6-default-rtdb.firebaseio.com/users/${widget.userKeys[0]}.json",
        body: jsonEncode(temp2));
    var prefs = await SharedPreferences.getInstance();
    var userr = jsonDecode(prefs.getString("userData"));
    userr["user"]["refrenceOffered"] = true;
    prefs.setString("userData", jsonEncode(userr));
  }

  Future<void> makeRefrence(String code, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      ),
    );

    var refUrl =
        "https://jgamer-347e6-default-rtdb.firebaseio.com/refrences.json";
    var res = await http.get(
        "https://jgamer-347e6-default-rtdb.firebaseio.com/refrences/$code.json");
    var finalRes = jsonDecode(res.body);
    var temp = await http.get(refUrl).then((value) => jsonDecode(value.body));
    temp[code] = [
      {
        "referedTo": widget.userKeys[2]["referId"],
        "moneyCollectedbyReciever": true,
        "moneyCollectedbySender": false
      }
    ];
    Navigator.of(context).pop();
    if (finalRes == null) {
      await http.patch(
          "https://jgamer-347e6-default-rtdb.firebaseio.com/refrences.json",
          body: jsonEncode(temp));
      showDialog(
        context: context,
        barrierDismissible: false,
        child: AlertDialog(
          title: Text(
            "A Reference has been made",
            style: TextStyle(
              fontFamily: "Quicksand",
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: RaisedButton(
            onPressed: () async {
              var coinProv = Provider.of<Coins>(context, listen: false);
              coinProv.addCoins(50);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            color: klightDeepBlue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Reedem 50",
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Image.asset(
                  "assets/diamond.png",
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      var tempList = [];
      for (var ref in finalRes) {
        tempList.add(ref["referedTo"]);
      }
      if (!tempList.contains(widget.userKeys[2]["referId"])) {
        finalRes.add(
          {
            "moneyCollectedbyReceiver": false,
            "moneyCollectedbySender": false,
            "referedTo": widget.userKeys[2]["referId"],
          },
        );
      }
      for (var ref in finalRes) {
        if (ref["referedTo"] == widget.userKeys[2]["referId"]) {
          showDialog(
            context: context,
            barrierDismissible: false,
            child: AlertDialog(
              title: Text(
                "A Reference has been made",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: RaisedButton(
                onPressed: () async {
                  if (ref["moneyCollectedbyReceiver"] == false) {
                    var coinProv = Provider.of<Coins>(context, listen: false);
                    ref["moneyCollectedbyReceiver"] = true;
                    coinProv.addCoins(50);
                    await http.patch(
                        "https://jgamer-347e6-default-rtdb.firebaseio.com/refrences.json",
                        body: jsonEncode({code: finalRes}));
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      child: AlertDialog(
                        title: Text(
                          "Diamonds already collected",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: klightDeepBlue,
                          child: Text(
                            "OK",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
                color: klightDeepBlue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Reedem 50",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      "assets/diamond.png",
                      width: 16,
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    }
  }

  Future<http.Response> loadData() async {
    var link = "https://jgamer-347e6-default-rtdb.firebaseio.com/data.json";
    linkData = await http.get(link);
  }

  Future getLeaderBoard() async {
    leaderBoard = await http.get(
        "https://jgamer-347e6-default-rtdb.firebaseio.com/leaderboard.json");
  }

  Future<void> checkForRefrences() async {
    var res = await http.get(
        "https://jgamer-347e6-default-rtdb.firebaseio.com/refrences/${widget.userKeys[2]['referId']}.json");
    var temp = jsonDecode(res.body);
    for (var ref in temp) {
      print(ref["moneyCollectedbySender"] == false);
      if (ref["moneyCollectedbySender"] == false) {
        ref["moneyCollectedbySender"] = true;
        await http.patch(
            "https://jgamer-347e6-default-rtdb.firebaseio.com/refrences.json",
            body: jsonEncode({widget.userKeys[2]["referId"]: temp}));
        var users = await http
            .get("https://jgamer-347e6-default-rtdb.firebaseio.com/users.json");
        var finalUsers = jsonDecode(users.body);
        var userKeys = finalUsers.keys;
        var name;
        var email;
        for (var key in userKeys) {
          if (finalUsers[key]["referId"] == widget.userKeys[2]['referId']) {
            name = finalUsers[key]["Name"];
            email = finalUsers[key]["Email"];
          }
        }
        showDialog(
          context: context,
          barrierDismissible: false,
          child: AlertDialog(
            title: Text(
              "You just reffered our app to $name from $email",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: RaisedButton(
              onPressed: () {
                var coinProv = Provider.of<Coins>(context, listen: false);
                coinProv.addCoins(50);
                Navigator.of(context).pop();
              },
              color: klightDeepBlue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Reedem 50",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    "assets/diamond.png",
                    width: 16,
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    shown = false;
  }

  @override
  Widget build(BuildContext context) {
    var coinProvider = Provider.of<Coins>(context);
    coinProvider.loadUser(widget.userKeys[2], widget.userKeys[0]);
    currentCoins = coinProvider.getCoins;
    if (!shown) {
      checkForRefrences();
      shown = true;
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 30,
        toolbarHeight: 80,
        actions: [
          Image.asset(
            "assets/diamond.png",
            height: 25,
            width: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, right: 15, left: 10),
            child: Text(
              currentCoins.toString(),
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Quicksand",
              ),
            ),
          )
        ],
        title: Text(
          "jGamer",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: klightDeepBlue,
      ),
      body: <Widget>[
        FirstPage(),
        GamesFrontPage(leaderBoard),
        ThiredPage(),
        Store(linkData),
        UserProfile(widget.userData, widget.userKeys),
      ][currenIndex],
      bottomNavigationBar: CurvedNavigationBar(
        onTap: changePage,
        height: 50.0,
        items: <Widget>[
          Icon(
            Icons.card_giftcard_sharp,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.widgets,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.album_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.shopping_basket,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.perm_identity,
            size: 30,
            color: Colors.white,
          ),
        ],
        color: klightDeepBlue,
        buttonBackgroundColor: kdeepBlue,
        backgroundColor: Colors.white,
        animationCurve: Curves.ease,
        animationDuration: Duration(milliseconds: 600),
      ),
    );
  }

  void changePage(int index) {
    setState(() {
      currenIndex = index;
    });
  }
}
