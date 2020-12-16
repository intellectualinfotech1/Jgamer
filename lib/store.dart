import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jgamer/constants.dart';

class Store extends StatefulWidget {
  final Response linkData;
  Store(this.linkData);
  @override
  _StoreState createState() => _StoreState();
}

enum Level {
  one,
  two,
  three,
}

class _StoreState extends State<Store> {
  var currentLevel = Level.one;
  var currentSelection;

  @override
  Widget build(BuildContext context) {
    var storeData = jsonDecode(widget.linkData.body);
    if (currentLevel == Level.one) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Text(
              "Store",
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
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  elevation: 10,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: InkWell(
                    onTap: () {
                      currentSelection = storeData.keys.toList()[index];
                      setState(() {
                        currentLevel = Level.two;
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Image.network(
                              storeData[storeData.keys.toList()[index]][index]
                                  ['imgurl'],
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 200,
                          width: double.infinity,
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              color: kdeepBlue,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            height: 50,
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              storeData.keys.toList()[index],
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: storeData.keys.length,
            ),
          ),
        ],
      );
    } else if (currentLevel == Level.two) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      currentSelection = null;
                      currentLevel = Level.one;
                    });
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  currentSelection,
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  elevation: 10,
                  child: Container(
                    height: 100,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: ListTile(
                        leading: Image.network(
                          storeData[currentSelection][index]["imgurl"],
                          height: 300,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          storeData[currentSelection][index]["Cash"],
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        trailing: Container(
                          width: 100,
                          height: 50,
                          child: Expanded(
                            child: Row(
                              children: [
                                Text(
                                  storeData[currentSelection][index]
                                      ["Diamonds"],
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
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
                      ),
                    ),
                  ),
                );
              },
              itemCount: storeData[currentSelection].toList().length,
            ),
          ),
        ],
      );
    }
  }
}
