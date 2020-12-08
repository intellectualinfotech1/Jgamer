import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jgamer/Spinner_wheel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: <Widget>[
          Padding(padding: EdgeInsets.all(10.0)),
          Text('score',style: TextStyle(
            color: Colors.black,
            backgroundColor: Colors.white
          ),)
        ],

      ),

      body: <Widget>[
        Container(color: Colors.white,),
        Container(color: Colors.blue,),
        Roulette(),
        Container(color: Colors.red,),
      ][currenIndex],

      bottomNavigationBar: CurvedNavigationBar(
        onTap: changePage,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.attach_money_rounded, size: 30, color: Colors.white,),
          Icon(Icons.widgets, size: 30, color: Colors.white,),
          Icon(Icons.album_rounded, size: 30, color: Colors.white,),
          Icon(Icons.perm_identity, size: 30, color: Colors.white,),
        ],
        color: Colors.red,
        buttonBackgroundColor: Colors.red,
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
