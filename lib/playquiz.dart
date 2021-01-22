import 'package:flutter/material.dart';
import 'package:jgamer/constants.dart';

class playquiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: FlatButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AdsPage(),
            ),
          ),
          color: klightDeepBlue,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          child: Text(
            "Play quiz & Earn",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Quicksand",
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class AdsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: klightDeepBlue,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.1,
                horizontal: MediaQuery.of(context).size.height * 0.05,
              ),
              child: Text(
                "Watch a complete ad and earn 20 diamonds",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              height: 80,
              width: 200,
              child: RaisedButton(
                onPressed: () {},
                color: klightDeepBlue,
                child: Text(
                  "Load Ad",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Quicksand",
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
