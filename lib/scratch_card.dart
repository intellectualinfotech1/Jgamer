import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jgamer/coins.dart';
import 'package:jgamer/Home.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scratcher/scratcher.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScratchCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: AppBody(),
      ),
    );
  }
}

class AppBody extends StatelessWidget {
  double _opacity = 0.0;
  var no;

  AppBody({this.no});

  var list = [
    0,
    10,
    50,
    100,
    150,
    200,
    10,
    250,
    300,
    20,
  ];

  Future<void> scratchCardDialog(BuildContext context) async {
    no = getRandomElement(list);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          title: Align(
            alignment: Alignment.center,
            child: Text(
              'You\'ve won a scratch card',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          content: StatefulBuilder(builder: (context, StateSetter setState) {
            return Scratcher(
              accuracy: ScratchAccuracy.low,
              threshold: 60,
              brushSize: 25,
              onThreshold: () {
                setState(() {
                  _onAlertButtonPressed(context);
                });
              },
              image: Image.asset('Image/scratchcard.jpg'),
              child: Container(
                height: 200,
                width: 300,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/diamond.png",
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      no.toString(),
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  void noScractchCardDialog(BuildContext context, Coins coinProv) {
    // var coinProv = Provider.of<Coins>(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "You have 0 free coupons left.\n\nCome back tommorrow to collect 5 free coupons. \n\nOr buy a new one.",
            style: TextStyle(
              fontFamily: "Quicksand",
              fontSize: 20,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 30),
          content: Container(
            height: 120,
            child: Column(
              children: [
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  padding: EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                OutlineButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text(
                          "Do you want to trade 60 diamonds for a scratch coupon ?",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 16,
                          ),
                        ),
                        content: OutlineButton(
                          onPressed: () async {
                            if (coinProv.getCoins >= 60) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              coinProv.reduceCoins(60);
                              scratchCardDialog(context);
                            } else {
                              showDialog(
                                context: context,
                                child: AlertDialog(
                                  title: Text(
                                    "You do not have enough diamonds",
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 16,
                                    ),
                                  ),
                                  content: OutlineButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "OK",
                                      style: TextStyle(
                                        fontFamily: "Quicksand",
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          padding: EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/diamond.png",
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "60",
                                style: TextStyle(
                                  fontFamily: "Quicksand",
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  padding: EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/diamond.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "60",
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> registerScratch(Coins coinProv) async {
    var prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("scratchAmount")) {
      prefs.setInt("scratchAmount", 5);
    }
    var remScr = prefs.getInt("scratchAmount");
    if (remScr == 0) {
      return false;
    }
    if (remScr == 1) {
      prefs.setString(
          "nextCoupons",
          DateTime.now()
              .add(Duration(days: 1))
              .subtract(
                Duration(
                  hours: DateTime.now().hour,
                  minutes: DateTime.now().minute,
                  seconds: DateTime.now().second,
                ),
              )
              .toIso8601String());
    }
    prefs.setInt("scratchAmount", remScr - 1);
    coinProv.changeCouponCount(prefs.getInt("scratchAmount"));
    return true;
  }

  void refreshCoupons() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("nextCoupons")) {
      if (DateTime.parse(prefs.getString("nextCoupons"))
          .isBefore(DateTime.now())) {
        prefs.remove("nextCoupons");
        prefs.remove("scratchAmount");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    refreshCoupons();
    var coinProv = Provider.of<Coins>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 20),
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                color: Colors.indigo,
                child: Column(
                  children: [
                    Text(
                      "Get A ScratchCard",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Quicksand",
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${coinProv.getCouponCount.toString()} free coupons remaining for today...",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Quicksand",
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                onPressed: () async {
                  var res = await registerScratch(coinProv);
                  if (res) {
                    scratchCardDialog(context);
                  } else {
                    noScractchCardDialog(context, coinProv);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  getRandomElement(List list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
  }

  _onAlertButtonPressed(context) {
    Alert(
      context: context,
      onWillPopActive: true,
      type: AlertType.success,
      title: "You Won",
      desc: no.toString(),
      style: AlertStyle(
        titleStyle: TextStyle(
          fontFamily: "Quicksand",
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        descStyle: TextStyle(
          fontFamily: "Quicksand",
          fontSize: 20,
        ),
      ),
      buttons: [
        DialogButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Reedem",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  no.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Image.asset(
                  "assets/diamond.png",
                  width: 15,
                  height: 15,
                ),
              ],
            ),
            onPressed: () {
              var coins = Provider.of<Coins>(context, listen: false);
              coins.addCoins(no);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            })
      ],
    ).show();
  }
}
