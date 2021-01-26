import 'package:flutter/material.dart';
import 'package:jgamer/constants.dart';
import 'package:provider/provider.dart';
import 'coins.dart';

class AdsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  "assets/2.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: FlatButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => AdsPage(),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                child: Text(
                  "Watch Ads and Earn Money",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Quicksand",
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
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

class AdsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var coinProvider = Provider.of<Coins>(context);
    var currentCoins = coinProvider.getCoins;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: klightDeepBlue,
        toolbarHeight: 60,
        actions: [
          Image.asset(
            "assets/diamond.png",
            height: 25,
            width: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 13, right: 15, left: 10),
            child: Text(
              currentCoins.toString(),
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Quicksand",
              ),
            ),
          )
        ],
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
