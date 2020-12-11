import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jgamer/Spinner_wheel.dart';
import 'package:jgamer/constants.dart';
import 'package:jgamer/user_profile.dart';
import 'package:jgamer/scratch_card.dart';

class Home extends StatefulWidget {
  final Map userData;
  final List userKeys;
  Home(this.userData, this.userKeys);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 30,
        toolbarHeight: 80,
        actions: [
          Icon(Icons.monetization_on),
          Padding(
            padding: const EdgeInsets.only(top: 24, right: 15, left: 10),
            child: Text(
              widget.userKeys[1].toString(),
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Quicksand",
              ),
            ),
          )
        ],
        title: Text(
          "jGamer",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: klightDeepBlue,
      ),
      body: <Widget>[
        ScratchCard(),
        Container(
          color: Colors.blue,
        ),
        Roulette(),
        UserProfile(widget.userData, widget.userKeys),
      ][currenIndex],
      bottomNavigationBar: CurvedNavigationBar(
        onTap: changePage,
        height: 50.0,
        items: <Widget>[
          Icon(
            Icons.attach_money_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.widgets,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.album_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.perm_identity,
            size: 30,
            color: Colors.white,
          ),
        ],
        color: klightDeepBlue,
        buttonBackgroundColor: kdeepBlue,
        backgroundColor: Colors.white,
        animationCurve: Curves.ease,
        animationDuration: Duration(milliseconds: 600),
      ),
    );
  }

  void changePage(int index) {
    setState(() {
      currenIndex = index;
    });
  }
}
