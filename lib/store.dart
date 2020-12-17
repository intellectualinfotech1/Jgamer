import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jgamer/coins.dart';
import 'package:provider/provider.dart';
import 'package:jgamer/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  var currentSelection2;
  var _controller = TextEditingController();

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
                return storeData.keys.toList()[index] == "PUBG Assets"
                    ? Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        elevation: 10,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: GestureDetector(
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
                                    storeData[storeData.keys.toList()[index]]
                                        ["Weapons"][0]['imgurl'],
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
                      )
                    : Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        elevation: 10,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: GestureDetector(
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
                                    storeData[storeData.keys.toList()[index]][0]
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
      return currentSelection == "PUBG Assets"
          ? Column(
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
                    itemBuilder: (ctx, index) {
                      var temp = storeData[currentSelection].keys.toList();
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        elevation: 10,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            currentSelection2 = temp[index].toString();
                            setState(() {
                              currentLevel = Level.three;
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
                                    storeData["PUBG Assets"][temp[index]][2]
                                        ["imgurl"],
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
                                    temp[index].toString(),
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
                    itemCount: storeData[currentSelection].keys.toList().length,
                  ),
                ),
              ],
            )
          : Column(
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
                              onTap: () {
                                showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    title: Text(
                                      "Do you want to purchase ${storeData[currentSelection][index]["Cash"]} for ${storeData[currentSelection][index]["Diamonds"]} diamonds ?",
                                      style: TextStyle(
                                        fontFamily: "Quicksand",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    actions: [
                                      RaisedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        padding: EdgeInsets.symmetric(
                                            vertical: 7, horizontal: 18),
                                        child: Row(
                                          children: [
                                            Icon(Icons.cancel),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Cancel",
                                              style: TextStyle(
                                                fontFamily: "Quicksand",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          var coinProv = Provider.of<Coins>(
                                              context,
                                              listen: false);
                                          if (coinProv.getCoins >=
                                              int.parse(
                                                  storeData[currentSelection]
                                                      [index]["Diamonds"])) {
                                            coinProv.reduceCoins(int.parse(
                                                storeData[currentSelection]
                                                    [index]["Diamonds"]));
                                            Navigator.of(context).pop();
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              child: AlertDialog(
                                                title: Text(
                                                  "Enter you mobile number here, your reward will be added to your account in 7 business days",
                                                  style: TextStyle(
                                                    fontFamily: "Quicksand",
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                content: TextField(
                                                  controller: _controller,
                                                  maxLengthEnforced: true,
                                                  maxLength: 10,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    labelText: "Mobile Number",
                                                  ),
                                                ),
                                                actions: [
                                                  RaisedButton(
                                                    onPressed: () async {
                                                      if (_controller
                                                              .text.length ==
                                                          10) {
                                                        Navigator.of(context)
                                                            .pop();
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          child: Center(
                                                            child: Container(
                                                              height: 150,
                                                              width: 150,
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                          ),
                                                        );
                                                        await Future.delayed(
                                                          Duration(seconds: 3),
                                                          () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        );
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          child: AlertDialog(
                                                            title: Text(
                                                              "Congratulations...\n\nYour purchase is approved on our servers. \nIt will be added to your account in 7 working days",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Quicksand",
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            actions: [
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                color:
                                                                    klightDeepBlue,
                                                                child: Text(
                                                                  "OK",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        "Quicksand",
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    color: klightDeepBlue,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 7,
                                                            horizontal: 18),
                                                    child: Text(
                                                      "Submit",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: "Quicksand",
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              child: AlertDialog(
                                                title: Text(
                                                  "You do not have enough diamonds",
                                                  style: TextStyle(
                                                    fontFamily: "Quicksand",
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                content: RaisedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  },
                                                  color: klightDeepBlue,
                                                  child: Text(
                                                    "OK",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "Quicksand",
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        padding: EdgeInsets.symmetric(
                                            vertical: 7, horizontal: 18),
                                        child: Row(
                                          children: [
                                            Text(
                                              storeData[currentSelection][index]
                                                  ["Diamonds"],
                                              style: TextStyle(
                                                fontFamily: "Quicksand",
                                                fontSize: 15,
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
                                    ],
                                  ),
                                );
                              },
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
                                child: Column(
                                  children: [
                                    Expanded(
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
                                  ],
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
    } else {
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
                      currentSelection2 = null;
                      currentLevel = Level.two;
                    });
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  currentSelection2,
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
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: currentSelection2 == "Outfits" ? 0.6 : 1,
              ),
              itemBuilder: (ctx, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  elevation: 10,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Image.network(
                            storeData[currentSelection][currentSelection2]
                                [index]["imgurl"],
                          ),
                          content: Text(
                            "Do you want to buy this item for ${storeData[currentSelection][currentSelection2][index]['Diamonds']} diamonds ?",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          actions: [
                            RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 18),
                              child: Row(
                                children: [
                                  Icon(Icons.cancel),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              onPressed: () {
                                var coinProv =
                                    Provider.of<Coins>(context, listen: false);
                                if (coinProv.getCoins >=
                                    int.parse(storeData[currentSelection]
                                            [currentSelection2][index]
                                        ["Diamonds"])) {
                                  coinProv.reduceCoins(int.parse(
                                      storeData[currentSelection]
                                              [currentSelection2][index]
                                          ["Diamonds"]));
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    child: AlertDialog(
                                      title: Text(
                                        "Enter you PUBG ID here, your reward will be added to your account in 7 business days",
                                        style: TextStyle(
                                          fontFamily: "Quicksand",
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      content: TextField(
                                        controller: _controller,
                                        decoration: InputDecoration(
                                          labelText: "PUBG ID",
                                        ),
                                      ),
                                      actions: [
                                        RaisedButton(
                                          onPressed: () async {
                                            if (_controller.text.isNotEmpty) {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                child: Center(
                                                  child: Container(
                                                    height: 150,
                                                    width: 150,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                              );
                                              await Future.delayed(
                                                Duration(seconds: 3),
                                                () {
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                child: AlertDialog(
                                                  title: Text(
                                                    "Congratulations...\n\nYour purchase is approved on our servers. \nIt will be added to your PUBG account in 7 working days",
                                                    style: TextStyle(
                                                      fontFamily: "Quicksand",
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  actions: [
                                                    RaisedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      color: klightDeepBlue,
                                                      child: Text(
                                                        "OK",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              "Quicksand",
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                          color: klightDeepBlue,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 7, horizontal: 18),
                                          child: Text(
                                            "Submit",
                                            style: TextStyle(
                                              color: Colors.white,
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
                                  showDialog(
                                    context: context,
                                    child: AlertDialog(
                                      title: Text(
                                        "You do not have enough diamonds",
                                        style: TextStyle(
                                          fontFamily: "Quicksand",
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      content: RaisedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        color: klightDeepBlue,
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Quicksand",
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  Text(
                                    storeData[currentSelection]
                                        [currentSelection2][index]["Diamonds"],
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 15,
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
                          ],
                        ),
                      );
                    },
                    child: GridTile(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        child: Image.network(
                          storeData[currentSelection][currentSelection2][index]
                              ["imgurl"],
                          fit: BoxFit.cover,
                        ),
                      ),
                      footer: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          storeData[currentSelection][currentSelection2][index]
                              ["Name"],
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: storeData[currentSelection][currentSelection2].length,
            ),
          ),
        ],
      );
    }
  }
}
