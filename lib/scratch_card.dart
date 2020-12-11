import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';



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

  var list = ['\$200','\$300','\$400','\$500','\$600'];


  final _random = new Random();


  Future<void> scratchCardDialog(BuildContext context) {
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
              threshold: 1,
              brushSize: 20,
              onThreshold: () {
                setState(() {
                  _opacity = 1;
                });
              },
              image: Image.asset('Image/scratchcard.jpg'),

              child: AnimatedOpacity(
                duration: Duration(milliseconds: 250),
                opacity: _opacity,
                child: Container(
                  height: 200,
                  width: 300,
                  alignment: Alignment.center,
                  child:Text(
                    getRandomElement(list),
                     style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
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
        color: Colors.red,
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


}
