import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
import 'package:jgamer/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import './displayScore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'coins.dart';
import 'package:provider/provider.dart';

class Roulette extends StatefulWidget {
  @override
  _RouletteState createState() => _RouletteState();
}

class _RouletteState extends State<Roulette> {
  final StreamController _dividerController = StreamController<int>();
  var isSpinActive = true;
  var currentScore;

  final _wheelNotifier = StreamController<double>();

  dispose() {
    _dividerController.close();
    _wheelNotifier.close();
  }

  Future<bool> registerSpin(Coins coinProv) async {
    var prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("spinAmount")) {
      prefs.setInt("spinAmount", 5);
    }
    var remSpin = prefs.getInt("spinAmount");
    if (remSpin == 0) {
      return false;
    }
    if (remSpin == 1) {
      prefs.setString(
          "nextSpins",
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
    prefs.setInt("spinAmount", remSpin - 1);
    coinProv.changeSpinCount(prefs.getInt("spinAmount"));
    return true;
  }

  void refreshSpins() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("nextSpins")) {
      if (DateTime.parse(prefs.getString("nextSpins"))
          .isBefore(DateTime.now())) {
        prefs.remove("nextSpins");
        prefs.remove("spinAmount");
      }
    }
  }

  void noSpinDialog(BuildContext context, Coins coinProv) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(
          "You have 0 free spins left.\n\nCome back tommorrow to collect 5 free spins. \n\nOr buy a new one.",
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
                        "Do you want to trade 70 diamonds for a spin ?",
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 16,
                        ),
                      ),
                      content: OutlineButton(
                        onPressed: () {
                          if (coinProv.getCoins >= 70) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            coinProv.reduceCoins(70);
                            Future.delayed(
                              Duration(milliseconds: 5000),
                              () {
                                _onAlertButtonPressed(context, currentScore);
                                setState(() {
                                  isSpinActive = true;
                                });
                              },
                            );
                            _wheelNotifier.sink.add(_generateRandomVelocity());
                            setState(
                              () {
                                isSpinActive = false;
                              },
                            );
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
                              "70",
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
                      "70",
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    refreshSpins();
    var coinProv = Provider.of<Coins>(context);
    var currentCoins = coinProv.getCoins;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: klightDeepBlue,
        toolbarHeight: 60,
        actions: [
          Image.asset(
            "assets/diamond.png",
            height: 25,
            width: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 13, right: 15, left: 10),
            child: Text(
              currentCoins.toString(),
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Quicksand",
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    child: SpinningWheel(
                      Image.asset('Image/roulette-8-300.jpeg'),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      initialSpinAngle: _generateRandomAngle(),
                      spinResistance: 0.6,
                      canInteractWhileSpinning: false,
                      dividers: 8,
                      onUpdate: _dividerController.add,
                      onEnd: _dividerController.add,
                      secondaryImage: Image.asset('Image/cpointer.png'),
                      secondaryImageHeight: 50,
                      secondaryImageWidth: 50,
                      shouldStartOrStop: _wheelNotifier.stream,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: _dividerController.stream,
              builder: (context, snapshot) {
                currentScore = snapshot.data;
                return Container();
              },
            ),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.2,
              child: RaisedButton(
                child: Column(
                  children: [
                    Text(
                      "Spin",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Quicksand",
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "${coinProv.getSpinCount.toString()} free spins remaining for today...",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Quicksand",
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                color: klightDeepBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                ),
                onPressed: isSpinActive
                    ? () async {
                        var res = await registerSpin(coinProv);
                        if (res) {
                          Future.delayed(
                            Duration(milliseconds: 5000),
                            () {
                              _onAlertButtonPressed(context, currentScore);
                              setState(() {
                                isSpinActive = true;
                              });
                            },
                          );
                          _wheelNotifier.sink.add(_generateRandomVelocity());
                          setState(() {
                            isSpinActive = false;
                          });
                        } else {
                          noSpinDialog(context, coinProv);
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _generateRandomVelocity() => (Random().nextDouble() * 10000) + 10000;

  double _generateRandomAngle() => Random().nextDouble() * pi * 2;
}

class RouletteScore extends StatelessWidget {
  final int selected;
  var number;

  final Map<int, String> labels = {
    1: '100',
    2: '0',
    3: '5',
    4: '20',
    5: '0',
    6: '10',
    7: '0',
    8: '30',
  };

  RouletteScore(this.selected);

  @override
  Widget build(BuildContext context) {
    number = labels[selected];
    return Text('${labels[selected]}', style: TextStyle(fontSize: 24.0));
  }
}

_onAlertButtonPressed(context, currentScore) {
  final Map<int, String> labels = {
    1: '100',
    2: '0',
    3: '5',
    4: '20',
    5: '0',
    6: '10',
    7: '0',
    8: '30',
  };
  Alert(
    context: context,
    type: AlertType.success,
    title: int.parse(labels[currentScore]) == 0
        ? "Better Luck Next Time"
        : "Congratulations",
    desc: 'you won ${labels[currentScore]} diamonds',
    style: AlertStyle(
      titleStyle: TextStyle(
        fontFamily: "Quicksand",
        fontSize: 25,
      ),
      descStyle: TextStyle(
        fontFamily: "Quicksand",
        fontSize: 20,
      ),
    ),
    onWillPopActive: true,
    buttons: [
      DialogButton(
        radius: BorderRadius.all(
          Radius.circular(10),
        ),
        child: Text(
          "Collect",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          var coinProv = Provider.of<Coins>(context, listen: false);
          coinProv.addCoins(int.parse(labels[currentScore]));
          Navigator.of(context).pop();
        },
      ),
    ],
  ).show();
}
