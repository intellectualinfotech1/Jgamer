import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jgamer/coins.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scratcher/scratcher.dart';
import 'package:provider/provider.dart';

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

  Future<void> scratchCardDialog(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    borderSide: BorderSide.none,
                  ),
                  color: Colors.indigo,
                  child: Text(
                    "Get A ScratchCard",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Quicksand",
                      fontSize: 25,
                    ),
                  ),
                  onPressed: () {
                    scratchCardDialog(context);
                  }),
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
