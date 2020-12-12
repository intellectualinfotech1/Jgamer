import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jgamer/Spinner_wheel.dart';
import 'package:jgamer/coins.dart';
import 'package:jgamer/constants.dart';
import 'package:jgamer/games_front_page.dart';
import 'package:jgamer/home_page.dart';
import 'package:jgamer/main.dart';
import 'package:jgamer/memorygame.dart';
import 'package:jgamer/tictactoe.dart';
import 'package:jgamer/user_profile.dart';
import 'package:jgamer/scratch_card.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final Map userData;
  final List userKeys;
  Home(this.userData, this.userKeys);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currenIndex = 0;
  int score = 0;
  var currentCoins;

  @override
  void initState() {
    currentCoins = widget.userKeys[1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var coinProvider = Provider.of<Coins>(context);
    coinProvider.loadUser(widget.userKeys[2], widget.userKeys[0]);
    currentCoins = coinProvider.getCoins;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 30,
        toolbarHeight: 80,
        actions: [
          Image.asset(
            "assets/diamond.png",
            height: 25,
            width: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, right: 15, left: 10),
            child: Text(
              currentCoins.toString(),
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
        GamesFrontPage(),
        Roulette(),
        Container(),
        UserProfile(widget.userData, widget.userKeys),
      ][currenIndex],
      bottomNavigationBar: CurvedNavigationBar(
        onTap: changePage,
        height: 50.0,
        items: <Widget>[
          Icon(
            Icons.card_giftcard_sharp,
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
            Icons.shopping_basket,
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
