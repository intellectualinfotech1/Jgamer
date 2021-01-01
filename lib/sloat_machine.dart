import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roller_list/roller_list.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'coins.dart';


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

  @override
  Widget build(BuildContext context) {
    return Column(

      children: <Widget>[
        SizedBox(
          height: 37.0,
        ),
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
                  width:80,
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
        DialogButton(
          color: Colors.purple,
            radius: BorderRadius.all(
              Radius.circular(10),
            ),

            onPressed: () {
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
                  if(first == second || second == third || third == first){
                    _onBasicAlertPressed(context);
                  }
                  else if(first == second && third == second){
                    _onBasicAlertPressed(context);

                  }
                },
              );

            },
          child: Text(
          "start",
          style: TextStyle(

              color: Colors.white,
              fontSize: 20,
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold),
        ),
        ),

      ],
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
      desc: "You won 20",
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
            coinProv.addCoins(20);
            Navigator.of(context).pop();
          },
        ),
      ],
    ).show();
  }

  static List<Widget> _getSlots() {
    List<Widget> result = new List();
    for (int i = 0; i <=  9 ; i++) {
      result.add(
          Neumorphic(

            style: NeumorphicStyle(
                shape: NeumorphicShape.convex,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(0)),
               surfaceIntensity: 1.0,

                color: Colors.white

            ),
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