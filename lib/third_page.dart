import 'package:flutter/material.dart';
import 'package:jgamer/sloat_machine.dart';
import 'Spinner_wheel.dart';
import 'constants.dart';

class ThiredPage extends StatelessWidget {
  var games = [
    {
      "name": "Spin & Earn",
      "game": Roulette(),
      "thumb": "Image/roulette-8-300.png"
    },
    {
      "name": "Slot Machine",
      "game": SlotMachine(),
      "thumb": "assets/images/slot-machine.jpg"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
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
                      borderRadius: BorderRadius.all(Radius.circular(15)),
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
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
    );
  }
}
