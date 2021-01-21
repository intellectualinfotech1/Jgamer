import 'package:flutter/material.dart';
import 'package:jgamer/constants.dart';

class TasksButton extends StatelessWidget {
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
              builder: (ctx) => TasksPage(),
            ),
          ),
          color: klightDeepBlue,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          child: Text(
            "Complete Tasks and Earn Money",
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

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: klightDeepBlue,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
                left: MediaQuery.of(context).size.height * 0.05,
              ),
              alignment: Alignment.center,
              child: Text(
                "Complete the tasks to earn 40 diamonds",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                left: MediaQuery.of(context).size.height * 0.05,
              ),
              child: Text(
                "1. Load the Ad from button below",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 22,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                left: MediaQuery.of(context).size.height * 0.05,
              ),
              child: Text(
                "2. Click on it",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 22,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                left: MediaQuery.of(context).size.height * 0.05,
              ),
              child: Text(
                "3. Install the app and recieve your diamonds",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 22,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                left: MediaQuery.of(context).size.height * 0.05,
              ),
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