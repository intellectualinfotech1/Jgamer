import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scratcher/scratcher.dart';
import 'package:dart_random_choice/dart_random_choice.dart';





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


  var list = ['\$200','\$0','\$300','\$0','\$400','\$0','\$500','\$0','\$600','\$0',];



  Future<void> scratchCardDialog(BuildContext context) {
     no  = getRandomElement(list);


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
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          content: StatefulBuilder(builder: (context, StateSetter setState) {

            return Scratcher(
              accuracy: ScratchAccuracy.low,
              threshold: 40,
              brushSize: 20,
              onThreshold: () {
                setState(() {
                  _onAlertButtonPressed(context);
                });
              },

              image: Image.asset('Image/scratchcard.jpg'
              ),

              child: Container(
                  height: 200,
                  width: 300,
                  alignment: Alignment.center,
                  child:Text(
                   "$no",
                     style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
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


    return Container(
      alignment: Alignment.center,
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
            fontSize: 25,
          ),
        ),
        onPressed: () {
          scratchCardDialog(context);

        }
      ),
    );
  }

   getRandomElement(List<String> list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
  }
  _onAlertButtonPressed(context) {
    Alert(
      context: context,
      type: AlertType.none,
      title: "You Won",
      desc: "$no",
      buttons: [
        DialogButton(
          child: Text(
            "Redem",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
          }
        )
      ],
    ).show();
  }



}
