import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roller_list/roller_list.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'coins.dart';
import 'constants.dart';

class SlotMachine extends StatefulWidget {



  @override
  State<StatefulWidget> createState() {
    return _SlotMachineState();
  }
}

class _SlotMachineState extends State<SlotMachine> {
  static const _ROTATION_DURATION = Duration(milliseconds: 300);
  final List<Widget> slots = _getSlots();
  int first, second, third;
  final leftRoller = new GlobalKey<RollerListState>();
  final rightRoller = new GlobalKey<RollerListState>();
  final centerRoller = new GlobalKey<RollerListState>();
  Timer rotator;
  Random _random = new Random();

  @override
  void initState() {
    first = 0;
    second = 0;
    third = 0;
    super.initState();
  }

  @override
  void dispose() {
    rotator?.cancel();
    super.dispose();
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
                        "Do you want to trade 40 diamonds for a spin ?",
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 16,
                        ),
                      ),
                      content: OutlineButton(
                        onPressed: () {
                          if (coinProv.getCoins >= 40) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            coinProv.reduceCoins(40);
                            _startRotating();
                            Future.delayed(
                              Duration(milliseconds: 5000),
                                  () {
                                _finishRotating();
                              },
                            );
                            Future.delayed(
                              Duration(milliseconds: 6000),
                                  () {
                                if (first == second || second == third || third == first) {
                                  _onBasicAlertPressed(context);
                                } else if (first == second && third == second) {
                                  _onBasicAlertPressed1(context);
                                }
                                else if (first != second && third != second) {
                                  _onBasicAlertPressed3(context);
                                }
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
                              "40",
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
                      "40",
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
    var coinProv = Provider.of<Coins>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: klightDeepBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                Image.asset('assets/images/slot-machine.jpg'),
                Positioned(
                  left: 85,
                  right: 84,
                  top: 114,
                  child: Container(
                    width: 80,
                    height: 91,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 10,
                          child: RollerList(
                            items: slots,
                            enabled: false,
                            key: leftRoller,
                            onSelectedIndexChanged: (value) {
                              setState(() {
                                first = value - 1;
                              });
                            },
                          ),
                        ),
                        VerticalDivider(
                          thickness: 5.0,
                          width: 2,
                          color: Colors.black,
                        ),
                        Expanded(
                          flex: 10,
                          child: RollerList(
                            items: slots,
                            enabled: false,
                            key: centerRoller,
                            onSelectedIndexChanged: (value) {
                              setState(() {
                                second = value - 1;
                              });
                            },
                          ),
                        ),
                        VerticalDivider(
                          thickness: 5.0,
                          width: 2,
                          color: Colors.black,
                        ),
                        Expanded(
                          flex: 10,
                          child: RollerList(
                            enabled: false,
                            items: slots,
                            key: rightRoller,
                            onSelectedIndexChanged: (value) {
                              setState(() {
                                third = value - 1;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.transparent ,
          ),
          RaisedButton(
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
            color: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 15,
            ),
            onPressed: () async{
              var res =  await registerSpin(coinProv);
             if(res) {
                _startRotating();
                Future.delayed(
                  Duration(milliseconds: 5000),
                  () {
                    _finishRotating();
                  },
                );
                Future.delayed(
                  Duration(milliseconds: 6000),
                  () {
                    if (first == second || second == third || third == first) {
                      _onBasicAlertPressed(context);
                    } else if (first == second && third == second) {
                      _onBasicAlertPressed1(context);
                    }
                    else if (first != second && third != second) {
                      _onBasicAlertPressed3(context);
                    }
                  },
                );
              }else{
               noSpinDialog(context, coinProv);
             }
            },
          ),
        ],
      ),
    );
  }

  double _randomeTime() => (Random().nextDouble());
  void _startRotating() {
    rotator = Timer.periodic(_ROTATION_DURATION, _rotateRoller);
  }

  void _rotateRoller(_) {
    final leftRotationTarget = _random.nextInt(3 * slots.length);
    final rightRotationTarget = _random.nextInt(3 * slots.length);
    final centerRotationTarget = _random.nextInt(3 * slots.length);

    leftRoller.currentState?.smoothScrollToIndex(leftRotationTarget,
        duration: _ROTATION_DURATION, curve: Curves.linear);
    centerRoller.currentState?.smoothScrollToIndex(centerRotationTarget,
        duration: _ROTATION_DURATION, curve: Curves.linear);
    rightRoller.currentState?.smoothScrollToIndex(rightRotationTarget,
        duration: _ROTATION_DURATION, curve: Curves.linear);
  }

  void _finishRotating() {
    rotator?.cancel();
  }

  _onBasicAlertPressed(context) {
    Alert(
      context: context,
      title: "Congratulation",
      desc: "You won 50",
      buttons: [
        DialogButton(
          color: Colors.purple,
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
            coinProv.addCoins(50
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    ).show();
  }
  _onBasicAlertPressed3(context) {
    Alert(
      context: context,
      title: "Bad Luck",
      desc: "sorry! better luck next time",
      buttons: [
        DialogButton(
          color: Colors.purple,
          radius: BorderRadius.all(
            Radius.circular(10),
          ),
          child: Text(
            "ok",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ).show();
  }

  _onBasicAlertPressed1(context) {
    Alert(
      context: context,
      title: "Congratulation",
      desc: "You won 70",
      buttons: [
        DialogButton(
          color: Colors.purple,
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
            coinProv.addCoins(70);
            Navigator.of(context).pop();
          },
        ),
      ],
    ).show();
  }

  static List<Widget> _getSlots() {
    List<Widget> result = new List();
    for (int i = 0; i <= 9; i++) {
      result.add(Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(0)),
            surfaceIntensity: 1.0,
            color: Colors.white),
        child: Image.asset(
          "assets/images/$i.png",
          width: double.infinity,
          height: double.infinity,
        ),
      ));
    }
    return result;
  }
}
