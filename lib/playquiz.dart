import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jgamer/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'coins.dart';

class Playquiz extends StatelessWidget {
  final String url;
  Playquiz(this.url);
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
                  "assets/3.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: FlatButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => AdsPage(url),
                  ),
                ),
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
          ],
        ),
      ),
    );
  }
}

class AdsPage extends StatelessWidget {
  final String qUrl;
  AdsPage(this.qUrl);
  @override
  Widget build(BuildContext context) {
    var fQUrl = jsonDecode(qUrl)["link"];
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
                "Play quiz and win Rewards",
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
                onPressed: () {
                  if (fQUrl == "INSERT/LINK/HERE") {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        content: Text(
                          "Quiz coming soon...",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        actions: [
                          RaisedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            color: klightDeepBlue,
                            child: Text(
                              "OK",
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    _launchURL();
                  }
                },
                color: klightDeepBlue,
                child: Text(
                  "Play",
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

  void _launchURL() async {
    var fQUrl = jsonDecode(qUrl)["link"];
    await launch(fQUrl);
    //   if (await canLaunch(fQUrl)) {
    //     await launch(fQUrl);
    //   } else {
    //     throw 'Could not launch $fQUrl';
    //   }
  }
}
