import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jgamer/home_page.dart';
import 'package:jgamer/memorygame.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

class GamesFrontPage extends StatelessWidget {
  final http.Response leaderBoard;
  GamesFrontPage(this.leaderBoard);
  var games = [
    {
      "name": "Tic Tac Toe",
      "game": HomePage(),
      "thumb": "Image/itctactoeimg.jpg"
    },
    {
      "name": "Memory Game",
      "game": Memory(),
      "thumb": "Image/memorygameimg.jpg"
    },
  ];
  @override
  Widget build(BuildContext context) {
    print(leaderBoard);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            LeaderBoard(leaderBoard),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => games[index]["game"],
                          ),
                        );
                      },
                      child: Container(
                        height: 160,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              child: Image.asset(
                                games[index]["thumb"],
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                color: kdeepBlue,
                                child: Text(
                                  games[index]["name"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Quicksand",
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: games.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaderBoard extends StatefulWidget {
  final http.Response leaderBoard;
  LeaderBoard(this.leaderBoard);
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  List leaderBoard;

  @override
  Widget build(BuildContext context) {
    leaderBoard = jsonDecode(widget.leaderBoard.body).toList();
    return Container(
      height: 270,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        margin: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 8,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 10,
              ),
              child: Text(
                "LeaderBoard",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return Container(
                    height: 35,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        child: Container(
                          alignment: Alignment.center,
                          width: 30,
                          height: 30,
                          color: Colors.blue[800],
                          child: Text(
                            "# ${(index + 1).toString()}",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Quicksand",
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        leaderBoard[index]["name"],
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Container(
                        width: 80,
                        height: 50,
                        child: Row(
                          children: [
                            Text(
                              leaderBoard[index]["coins"].toString(),
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Image.asset(
                              "assets/diamond.png",
                              width: 15,
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
