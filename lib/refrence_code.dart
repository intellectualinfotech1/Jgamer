import 'dart:convert';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'coins.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RefrenceScreen extends StatefulWidget {
  List userKeys;
  RefrenceScreen(this.userKeys);
  @override
  _RefrenceScreenState createState() => _RefrenceScreenState();
}

class _RefrenceScreenState extends State<RefrenceScreen> {
  var stage = 0;
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
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
      body: stage == 0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 50),
                  child: Text(
                    "Do you have a refrence code ?",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 50,
                        child: Text(
                          "No",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Quicksand",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      color: Colors.red[400],
                      onPressed: () {
                        Navigator.of(context).pop();
                        refferalShown();
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FlatButton(
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 50,
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Quicksand",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      color: Colors.cyan,
                      onPressed: () {
                        setState(() {
                          stage = 1;
                        });
                      },
                    ),
                  ],
                ),
              ],
            )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: "Refferal Code",
                      labelStyle: TextStyle(
                        fontFamily: "Quicksand",
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 120,
                  child: RaisedButton(
                    onPressed: () async {
                      if (controller.text.length >= 5 &&
                          controller.text.length <= 7) {
                        await makeRefrence(controller.text, context);
                        refferalShown();
                      } else {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          child: AlertDialog(
                            title: Text(
                              "Invalid Refrence Code",
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            content: RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              color: klightDeepBlue,
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  fontFamily: "Quicksand",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    color: klightDeepBlue,
                    child: Container(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> refferalShown() async {
    var temp = await http.get(
        "https://jgamer-347e6-default-rtdb.firebaseio.com/users/${widget.userKeys[0]}.json");
    var temp2 = jsonDecode(temp.body);
    temp2["refrenceOffered"] = true;
    widget.userKeys[2] = temp2;
    await http.patch(
        "https://jgamer-347e6-default-rtdb.firebaseio.com/users/${widget.userKeys[0]}.json",
        body: jsonEncode(temp2));
    var prefs = await SharedPreferences.getInstance();
    var userr = jsonDecode(prefs.getString("userData"));
    userr["user"]["refrenceOffered"] = true;
    prefs.setString("userData", jsonEncode(userr));
  }

  Future<void> makeRefrence(String code, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      ),
    );
    var refUrl =
        "https://jgamer-347e6-default-rtdb.firebaseio.com/refrences.json";
    var res = await http.get(
        "https://jgamer-347e6-default-rtdb.firebaseio.com/refrences/$code.json");
    var finalRes = jsonDecode(res.body);
    var temp = await http.get(refUrl).then((value) => jsonDecode(value.body));
    temp[code] = [
      {
        "referedTo": widget.userKeys[2]["referId"],
        "moneyCollectedbyReciever": true,
        "moneyCollectedbySender": false
      }
    ];
    Navigator.of(context).pop();
    if (finalRes == null) {
      await http.patch(
          "https://jgamer-347e6-default-rtdb.firebaseio.com/refrences.json",
          body: jsonEncode(temp));
      showDialog(
        context: context,
        barrierDismissible: false,
        child: AlertDialog(
          title: Text(
            "A Reference has been made",
            style: TextStyle(
              fontFamily: "Quicksand",
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: RaisedButton(
            onPressed: () async {
              var coinProv = Provider.of<Coins>(context, listen: false);
              coinProv.addCoins(50);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            color: klightDeepBlue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Reedem 50",
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Image.asset(
                  "assets/diamond.png",
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      var tempList = [];
      for (var ref in finalRes) {
        tempList.add(ref["referedTo"]);
      }
      if (!tempList.contains(widget.userKeys[2]["referId"])) {
        finalRes.add(
          {
            "moneyCollectedbyReceiver": false,
            "moneyCollectedbySender": false,
            "referedTo": widget.userKeys[2]["referId"],
          },
        );
      }
      for (var ref in finalRes) {
        if (ref["referedTo"] == widget.userKeys[2]["referId"]) {
          showDialog(
            context: context,
            barrierDismissible: false,
            child: AlertDialog(
              title: Text(
                "A Reference has been made",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: RaisedButton(
                onPressed: () async {
                  if (ref["moneyCollectedbyReceiver"] == false) {
                    var coinProv = Provider.of<Coins>(context, listen: false);
                    ref["moneyCollectedbyReceiver"] = true;
                    coinProv.addCoins(50);
                    await http.patch(
                        "https://jgamer-347e6-default-rtdb.firebaseio.com/refrences.json",
                        body: jsonEncode({code: finalRes}));
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      child: AlertDialog(
                        title: Text(
                          "Diamonds already collected",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: klightDeepBlue,
                          child: Text(
                            "OK",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
                color: klightDeepBlue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Reedem 50",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      "assets/diamond.png",
                      width: 16,
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    }
  }
}
