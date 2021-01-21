import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jgamer/home_page.dart';
import 'package:jgamer/memorygame.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

class GamesFrontPage extends StatelessWidget {
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
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
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
