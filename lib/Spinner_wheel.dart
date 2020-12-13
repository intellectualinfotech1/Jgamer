import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
import 'package:jgamer/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Roulette extends StatefulWidget {
  @override
  _RouletteState createState() => _RouletteState();
}

class _RouletteState extends State<Roulette> {
  final StreamController _dividerController = StreamController<int>();

  final _wheelNotifier = StreamController<double>();

  dispose() {
    _dividerController.close();
    _wheelNotifier.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 310,
              height: 310,
              child: Stack(
                children: [
                  Container(
                    width: 310,
                    height: 310,
                    child: SpinningWheel(
                      Image.asset('Image/roulette-8-300.jpeg'),
                      width: 310,
                      height: 310,
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
                    width: 310,
                    height: 310,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                    ),
                  ),
                ],
              ),
            ),
            // SpinningWheel(
            //   Image.asset('Image/roulette-8-300.png'),
            //   width: 310,
            //   height: 310,
            //   initialSpinAngle: _generateRandomAngle(),
            //   spinResistance: 0.6,
            //   canInteractWhileSpinning: false,
            //   dividers: 8,
            //   onUpdate: _dividerController.add,
            //   onEnd: _dividerController.add,
            //   secondaryImage: Image.asset('Image/cpointer.png'),
            //   secondaryImageHeight: 50,
            //   secondaryImageWidth: 50,
            //   shouldStartOrStop: _wheelNotifier.stream,
            // ),
            SizedBox(height: 30),
            StreamBuilder(
              stream: _dividerController.stream,
              builder: (context, snapshot) =>
                  snapshot.hasData ? RouletteScore(snapshot.data) : Container(),
            ),
            SizedBox(height: 30),
            new RaisedButton(
              child: new Text(
                "Spin",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Quicksand",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: klightDeepBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 70),
              onPressed: () {
                _wheelNotifier.sink.add(_generateRandomVelocity());
                Future.delayed(
                  Duration(milliseconds: 5000),
                  () {
                    _onAlertButtonPressed(context);
                  },
                );
              },
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
    return Text('${labels[selected]}',
        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24.0));
  }
}

_onAlertButtonPressed(context) {
  Alert(
    context: context,
    type: AlertType.error,
    title: "RFLUTTER ALERT",
    desc: "Flutter is more awesome with RFlutter Alert.",
    buttons: [
      DialogButton(
          child: Text(
            "COOL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {})
    ],
  ).show();
}
